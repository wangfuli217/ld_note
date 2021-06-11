
#define _GNU_SOURCE

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <limits.h>
#include <openssl/sha.h>
#include <unistd.h>
#include <getopt.h>
#include <libgen.h>
#include <signal.h>

#include <event.h>
#include <evdns.h>

#include "base64.h"
#include "list.h"
#include "digest.h"
#include "utils.h"
#include "zunkfs.h"
#include "chunk-db.h"

struct node {
    int fd;
    struct bufferevent *bev;
    struct sockaddr_in addr;
    struct list_head node_entry;
    struct event connect_event;
};

struct forward_request {
    int min_dist;
    unsigned ref_count;
    struct evbuffer *evbuf;
    struct list_head request_entry;
    unsigned char chunk_digest[CHUNK_DIGEST_LEN];
    struct event timeout_event;
    struct timeval timeout;
};

struct push_request {
    unsigned char digest[CHUNK_DIGEST_LEN];
    struct list_head request_entry;
    struct node *node;
    int max_d;
    char value[0];
};

#define node_addr(node)		((node)->addr.sin_addr)
#define node_addr_string(node)	inet_ntoa(node_addr(node))
#define node_port(node)		ntohs((node)->addr.sin_port)

#define node_is_addr(node, addr) \
	(node_addr(node).s_addr == (addr)->sin_addr.s_addr && \
	 node_port(node) == ntohs((addr)->sin_port))

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
#define PUSH_CHUNK		"push_chunk"
#define PUSH_CHUNK_LEN		(sizeof(PUSH_CHUNK) - 1)

#define NODE_VEC_MAX	5

static LIST_HEAD (node_list);
static LIST_HEAD (client_list);
static LIST_HEAD (forward_list);
static LIST_HEAD (push_list);

static char *prog;
static struct sockaddr_in my_addr;
static unsigned nr_chunkdbs = 0;
static unsigned daemonize = 0;
static unsigned may_promote = 0;
static struct timeval forward_timeout = { 60, 0 };

static unsigned max_forwards = 1000;
static unsigned pending_forwards = 0;
static unsigned slow_uplink = 0;

static inline unsigned char *__data_digest (const void *buf, size_t len, unsigned char *digest) {
    assert (digest != NULL);
    SHA1 (buf, len, digest);
    return digest;
}

#define data_digest(buf, len) __data_digest(buf, len, alloca(SHA_DIGEST_LENGTH))

static inline unsigned char *__node_digest (const struct node *node, unsigned char *digest) {
    struct {
        uint16_t zero;
        uint16_t port;
        uint32_t ip;
    } addr;

    addr.zero = 0;
    addr.port = node->addr.sin_port;
    addr.ip = node->addr.sin_addr.s_addr;

    return __data_digest (&addr, sizeof (addr), digest);
}

#define node_digest(node) __node_digest(node, alloca(SHA_DIGEST_LENGTH))

static void __push_chunk (struct push_request *, struct node *);

static void free_node (struct node *node) {
    struct push_request *r;

    event_del (&node->connect_event);
    list_del (&node->node_entry);
    close (node->fd);
    bufferevent_free (node->bev);
    free (node);

    list_for_each_entry (r, &push_list, request_entry)
        if (r->node == node)
        __push_chunk (r, NULL);
}

static int trim_nodes (void) {
    struct list_head *list;

    if (!list_empty (&client_list))
        list = &client_list;
    else if (!list_empty (&node_list))
        list = &node_list;
    else
        return 0;

    free_node (list_entry (list->prev, struct node, node_entry));
    return 1;
}

static void connectcb (int fd, short event, void *arg) {
    struct node *node = arg;
    int err;

    if (!connect (fd, (struct sockaddr *) &node->addr, sizeof (struct sockaddr_in)) || errno == EISCONN) {
        TRACE ("Connected to peer %s:%u\n", inet_ntoa (node->addr.sin_addr), ntohs (node->addr.sin_port));
        bufferevent_enable (node->bev, EV_READ | EV_WRITE);
        return;
    }

    if (errno == EALREADY || errno == EINPROGRESS) {
        event_add (&node->connect_event, NULL);
        return;
    }

    err = errno;
    TRACE ("Failed to connect to %s:%u: %s\n", inet_ntoa (node->addr.sin_addr), ntohs (node->addr.sin_port), strerror (err));

    free_node (node);
}

