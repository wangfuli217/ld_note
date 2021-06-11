/*
 * ZunkDB client.
 */

#define _GNU_SOURCE
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <fcntl.h>
#include <unistd.h>
#include <openssl/sha.h>
#include <netdb.h>

#include <event.h>

#include "zunkfs.h"
#include "chunk-db.h"
#include "utils.h"
#include "mutex.h"
#include "base64.h"
#include "list.h"

struct zdb_info {
    struct sockaddr_in start_node;
    struct timeval request_timeout;
    struct timeval connect_timeout;
    const char *store_method;
};

struct addr_queue {
    struct sockaddr_in *addrs;
    int head, len;
};

enum request_state { request_pending, request_waiting, request_timedout,
    request_complete
};

struct request {
    struct evbuffer *evbuf;
    struct event_base *base;
    unsigned char *chunk;
    const unsigned char *digest;
    enum request_state state;
    struct addr_queue addr_queue;
    struct list_head connecting_nodes;
    struct timeval connect_timeout;
    struct timeval timeout;
    struct event timeout_event;
};

enum node_state { node_connecting, node_ready, node_dead };

struct node {
    int fd;
    enum node_state state;
    struct event connect_event;
    struct timeval connect_timeout;
    struct bufferevent *bev;
    struct sockaddr_in addr;
    struct request *request;
    struct list_head node_entry;
};

#define CACHE_MAX	100

static LIST_HEAD (node_cache);
static unsigned cache_count = 0;
static DECLARE_MUTEX (cache_mutex);

static inline int same_addr (const struct sockaddr_in *a, const struct sockaddr_in *b) {
    return a->sin_addr.s_addr == b->sin_addr.s_addr && a->sin_port == b->sin_port;
}

static inline int node_is_addr (const struct node *node, const struct sockaddr_in *addr) {
    return same_addr (&node->addr, addr);
}

static inline void addr_queue_init (struct addr_queue *q) {
    q->len = q->head = 0;
    q->addrs = (void *) 0;
}

static inline void addr_queue_destroy (struct addr_queue *q) {
    free (q->addrs);
}

static inline int addr_queue_empty (const struct addr_queue *q) {
    return q->head == q->len;
}

static int queue_addr (struct addr_queue *q, const struct sockaddr_in *addr) {
    struct sockaddr_in *addrs;
    int i;

    if (!addr)
        return 0;

    for (i = 0; i < q->len; i++)
        if (same_addr (addr, &q->addrs[i]))
            return 0;

    addrs = realloc (q->addrs, (q->len + 1) * sizeof (struct sockaddr_in));
    if (!addrs)
        return 0;

    q->addrs = addrs;
    q->addrs[q->len++] = *addr;

    return 1;
}

static int dequeue_addr (struct addr_queue *q, struct sockaddr_in *addr) {
    if (q->head == q->len)
        return 0;

    *addr = q->addrs[q->head++];
    return 1;
}
static inline int try_connect (struct node *node) {
    return connect (node->fd, (struct sockaddr *) &node->addr, sizeof (struct sockaddr_in)) ? -errno : 0;
}

static void kill_node (struct node *node) {
    TRACE ("node=%p %s:%u\n", node, inet_ntoa (node->addr.sin_addr), ntohs (node->addr.sin_port));

    assert (node->state != node_dead);

    list_del (&node->node_entry);
    bufferevent_free (node->bev);
    close (node->fd);

    memset (node, 0xff, sizeof (struct node));
    node->state = node_dead;
}

static struct node *find_node (const struct sockaddr_in *addr) {
    struct node *node;

    TRACE ("%s:%u\n", inet_ntoa (addr->sin_addr), ntohs (addr->sin_port));

    lock (&cache_mutex);
    list_for_each_entry (node, &node_cache, node_entry) {
        if (node_is_addr (node, addr)) {
            list_del_init (&node->node_entry);
            if (node->state == node_ready)
                cache_count--;
            goto found;
        }
    }
    node = NULL;
  found:
    unlock (&cache_mutex);

    TRACE ("%s:%u => %p\n", inet_ntoa (addr->sin_addr), ntohs (addr->sin_port), node);
    return node;
}

static void store_node (struct request *request, char *addr_str) {
    TRACE ("request=%p addr=%s\n", request, addr_str);
    if (!queue_addr (&request->addr_queue, string_sockaddr_in (addr_str))) {
        TRACE ("duplicate!\n");
    }
}

