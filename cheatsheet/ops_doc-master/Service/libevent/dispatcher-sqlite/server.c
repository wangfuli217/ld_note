#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <time.h>
#include <signal.h>
#include <assert.h>
#include "select.h"
#include "process.h"
#include "buffer.h"
#include "platform.h"
#include "utils.h"
#include "debug.h"

#define MAX_STREAMS 64 * 1024
#define INVALID_SOCKET -1

static update_timeout = 1;
static int max_fds = MAX_STREAMS;
static select_t select_set;
static process_pool *pool;

enum {
    STATE_CLOSED,
    STATE_CONNECTED,
    STATE_LISTENING,
    STATE_PIPERECV
};

struct stream {
    int state;
    uint8_t used;
    int sfd;
    int bytes_sent, bytes_received;
    struct sockaddr_in remote_addr;
    buffer_t *iobuf;
    double last_activity, timeout;
    time_t ctime;
    struct stream *next;
};

typedef struct stream stream;

static int stream_count;
static stream *ds_stream, *stream_list;
static mutex_t stream_lock;

void stream_init (void) {
    /*We're unlikely to see an FD much higher than maxstreams. */
    stream_list = (stream *) s_calloc (max_fds, sizeof (stream));
    if (!stream_list) {
        ph_debug ("stream new error!");
        exit (-1);
    }
    int i;
    for (i = 0; i < max_fds; i++) {
        stream_list[i].sfd = INVALID_SOCKET;
    }
}

stream *stream_new (int sfd, uint8_t used, struct sockaddr_in *sin, size_t buf_sz) {
    assert (sfd > 0);

    if (sfd > max_fds) {
        ph_debug ("out of max streams!");
        return NULL;
    }
    stream *s;
    s = &stream_list[sfd];

    s->state = STATE_CLOSED;
    s->used = used;
    s->sfd = sfd;
    s->ctime = time (NULL);

    if (buf_sz != 0) {
        s->iobuf = buf_new (buf_sz);
    }
    if (sin != NULL) {
        memcpy (&s->remote_addr, sin, sizeof (*sin));
    }

    /* Add to list an increment count */
    s->next = ds_stream;
    ds_stream = s;
    stream_count++;

    return s;
}

void stream_print (void) {
    stream *s = ds_stream;
    ph_debug ("####");
    while (s) {
        ph_debug ("stream:sfd=%d,used=%d", s->sfd, s->used);
        s = s->next;
    }
    ph_debug ("####");
}

void stream_cleanup (stream * s) {
    assert (s != NULL);
    if (s->iobuf) {
        buf_free (s->iobuf);
    }
    memset (s, 0, sizeof (*s));
    s->sfd = INVALID_SOCKET;
}

void stream_destroy (stream * s) {
    stream **next;
    if (s->sfd != INVALID_SOCKET) {
        close (s->sfd);
    }

    next = &ds_stream;
    while (*next != s) {
        next = &(*next)->next;
    }
    *next = s->next;
    stream_count--;

    /* Destroy and free */
    stream_cleanup (s);
}

void destory_closed_stream (void) {
    stream *s = ds_stream;

    while (s) {
        mutex_lock (stream_lock);
        if (s->state == STATE_CLOSED) {
            stream *next = s->next;
            stream_destroy (s);
            s = next;
        } else {
            s = s->next;
        }
        mutex_unlock (stream_lock);
    }
}

void stream_close (stream * s) {
    if (s->state == STATE_CLOSED) {
        return;
    }

    s->state = STATE_CLOSED;

    if (s->sfd != INVALID_SOCKET) {
        if (close (s->sfd) < 0) {
            ph_log_warn ("close client[fd=%d] error: %s", s->sfd, strerror (ERRNO));
            return;
        } else {
            ph_debug ("client[fd=%d] disconnected!", s->sfd);
        }
        s->sfd = INVALID_SOCKET;
    }

    /* Clear buffer */
    buf_clear (s->iobuf);
}

void stream_accept_connection (stream * s) {
    for (;;) {
        stream *remote;
        struct sockaddr_in sin;
        socklen_t len;
        int err = 0, sockfd;

        sockfd = accept (s->sfd, (struct sockaddr *) &sin, &len);

        if (sockfd == INVALID_SOCKET) {
            err = ERRNO;
            if (err == EWOULDBLOCK) {
                /* No more waiting sockets */
                ph_debug ("server accept error: %s", strerror (err));
                return;
            }
        }

        /* Create client stream */
        remote = stream_new (sockfd, 1, &sin, 8192);
        if (remote != NULL) {
            remote->state = STATE_CONNECTED;
            blockmode (remote->sfd, 0);
            ph_debug ("client[fd=%d] connected !", remote->sfd);
        } else {
            /* Reached max connections */
            return;
        }
    }
}

