#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <assert.h>
#include <netinet/tcp.h>

#include "conn.h"
#include "thread.h"
#include "handle.h"

#define BACKLOG 1024

conn **conns;

void conn_init (void) {
    int next_fd = dup (1);
    int headroom = 10;
    //struct rlimit rl;
    max_fds = settings.maxconns + headroom + next_fd;

    /* todo */

    close (next_fd);

    if ((conns = calloc (max_fds, sizeof (conn *))) == NULL) {
        fprintf (stderr, "Failed to allocate connection structures\n");
        /* This is unrecoverable so bail out early. */
        exit (1);
    }

}

static void conn_set_state (conn * c, enum conn_states state) {
    assert (c != NULL);
    assert (state >= conn_listening && state < conn_max_state);

    if (state != c->state) {
        c->state = state;
    }
}

static void reset_cmd_handler (conn * c) {
    conn_set_state (c, conn_waiting);
}

static void drive_machine (conn * c) {
    int ret;
    int sfd;
    int stop = 0;
    socklen_t addrlen;
    struct sockaddr_in addr;

    assert (c != NULL);

    while (!stop) {
        switch (c->state) {
        case conn_listening:
            addrlen = sizeof (addrlen);
            sfd = accept (c->sfd, (struct sockaddr *) &addr, &addrlen);
            if (sfd == -1) {
                perror ("accept()");
                stop = 1;
                break;
            }
            dispatch_conn_new (sfd, conn_new_cmd, EV_READ | EV_PERSIST);
            stop = 1;
            break;
        case conn_new_cmd:
            reset_cmd_handler (c);
            break;
        case conn_waiting:
            conn_set_state (c, conn_read);
            stop = 1;
            break;
        case conn_read:
            ret = protocol_handle (c->sfd);
            if (ret == -1) {
                printf ("close socket:%d.\n", c->sfd);
                close (c->sfd);
                free (conns[c->sfd]);
                //event_del(&c->event);
                stop = 1;
                //memset(&c->event, 0, sizeof(c->event));
            }
            break;

        default:
            printf ("no shibie c->state");
            break;
        }
    }

    return;
}

void event_handler (const int fd, short which, void *arg) {
    conn *c;

    c = (conn *) arg;
    assert (c != NULL);
    printf (" event_handler\n");

    c->which = which;

    if (fd != c->sfd) {
        fprintf (stderr, "Catastrophic: event fd doesn't match conn fd!\n");
        //conn_close(c);
        return;
    }

    drive_machine (c);

    return;
}

conn *conn_new (const int sfd, enum conn_states init_status, const int event_flags, struct event_base * base) {
    conn *c;
    assert (sfd >= 0 && sfd < max_fds);

    c = conns[sfd];
    if (c == NULL) {
        if (!(c = (conn *) calloc (1, sizeof (conn)))) {
            fprintf (stderr, "Failed to allocate connection object\n");
            return NULL;
        }
        c->sfd = sfd;
        conns[sfd] = c;
    }
    c->state = init_status;

    event_set (&c->event, sfd, event_flags, event_handler, (void *) c);
    event_base_set (base, &c->event);
    c->ev_flags = event_flags;

    if (event_add (&c->event, 0) == -1) {
        perror ("event_add");
        return NULL;
    }
    return c;
}

static void socket_set_nonblock (int sfd) {
    int flags;

    if ((flags = fcntl (sfd, F_GETFL, 0)) < 0 || fcntl (sfd, F_SETFL, flags | O_NONBLOCK) < 0) {
        perror ("setting O_NONBLOCK");
        close (sfd);
        exit (1);
    }
}

static void socket_set_options (int sfd) {
    int ret;
    int flags = 1;

    ret = setsockopt (sfd, SOL_SOCKET, SO_REUSEADDR, (void *) &flags, sizeof (flags));
    if (ret != 0)
        perror ("setsockopt");

    ret = setsockopt (sfd, SOL_SOCKET, SO_KEEPALIVE, (void *) &flags, sizeof (flags));
    if (ret != 0)
        perror ("setsockopt");

    ret = setsockopt (sfd, SOL_SOCKET, TCP_NODELAY, (void *) &flags, sizeof (flags));
    if (ret != 0)
        perror ("setsockopt");

}

int socket_init (int port) {
    int ret;
    int sfd;
    struct sockaddr_in addr;
    conn *listen_conn_add;

    sfd = socket (AF_INET, SOCK_STREAM, 0);
    if (sfd < 0) {
        perror ("socket()");
        return -1;
    }

    memset (&addr, 0, sizeof (addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl (INADDR_ANY);
    addr.sin_port = htons (port);

    socket_set_nonblock (sfd);
    socket_set_options (sfd);

    ret = bind (sfd, (struct sockaddr *) &addr, sizeof (addr));
    if (ret != 0) {
        perror ("bind()");
        return -1;
    }

    ret = listen (sfd, BACKLOG);
    if (ret != 0) {
        perror ("listen()");
        return -1;
    }

    printf ("listen sfd = %d\n", sfd);
    listen_conn_add = conn_new (sfd, conn_listening, EV_READ | EV_PERSIST, main_base);
    if (!listen_conn_add)
        return -1;

    return sfd;
}