static void readcb (struct bufferevent *bev, void *arg);
static void errorcb (struct bufferevent *bev, short what, void *arg);

static int setup_node (struct node *node) {
    int fl;

    event_set (&node->connect_event, node->fd, EV_WRITE, connectcb, node);

    node->bev = bufferevent_new (node->fd, readcb, NULL, errorcb, node);
    if (!node->bev) {
        close (node->fd);
        free (node);
        return -ENOMEM;
    }

    fl = fcntl (node->fd, F_GETFL);
    fcntl (node->fd, F_SETFL, fl | O_NONBLOCK);

    return 0;
}

static void nearest_nodes (const unsigned char *, struct evbuffer *, int, struct node *node);

static inline int node_distance (const struct node *node, const unsigned char *key) {
    return digest_distance (key, node_digest (node));
}

static int connect_node (struct node *node) {
    struct forward_request *r;
    struct evbuffer *evbuf;

    evbuf = evbuffer_new ();
    if (!evbuf) {
        ERROR ("eek: failed to allocate evbuffer\n");
        free_node (node);
        return -ENOMEM;
    }

    bufferevent_disable (node->bev, EV_READ | EV_WRITE);

    evbuffer_add_printf (evbuf, "%s :%u\r\n", STORE_NODE, ntohs (my_addr.sin_port));

    nearest_nodes (node_digest (node), evbuf, NODE_VEC_MAX, node);

    bufferevent_write_buffer (node->bev, evbuf);
    evbuffer_free (evbuf);

    list_for_each_entry (r, &forward_list, request_entry) {
        int d = node_distance (node, r->chunk_digest);
        if (d < r->min_dist) {
            if (bufferevent_write (node->bev, EVBUFFER_DATA (r->evbuf), EVBUFFER_LENGTH (r->evbuf)))
                continue;
            TRACE ("forwarding %s to %s:%u (%d)\n", digest_string (r->chunk_digest), node_addr_string (node), node_port (node), d);
            r->ref_count++;
            r->min_dist = d;
        }
    }

    connectcb (node->fd, EV_WRITE, node);
    return 0;
}

static struct node *find_node (const struct sockaddr_in *addr) {
    struct node *node;
    list_for_each_entry (node, &node_list, node_entry)
        if (node_is_addr (node, addr))
        return node;
    return NULL;
}

static int store_node (const struct sockaddr_in *addr) {
    struct node *node;
    int err;

    if (find_node (addr))
        return -EEXIST;

    node = malloc (sizeof (struct node));
    if (!node)
        return -ENOMEM;

  again:
    node->fd = socket (AF_INET, SOCK_STREAM, 0);
    if (node->fd == -1) {
        err = -errno;
        if ((errno == ENFILE || errno == EMFILE) && trim_nodes ())
            goto again;
        return err;
    }

    err = setup_node (node);
    if (err)
        return err;

    node->addr = *addr;

    list_add_tail (&node->node_entry, &node_list);

    TRACE ("added node %s:%u\n", node_addr_string (node), node_port (node));

    return connect_node (node);
}

static int promote_node (struct node *node, uint16_t port) {
    struct evbuffer *evbuf;
    struct sockaddr_in addr;

    addr = node->addr;
    addr.sin_port = port;

    if (!may_promote)
        return store_node (&addr);

    if (find_node (&addr)) {
        TRACE ("Ugh. Tried promoting an existing node...\n");
        close (node->fd);
        return -EEXIST;
    }

    TRACE ("Promoting %s:%u to :%u\n", node_addr_string (node), node_port (node), ntohs (port));

    node->addr = addr;
    list_move (&node->node_entry, &node_list);

    evbuf = evbuffer_new ();
    if (!evbuf)
        return -ENOMEM;

    nearest_nodes (node_digest (node), evbuf, NODE_VEC_MAX, node);
    bufferevent_write_buffer (node->bev, evbuf);
    evbuffer_free (evbuf);

    return 0;
}