#define FIND_CHUNK		"find_chunk"
#define FIND_CHUNK_LEN		(sizeof(FIND_CHUNK) - 1)
#define STORE_CHUNK		"store_chunk"
#define STORE_CHUNK_LEN		(sizeof(STORE_CHUNK) - 1)
#define REQUEST_DONE		"request_done"
#define REQUEST_DONE_LEN	(sizeof(REQUEST_DONE) - 1)
#define STORE_NODE		"store_node"
#define STORE_NODE_LEN		(sizeof(STORE_NODE) - 1)
#define FORWARD_CHUNK		"forward_chunk"
#define FORWARD_CHUNK_LEN	(sizeof(FORWARD_CHUNK) - 1)

static int proc_msg (const char *buf, size_t len, struct node *node) {
    struct request *req = node->request;
    char *msg = alloca (len + 1);

    assert (msg != NULL);

    memcpy (msg, buf, len);
    msg[len] = 0;

    if (!strncmp (msg, STORE_CHUNK, STORE_CHUNK_LEN)) {
        msg += STORE_CHUNK_LEN + 1;
        if (req->chunk)
            base64_decode (msg, req->chunk, CHUNK_SIZE);

    } else if (!strncmp (msg, REQUEST_DONE, REQUEST_DONE_LEN)) {
        msg += REQUEST_DONE_LEN + 1;
        if (!strcmp (msg, digest_string (req->digest))) {
            if (req->chunk || addr_queue_empty (&req->addr_queue))
                req->state = request_complete;
            else
                req->state = request_pending;
            return 1;
        }

    } else if (!strncmp (msg, STORE_NODE, STORE_NODE_LEN)) {
        msg += STORE_NODE_LEN + 1;
        store_node (req, msg);
    }

    return 0;
}

static void readcb (struct bufferevent *bev, void *arg) {
    struct node *node = arg;
    const char *buf;
    const char *end;
    int drain_all = 0;

    for (;;) {
        buf = (const char *) EVBUFFER_DATA (bev->input);
        end = (const char *) evbuffer_find (bev->input, (u_char *) "\r\n", 2);
        if (!end)
            return;

        if (!drain_all)
            drain_all = proc_msg (buf, end - buf, node);
        evbuffer_drain (bev->input, end - buf + 2);
    }
}

static void errorcb (struct bufferevent *bev, short what, void *arg) {
    struct node *node = arg;
    struct request *r = node->request;

    TRACE ("node=%p %s:%u\n", node, inet_ntoa (node->addr.sin_addr), ntohs (node->addr.sin_port));

    assert (node->request != NULL);
    kill_node (node);
    r->state = request_pending;
}

static void __send_request_to (struct request *, struct node *);

static void connectcb (int fd, short event, void *arg) {
    struct node *node = arg;
    struct request *r = node->request;

    TRACE ("node=%p %s:%u request=%p event=%s\n", node, inet_ntoa (node->addr.sin_addr), ntohs (node->addr.sin_port), r, event == EV_TIMEOUT ? "EV_TIMEOUT" : "EV_READ");

    assert (node->request != NULL);

    if (event == EV_TIMEOUT) {
        r->state = request_pending;
        return;
    }

  again:
    switch (try_connect (node)) {
    case 0:
    case -EISCONN:
        node->state = node_ready;
        __send_request_to (r, node);
        break;
    case -EAGAIN:
        goto again;
    case -EALREADY:
    case -EINPROGRESS:
        TRACE ("node=%p retry\n", node);
        event_add (&node->connect_event, &node->connect_timeout);
        break;
    default:
        TRACE ("node=%p failed\n", node);
        kill_node (node);
        r->state = request_pending;
    }
}

static struct node *create_node (const struct sockaddr_in *addr) {
    struct node *node;
    int fl;

    TRACE ("%s:%u\n", inet_ntoa (addr->sin_addr), ntohs (addr->sin_port));

    node = malloc (sizeof (struct node));
    if (!node)
        return NULL;

    memset (node, 0, sizeof (struct node));

    node->fd = socket (AF_INET, SOCK_STREAM, 0);
    if (node->fd < 0) {
        ERROR ("socket: %s\n", strerror (errno));
        free (node);
        return NULL;
    }

    fl = fcntl (node->fd, F_GETFL);
    fcntl (node->fd, F_SETFL, fl | O_NONBLOCK);

    node->bev = bufferevent_new (node->fd, readcb, NULL, errorcb, node);
    if (!node->bev) {
        ERROR ("bufferevent_new: %s\n", strerror (errno));
        close (node->fd);
        free (node);
        return NULL;
    }

    node->addr = *addr;
    event_set (&node->connect_event, node->fd, EV_WRITE | EV_TIMEOUT, connectcb, node);

    list_head_init (&node->node_entry);