void job_init (job_t * job) {
    memset (job, 0, sizeof (*job));
    job->fd = INVALID_SOCKET;
    job->event = EVENT_NONE;
}

void stream_received_data (stream * s) {
    int size;
    job_t job;

    for (;;) {
        job_init (&job);
        size = recv (s->sfd, job.buf, sizeof (job.buf) - 1, 0);

        if (size <= 0) {
            if (size == 0 || ERRNO != EWOULDBLOCK) {
                /* Handle disconnect */
                job.fd = s->sfd;
                job.event = EVENT_CLOSE;
                process_pool_dispatch (pool, &job);

                stream_close (s);
                return;
            } else {
                /* No more data */
                return;
            }
        }
        /* Check stream state */
        if (s->state != STATE_CONNECTED) {
            return;
        }

        job.fd = s->sfd;
        job.buf_size = size;
        job.event = EVENT_DATA;

        process_pool_dispatch (pool, &job);
        s->bytes_received += size;
    }
}

void stream_send_data (stream * s) {
    int i = 0, size = 0;
    job_t job;
    char *data = (char *) &job;

    for (;;) {
        size = read (s->sfd, data + i, sizeof (job));
        i = i + size;
        ph_debug ("master recv: %s", data);
        if (i == sizeof (job)) {
            break;
        }
    }
    send (job.fd, job.buf, sizeof (job.buf), 0);
}

void server_init (void) {
    signal (SIGPIPE, SIG_IGN);

    mutex_init (stream_lock, 1);
    stream_init ();
    process_pool_envinit ();

    pool = process_pool_new (3);
    process_pool_start (pool);

    int i;
    for (i = 0; i < pool->num_workers; i++) {
        stream *s = stream_new (pool->workers[i].pipe_fd, 1, NULL, 0);
        s->state = STATE_PIPERECV;
        blockmode (s->sfd, 0);
    }
}

void server_listen (void) {
    stream *s;

    int sfd = listen_s1 (8388);
    if (sfd > 0) {
        ph_debug ("server[fd=%d] listening on %d ...", sfd, 8388);
    }

    mutex_lock (stream_lock);

    s = stream_new (sfd, 1, NULL, 1024);
    if (s != NULL) {
        s->state = STATE_LISTENING;
    }

    mutex_unlock (stream_lock);
}

int server_get_stream_count (void) {
    return stream_count;
}

void server_update (void) {
    stream *s;
    struct timeval tv;

    destory_closed_stream ();

    /* Create fd sets for select */
    select_zero (&select_set);

    s = ds_stream;
    while (s) {
        mutex_lock (stream_lock);

        switch (s->state) {
        case STATE_CONNECTED:
            select_add (&select_set, SELECT_READ, s->sfd);
            break;

        case STATE_LISTENING:
            select_add (&select_set, SELECT_READ, s->sfd);
            break;

        case STATE_PIPERECV:
            select_add (&select_set, SELECT_READ, s->sfd);
            break;
        }
        s = s->next;
        mutex_unlock (stream_lock);
    }

    tv.tv_sec = update_timeout;
    tv.tv_usec = (update_timeout - tv.tv_sec) * 1e6;

    select (select_set.maxfd + 1, select_set.fds[SELECT_READ], select_set.fds[SELECT_WRITE], select_set.fds[SELECT_EXCEPT], &tv);

    /* Handle streams */
    s = ds_stream;
    while (s) {
        mutex_lock (stream_lock);
        switch (s->state) {
        case STATE_CONNECTED:
            if (select_has (&select_set, SELECT_READ, s->sfd)) {
                stream_received_data (s);
                if (s->state == STATE_CLOSED) {
                    break;
                }
            }
            break;

        case STATE_LISTENING:
            if (select_has (&select_set, SELECT_READ, s->sfd)) {
                stream_accept_connection (s);
            }
            break;

        case STATE_PIPERECV:
            if (select_has (&select_set, SELECT_READ, s->sfd)) {
                stream_send_data (s);
            }
            break;
        }
        s = s->next;
        mutex_unlock (stream_lock);
    }
}

int main (int argc, char *agrv[]) {
    server_init ();
    server_listen ();

    while (server_get_stream_count () > 0) {
        server_update ();
    }

    return 0;
}