static void dns_resolvecb (int result, char type, int count, int ttl, void *addresses, void *arg) {
    struct in_addr *addrs = addresses;
    struct sockaddr_in sa;
    char *addr_str = arg;
    char *port;

    assert (addr_str != NULL);

    port = addr_str + strlen (addr_str) + 1;

    if (result != DNS_ERR_NONE || type != DNS_IPv4_A) {
        ERROR ("Failed to resolve %s.\n", addr_str);
        free (addr_str);
        return;
    }

    TRACE ("Resolved %s to be %s\n", addr_str, inet_ntoa (*addrs));

    sa.sin_family = AF_INET;
    sa.sin_addr = *addrs;
    sa.sin_port = htons (atoi (port));

    store_node (&sa);
    free (addr_str);
}

static int dns_resolve (char *addr_str) {
    struct sockaddr_in *addr;
    char *addr_str_copy;
    char *port;

    addr = string_sockaddr_in (addr_str);
    if (addr)
        return store_node (addr);

    addr_str_copy = strdup (addr_str);
    if (!addr_str_copy)
        return -ENOMEM;

    port = strchr (addr_str_copy, ':');
    if (!port)
        return -EINVAL;
    *port++ = 0;

    TRACE ("Resolving %s... \n", addr_str_copy);

    if (evdns_resolve_ipv4 (addr_str_copy, 0, dns_resolvecb, addr_str_copy)) {
        ERROR ("Failed to resolve %s.\n", addr_str_copy);
        return -EINVAL;
    }

    return 0;
}

static int __nearest_nodes (const unsigned char *key, struct node **node_vec, int *dist_vec, int max, struct node *exclude) {
    int d, i, n, count = -1;
    struct node *node;

    for (i = 0; i < max; i++)
        dist_vec[i] = INT_MAX;

    list_for_each_entry (node, &node_list, node_entry) {
        if (node == exclude)
            continue;
        d = node_distance (node, key);
        /* find maximum, and replace.. */
        n = 0;
        for (i = 1; i < max; i++)
            if (dist_vec[n] < dist_vec[i])
                n = i;
        if (d < dist_vec[n]) {
            node_vec[n] = node;
            dist_vec[n] = d;
            if (count < n)
                count = n;
        }
    }

    return count + 1;
}

static void nearest_nodes (const unsigned char *key, struct evbuffer *output, int max, struct node *exclude) {
    struct node *node_vec[max];
    int dist_vec[max];
    int i, count;

    count = __nearest_nodes (key, node_vec, dist_vec, max, exclude);
    TRACE ("%d nodes near %s\n", count, digest_string (key));
    for (i = 0; i < count; i++) {
        evbuffer_add_printf (output, "%s %s:%u\r\n", STORE_NODE, node_addr_string (node_vec[i]), node_port (node_vec[i]));
        TRACE ("\t%s:%u\n", node_addr_string (node_vec[i]), node_port (node_vec[i]));
    }
}

static int find_value (const unsigned char *key, struct evbuffer *output) {
    unsigned char value[CHUNK_SIZE];
    int len;

    len = read_chunk (value, key);

    TRACE ("read_chunk %s len=%d\n", digest_string (key), len);

    if (len == CHUNK_SIZE) {
        evbuffer_add_printf (output, "%s ", STORE_CHUNK);
        base64_encode_evbuf (output, value, CHUNK_SIZE);
        evbuffer_add (output, "\r\n", 2);
        return 1;
    }

    return 0;
}

static int store_value (const char *value, unsigned char *digest) {
    unsigned char chunk[CHUNK_SIZE];

    if (base64_decode (value, chunk, CHUNK_SIZE) != CHUNK_SIZE)
        return -EINVAL;

    return write_chunk (chunk, digest);
}

static void request_timeoutcb (int fd, short event, void *arg) {
    struct forward_request *req = arg;

    TRACE ("forward request %s timedout.\n", digest_string (req->chunk_digest));

    pending_forwards--;

    list_del (&req->request_entry);
    evbuffer_free (req->evbuf);
    free (req);
}