  again:
    switch (try_connect (node)) {
    case 0:
    case -EISCONN:
        node->state = node_ready;
        return node;
    case -EAGAIN:
        goto again;
    case -EINPROGRESS:
    case -EALREADY:
        node->state = node_connecting;
        return node;
    default:
        kill_node (node);
        free (node);
    }

    return NULL;
}

static void __send_request_to (struct request *request, struct node *node) {
    TRACE ("node=%s:%u request=%p\n", inet_ntoa (node->addr.sin_addr), ntohs (node->addr.sin_port), request);

    bufferevent_base_set (request->base, node->bev);
    bufferevent_write (node->bev, EVBUFFER_DATA (request->evbuf), EVBUFFER_LENGTH (request->evbuf));
    bufferevent_enable (node->bev, EV_READ | EV_WRITE);
}

static void send_request_to (struct request *request, struct node *node) {
    TRACE ("node=%s:%u request=%p\n", inet_ntoa (node->addr.sin_addr), ntohs (node->addr.sin_port), request);

    node->request = request;
    request->state = request_waiting;

    if (node->state == node_connecting) {
        node->connect_timeout = request->connect_timeout;
        event_base_set (request->base, &node->connect_event);
        event_add (&node->connect_event, &node->connect_timeout);
    } else
        __send_request_to (request, node);
}

static struct node *dequeue_node (struct request *request) {
    struct sockaddr_in addr;
    struct node *node;

    TRACE ("request=%p\n", request);

    while (dequeue_addr (&request->addr_queue, &addr)) {
        node = find_node (&addr);
        if (node)
            return node;

        node = create_node (&addr);
        if (node)
            return node;
    }

    if (list_empty (&request->connecting_nodes))
        return NULL;

    node = list_entry (request->connecting_nodes.next, struct node, node_entry);
    list_del_init (&node->node_entry);

    return node;
}

static void cache_node (struct node *node, struct request *request) {
    if (node->state == node_connecting) {
        list_add_tail (&node->node_entry, &request->connecting_nodes);
    } else if (node->state == node_dead) {
        free (node);
    } else if (cache_count < CACHE_MAX) {
        lock (&cache_mutex);
        cache_count++;
        list_add_tail (&node->node_entry, &node_cache);
        unlock (&cache_mutex);
    } else {
        kill_node (node);
        free (node);
    }
}

static void timeoutcb (int fd, short event, void *arg) {
    struct request *request = arg;
    request->state = request_timedout;
    TRACE ("request=%p\n", arg);
}

static int __issue_request (struct request *request) {
    struct node *node;

    while (request->state == request_pending) {
        node = dequeue_node (request);
        if (!node)
            return -EIO;

        send_request_to (request, node);

        while (request->state == request_waiting)
            if (event_base_loop (request->base, EVLOOP_ONCE))
                break;

        assert (request->state != request_waiting);

        cache_node (node, request);

        if (request->chunk && request->state == request_complete)
            if (!verify_chunk (request->chunk, request->digest))
                request->state = request_pending;
    }

    if (request->state == request_timedout)
        return -ETIMEDOUT;

    if (request->state == request_complete)
        return CHUNK_SIZE;

    return 0;
}

static int issue_request (struct evbuffer *evbuf, struct zdb_info *db_info, const unsigned char *digest, unsigned char *chunk) {
    struct request request;
    int error;

    request.base = event_base_new ();
    if (!request.base) {
        ERROR ("event_base: %s\n", strerror (errno));
        return -EIO;
    }

    if (chunk)
        memset (chunk, 0, CHUNK_SIZE);

    request.evbuf = evbuf;
    request.chunk = chunk;
    request.digest = digest;
    request.state = request_pending;
    request.connect_timeout = db_info->connect_timeout;
    request.timeout = db_info->request_timeout;

    addr_queue_init (&request.addr_queue);
    list_head_init (&request.connecting_nodes);

    timeout_set (&request.timeout_event, timeoutcb, &request);
    event_base_set (request.base, &request.timeout_event);
    timeout_add (&request.timeout_event, &request.timeout);

    queue_addr (&request.addr_queue, &db_info->start_node);

    error = __issue_request (&request);

    timeout_del (&request.timeout_event);
    evbuffer_free (request.evbuf);

    addr_queue_destroy (&request.addr_queue);

    lock (&cache_mutex);
    list_splice (&request.connecting_nodes, &node_cache);
    unlock (&cache_mutex);

    return error;
}