static void forward_chunk (const char *value, const unsigned char *digest, unsigned max_d, struct node *exclude) {
    struct forward_request *req;
    struct node *node_vec[NODE_VEC_MAX];
    int dist_vec[NODE_VEC_MAX];
    int i, n;

    if (pending_forwards >= max_forwards)
        return;

    req = malloc (sizeof (struct forward_request));
    if (!req)
        return;

    req->evbuf = evbuffer_new ();
    if (!req->evbuf)
        goto discard;

    if (evbuffer_add_printf (req->evbuf, "%s %s\r\n", STORE_CHUNK, value) < 0)
        goto discard;

    n = __nearest_nodes (digest, node_vec, dist_vec, NODE_VEC_MAX, exclude);
    if (!n)
        goto discard;

    memcpy (req->chunk_digest, digest, CHUNK_DIGEST_LEN);
    req->ref_count = 0;
    req->min_dist = INT_MAX;

    for (i = 0; i < n; i++) {
        if (dist_vec[i] >= max_d)
            continue;
        if (bufferevent_write (node_vec[i]->bev, EVBUFFER_DATA (req->evbuf), EVBUFFER_LENGTH (req->evbuf)))
            continue;
        TRACE ("forwarding %s to %s:%u (%d)\n", digest_string (digest), node_addr_string (node_vec[i]), node_port (node_vec[i]), dist_vec[i]);
        if (dist_vec[i] < req->min_dist)
            req->min_dist = dist_vec[i];
        req->ref_count++;
    }

    if (!req->ref_count)
        goto discard;

    req->timeout = forward_timeout;

    timeout_set (&req->timeout_event, request_timeoutcb, req);
    timeout_add (&req->timeout_event, &req->timeout);

    list_add (&req->request_entry, &forward_list);
    pending_forwards++;

    return;
  discard:
    if (req->evbuf)
        evbuffer_free (req->evbuf);
    free (req);
}

static void push_chunk (const char *value, const unsigned char *digest, int max_d, struct node *exclude) {
    struct push_request *r;

    r = malloc (sizeof (struct push_request) + strlen (value) + 1);
    if (!r) {
        WARNING ("Failed to push %s: %s\n", digest_string (digest), strerror (ENOMEM));
        return;
    }

    strcpy (r->value, value);
    memcpy (r->digest, digest, CHUNK_DIGEST_LEN);
    r->max_d = max_d;
    if (r->max_d < 0)
        r->max_d = INT_MAX;

    list_add_tail (&r->request_entry, &push_list);

    __push_chunk (r, exclude);
}

static void __push_chunk (struct push_request *r, struct node *exclude) {
    struct evbuffer *evbuf;
    struct node *node_vec[NODE_VEC_MAX];
    int dist_vec[NODE_VEC_MAX];
    int i, j, n, best = -1;

    evbuf = evbuffer_new ();
    if (!evbuf)
        goto free_request;

    n = __nearest_nodes (r->digest, node_vec, dist_vec, NODE_VEC_MAX, exclude);
    if (!n)
        goto no_nodes;

    /* Remove nodes that are too far away. */
    for (i = j = 0; i < n; i++) {
        if (dist_vec[i] < r->max_d)
            j++;
        dist_vec[j] = dist_vec[i];
        node_vec[j] = node_vec[i];
    }

    n = i;
    if (!n)
        goto no_nodes;

    /* Find the most distant node in the list. */
    for (i = 0; i < n; i++)
        if (best == -1 || dist_vec[best] < dist_vec[i])
            best = i;

    /* Now let that node know about other nodes that may be close */
    for (i = 0; i < n; i++) {
        if (i == best)
            continue;

        if (evbuffer_add_printf (evbuf, "%s %s:%u\r\n", STORE_NODE, node_addr_string (node_vec[i]), node_port (node_vec[i])) < 0)
            goto free_request;
    }

    /* Finally, send the chunk */
    if (evbuffer_add_printf (evbuf, "%s %d %s\r\n", PUSH_CHUNK, dist_vec[best], r->value) < 0)
        goto free_request;

    r->node = node_vec[best];

    bufferevent_write_buffer (node_vec[best]->bev, evbuf);
    evbuffer_free (evbuf);

    TRACE ("pushed %s to %s:%u (max_d=%u d=%d)\n", digest_string (r->digest), node_addr_string (node_vec[best]), node_port (node_vec[best]), r->max_d, dist_vec[best]);
    return;
  no_nodes:
    TRACE ("No nodes closer to %s (n=%d, max_d=%d)\n", digest_string (r->digest), n, r->max_d);
  free_request:
    evbuffer_free (evbuf);
    WARNING ("Failed to send push request %s\n", digest_string (r->digest));
    list_del (&r->request_entry);
    free (r);
}

static inline void request_done (const char *key_str, struct evbuffer *output) {
    evbuffer_add_printf (output, "%s %s\r\n", REQUEST_DONE, key_str);
}

static void finish_request (const unsigned char *digest, const struct node *node) {
    struct forward_request *fr;
    struct push_request *pr;

    list_for_each_entry (fr, &forward_list, request_entry)
        if (!memcmp (digest, fr->chunk_digest, CHUNK_DIGEST_LEN))
        goto found_forward_request;

    list_for_each_entry (pr, &push_list, request_entry)
        if (pr->node == node && !memcmp (digest, pr->digest, CHUNK_DIGEST_LEN))
        goto found_push_request;
    return;

  found_forward_request:
    if (!--fr->ref_count) {
        TRACE ("forward request complete %s\n", digest_string (fr->chunk_digest));
        list_del (&fr->request_entry);
        event_del (&fr->timeout_event);
        evbuffer_free (fr->evbuf);
        free (fr);
        pending_forwards--;
    }
    return;
  found_push_request:
    TRACE ("push request complete %s\n", digest_string (pr->digest));
    list_del (&pr->request_entry);
    free (pr);
}

static void proc_msg (const char *buf, size_t len, struct node *node) {
    unsigned char digest[SHA_DIGEST_LENGTH];
    struct evbuffer *output;
    char *msg;

    output = evbuffer_new ();
    if (!output)
        return;

    msg = alloca (len + 1);
    assert (msg != NULL);
    memcpy (msg, buf, len);
    msg[len] = 0;

    if (!strncmp (msg, FIND_CHUNK, FIND_CHUNK_LEN)) {
        msg += FIND_CHUNK_LEN + 1;
        len -= FIND_CHUNK_LEN + 1;

        __string_digest (msg, digest);

        if (!find_value (digest, output))
            nearest_nodes (digest, output, NODE_VEC_MAX, node);

        request_done (msg, output);

    } else if (!strncmp (msg, STORE_CHUNK, STORE_CHUNK_LEN)) {
        msg += STORE_CHUNK_LEN + 1;
        len -= STORE_CHUNK_LEN + 1;

        if (store_value (msg, digest) != CHUNK_SIZE) {
            free_node (node);
            return;
        }

        nearest_nodes (digest, output, NODE_VEC_MAX, node);
        request_done (digest_string (digest), output);

    } else if (!strncmp (msg, STORE_NODE, STORE_NODE_LEN)) {
        struct sockaddr_in *addr;

        msg += STORE_NODE_LEN + 1;
        len -= STORE_NODE_LEN + 1;

        addr = string_sockaddr_in (msg);
        if (!addr)
            return;

        if (addr->sin_addr.s_addr == INADDR_ANY)
            promote_node (node, addr->sin_port);
        else
            store_node (addr);

    } else if (!strncmp (msg, FORWARD_CHUNK, FORWARD_CHUNK_LEN)) {
        msg += FORWARD_CHUNK_LEN + 1;
        len -= FORWARD_CHUNK_LEN + 1;

        if (store_value (msg, digest) != CHUNK_SIZE) {
            free_node (node);
            return;
        }

        if (!slow_uplink)
            forward_chunk (msg, digest, -1, node);
        else
            push_chunk (msg, digest, -1, node);

        request_done (digest_string (digest), output);

    } else if (!strncmp (msg, PUSH_CHUNK, PUSH_CHUNK_LEN)) {
        unsigned max_d;
        char *end;

        msg += PUSH_CHUNK_LEN + 1;
        len -= PUSH_CHUNK_LEN + 1;

        max_d = strtol (msg, &end, 10);

        if (store_value (end + 1, digest) != CHUNK_SIZE) {
            free_node (node);
            return;
        }

        push_chunk (end + 1, digest, max_d, node);

        request_done (digest_string (digest), output);

    } else if (!strncmp (msg, REQUEST_DONE, REQUEST_DONE_LEN)) {
        msg += REQUEST_DONE_LEN + 1;
        len -= REQUEST_DONE_LEN + 1;

        __string_digest (msg, digest);
        finish_request (digest, node);

        evbuffer_free (output);
        return;
    }

    bufferevent_write_buffer (node->bev, output);
    evbuffer_free (output);
}

static void readcb (struct bufferevent *bev, void *arg) {
    const char *buf, *end;

    for (;;) {
        buf = (const char *) EVBUFFER_DATA (bev->input);
        end = (const char *) evbuffer_find (bev->input, (u_char *) "\r\n", 2);
        if (!end)
            return;

        proc_msg (buf, end - buf, arg);
        evbuffer_drain (bev->input, (end - buf) + 2);
    }
}