static bool zdb_read_chunk (unsigned char *chunk, const unsigned char *digest, void *db_info) {
    struct evbuffer *request;

    TRACE ("digest=%s\n", digest_string (digest));

    request = evbuffer_new ();
    if (!request)
        return -ENOMEM;

    if (evbuffer_add_printf (request, "%s %s\r\n", FIND_CHUNK, digest_string (digest)) < 0) {
        TRACE ("evbuffer_add failed\n");
        evbuffer_free (request);
        return false;
    }

    return issue_request (request, db_info, digest, chunk) == 0;
}

static bool zdb_write_chunk (const unsigned char *chunk, const unsigned char *digest, void *db_info) {
    struct evbuffer *request;
    struct zdb_info *zdb_info = db_info;

    TRACE ("digest=%s\n", digest_string (digest));

    request = evbuffer_new ();
    if (!request)
        return -ENOMEM;

    if (evbuffer_add_printf (request, "%s ", zdb_info->store_method) < 0 || base64_encode_evbuf (request, chunk, CHUNK_SIZE) < 0 || evbuffer_add (request, "\r\n", 2) < 0) {
        TRACE ("evbuffer_add failed\n");
        evbuffer_free (request);
        return false;
    }

    return issue_request (request, db_info, digest, NULL) == 0;
}

static const char *suffix (const char *str, const char *prefix) {
    int pfxlen = strlen (prefix);
    if (!strncmp (str, prefix, pfxlen))
        return str + pfxlen;
    return NULL;
}

static char *parse_spec (const char *spec, struct zdb_info *zdb_info) {
    static struct addrinfo ai_hint = {
        .ai_family = AF_INET,
        .ai_socktype = SOCK_STREAM,
    };

    struct addrinfo *ai_list;
    char *addr, *port;
    char *spec_copy;
    char *opt;
    const char *value;
    int err, opt_count;

    spec_copy = alloca (strlen (spec + 1));
    if (!spec_copy)
        return ERR_PTR (ENOMEM);

    strcpy (spec_copy, spec);

    TRACE ("spec_copy=%s\n", spec_copy);

    addr = NULL;

    for (opt_count = 0; (opt = strsep (&spec_copy, ",")); opt_count++) {
        if (!opt_count) {
            addr = opt;
            port = strchr (addr, ':');
            if (!port)
                return sprintf_new ("No port in address.");
            *port++ = 0;

            err = getaddrinfo (addr, port, &ai_hint, &ai_list);
            if (err)
                return sprintf_new ("%s.", gai_strerror (err));

            if (!ai_list)
                return sprintf_new ("ai_list == NULL.");

            /*
             * Just take the first addr for now.
             */
            zdb_info->start_node = *(struct sockaddr_in *) ai_list->ai_addr;

            freeaddrinfo (ai_list);

        } else if ((value = suffix (opt, "timeout="))) {
            zdb_info->request_timeout.tv_sec = atoi (value);
            if (!zdb_info->request_timeout.tv_sec) {
                return sprintf_new ("Invalid timeout " "value of %s.", value);
            }

        } else if (!strcmp (opt, "store")) {
            zdb_info->store_method = STORE_CHUNK;

        } else {
            return sprintf_new ("Unknown option '%s'.", opt);
        }
    }

    if (!addr)
        return sprintf_new ("No address specified.");

    return 0;
}

static char *zdb_chunkdb_ctor (const char *spec, struct chunk_db *chunk_db) {
    struct zdb_info *zdb_info = chunk_db->db_info;

    zdb_info->request_timeout.tv_sec = 60;
    zdb_info->request_timeout.tv_usec = 0;

    zdb_info->connect_timeout.tv_sec = 1;
    zdb_info->connect_timeout.tv_usec = 0;

    zdb_info->store_method = FORWARD_CHUNK;

    return parse_spec (spec, zdb_info);
}

static struct chunk_db_type zdb_chunkdb_type = {
    .spec_prefix = "zunkdb:",
    .info_size = sizeof (struct zdb_info),
    .ctor = zdb_chunkdb_ctor,
    .read_chunk = zdb_read_chunk,
    .write_chunk = zdb_write_chunk,
    .help =
        "   zunkdb:<node>[,opts]    Use a \"zunk\" database for chunk storage.\n"
        "                           Initial node is passed in as <ip|name>:<port>.\n"
        "                           Options include:\n"
        "                              timeout=#  Set request timeout (in seconds)\n"
        "                              use_store  Use STORE instead of FORWARD\n"
        "                                         to send chunks to zunkdb. Use this\n"
        "                                         only if you have a fast uplink, as\n"
        "                                         it will end up sending the same\n" "                                         chunk to multiple zunkdb nodes.\n"
};

REGISTER_CHUNKDB (zdb_chunkdb_type);