static void errorcb (struct bufferevent *bev, short what, void *arg) {
    struct node *cl = arg;
    TRACE ("client disconnected: %p %s:%u\n", cl, node_addr_string (cl), node_port (cl));
    free_node (cl);
}

static void accept_client (int fd, short event, void *arg) {
    struct node *cl;
    socklen_t addr_len;
    int err;

    cl = malloc (sizeof (struct node));
    if (!cl)
        return;

    addr_len = sizeof (struct sockaddr_in);

  again:
    cl->fd = accept (fd, (struct sockaddr *) &cl->addr, &addr_len);
    if (cl->fd == -1) {
        if (errno == EAGAIN)
            goto again;
        if ((errno == ENFILE || errno == EMFILE) && trim_nodes ())
            goto again;

        free (cl);
        return;
    }

    err = setup_node (cl);
    if (err)
        return;

    list_add (&cl->node_entry, &client_list);

    bufferevent_enable (cl->bev, EV_READ | EV_WRITE);

    TRACE ("client connected: %p %s\n", cl, inet_ntoa (cl->addr.sin_addr));
}

enum {
    OPT_REQUIRED_ARG = ':',
    OPT_HELP = 'h',
    OPT_PEER = 'p',
    OPT_ADDR = 'a',
    OPT_LOG = 'l',
    OPT_CHUNK_DB = 'c',
    OPT_DAEMONIZE = 'd',
    OPT_PROMOTE = 'o',
    OPT_FORWARD_TIMEOUT = 't',
    OPT_MAX_FORWARD = 'x',
    OPT_SLOW_UPLINK = 's',
};

static const char short_opts[] = {
    OPT_HELP,
    OPT_PEER, OPT_REQUIRED_ARG,
    OPT_ADDR, OPT_REQUIRED_ARG,
    OPT_LOG, OPT_REQUIRED_ARG,
    OPT_CHUNK_DB, OPT_REQUIRED_ARG,
    OPT_DAEMONIZE,
    OPT_PROMOTE,
    OPT_FORWARD_TIMEOUT, OPT_REQUIRED_ARG,
    OPT_MAX_FORWARD, OPT_REQUIRED_ARG,
    OPT_SLOW_UPLINK,
    0
};

static const struct option long_opts[] = {
    {"help", no_argument, NULL, OPT_HELP},
    {"peer", required_argument, NULL, OPT_PEER},
    {"addr", required_argument, NULL, OPT_ADDR},
    {"chunk-db", required_argument, NULL, OPT_CHUNK_DB},
    {"daemonize", no_argument, NULL, OPT_DAEMONIZE},
    {"promote-nodes", no_argument, NULL, OPT_PROMOTE},
    {"forward-timeout", required_argument, NULL, OPT_FORWARD_TIMEOUT},
    {"max-forwards", required_argument, NULL, OPT_MAX_FORWARD},
    {"log", required_argument, NULL, OPT_LOG},
    {"slow-uplink", no_argument, NULL, OPT_SLOW_UPLINK},
    {NULL}
};

#define USAGE \
"-h|--help\n"\
"-p|--peer <(ip|hostname):port>    Connect to this peer.\n"\
"-a|--addr <[ip]:port>             Listen on specified IP and port.\n"\
"-l|--log [level,]<file>           Enable logging of (E)rrors, (W)arnings,\n"\
"                                  (T)races to a file. File can be a path,\n"\
"                                  stdout, or stderr.\n"\
"-c|--chunk-db <spec>              Add a chunk-db.\n"\
"-d|--daemonize                    Fork into background.\n"\
"-o|--promote-nodes                Allow promoting client nodes to server\n"\
"                                  nodes.\n"\
"-t|--forward-timeout <seconds>    Maximum duration of a forward request.\n"\
"                                  Default = 60.\n"\
"-x|--max-forwards <count>         Maximum number of pending forwards.\n"\
"                                  Use to limit memory usage. Default = 1000\n"\
"-s|--slow-uplink                  Uplink is slow, use push method to store\n"\
"                                  chunks on other nodes.\n"\
"\nChunk-db specs:\n"

static void usage (int exit_code) {
    fprintf (stderr, "Usage: %s [ options ]\n", prog);
    fprintf (stderr, "%s\n", USAGE);
    help_chunkdb ();
    exit (exit_code);
}

static int proc_opt (int opt, char *arg) {
    struct sockaddr_in *sa;
    char *errstr;
    int err = 0;

    switch (opt) {
    case OPT_HELP:
        usage (0);
    case OPT_PEER:
        err = dns_resolve (arg);
        if (err && err != -EEXIST) {
            fprintf (stderr, "store peer: %s.\n", strerror (-err));
            return err;
        }
        return 0;

    case OPT_ADDR:
        sa = string_sockaddr_in (arg);
        if (!sa) {
            fprintf (stderr, "Invalid address: %s\n", arg);
            return -EINVAL;
        }

        my_addr = *sa;
        return 0;

    case OPT_LOG:
        err = set_logging (optarg);
        if (err) {
            fprintf (stderr, "Failed to enable logging: %s\n", strerror (-err));
            return err;
        }
        return 0;

    case OPT_CHUNK_DB:
        errstr = add_chunkdb (optarg);
        if (errstr) {
            fprintf (stderr, "Failed to add chunk-db %s: %s\n", optarg, STR_OR_ERROR (errstr));
            return err;
        }
        nr_chunkdbs++;
        return 0;

    case OPT_DAEMONIZE:
        daemonize = 1;
        return 0;

    case OPT_PROMOTE:
        may_promote = 1;
        return 0;

    case OPT_FORWARD_TIMEOUT:
        forward_timeout.tv_sec = atoi (optarg);
        return 0;

    case OPT_MAX_FORWARD:
        max_forwards = atoi (optarg);
        return 0;

    case OPT_SLOW_UPLINK:
        slow_uplink = 1;
        return 0;

    default:
        return -1;
    }
}

static int do_daemonize (void) {
    switch (fork ()) {
    case 0:
        return 0;
    case -1:
        return -errno;
    default:
        exit (0);
        return 0;
    }
}

static void sigpipecb (int fd, short event, void *arg) {
}

int main (int argc, char **argv) {
    struct event accept_event;
    int sk, reuse = 1, opt, err;
    struct event sigpipe_event;

    prog = basename (argv[0]);

    my_addr.sin_family = AF_INET;
    my_addr.sin_addr.s_addr = INADDR_ANY;
    my_addr.sin_port = htons (9876);

    signal_set (&sigpipe_event, SIGPIPE, sigpipecb, NULL);

    if (!event_init ()) {
        fprintf (stderr, "event_init: %s\n", strerror (errno));
        exit (-2);
    }

    if (evdns_init ()) {
        fprintf (stderr, "evdns_init: %s\n", strerror (errno));
        exit (-2);
    }

    signal_add (&sigpipe_event, NULL);

    while ((opt = getopt_long (argc, argv, short_opts, long_opts, NULL))
           != -1) {
        err = proc_opt (opt, optarg);
        if (err)
            usage (err);
    }

    if (optind != argc)
        usage (-1);

    if (!nr_chunkdbs) {
        fprintf (stderr, "Must specify at least one chunk " "database.\n\n");
        usage (-1);
    }

    sk = socket (AF_INET, SOCK_STREAM, 0);
    if (sk < 0) {
        fprintf (stderr, "socket: %s\n", strerror (errno));
        exit (-1);
    }

    if (setsockopt (sk, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof (int))) {
        fprintf (stderr, "reuseaddr: %s\n", strerror (errno));
        exit (-1);
    }

    if (bind (sk, (struct sockaddr *) &my_addr, sizeof (struct sockaddr_in))) {
        fprintf (stderr, "bind: %s\n", strerror (errno));
        exit (-1);
    }

    if (listen (sk, 1)) {
        fprintf (stderr, "listen: %s\n", strerror (errno));
        exit (-1);
    }

    event_set (&accept_event, sk, EV_READ | EV_PERSIST, accept_client, NULL);
    event_add (&accept_event, NULL);

    TRACE ("Listening on %s:%u\n", inet_ntoa (my_addr.sin_addr), ntohs (my_addr.sin_port));

    if (daemonize) {
        err = do_daemonize ();
        if (err) {
            fprintf (stderr, "Failed to daemonzie: %s\n", strerror (-err));
            exit (-1);
        }
    }

    event_dispatch ();

    fprintf (stderr, "Event processing done.\n");
    return 0;
}
