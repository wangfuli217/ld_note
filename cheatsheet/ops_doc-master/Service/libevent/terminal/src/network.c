#include <event.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <fcntl.h>
#include <sys/uio.h>
#include <unistd.h>
#include "network.h"
#include "connection.h"
#include "connection_queue.h"
#include "util.h"

int update_event(conn *c, const int new_flags) {
    assert(c != NULL);

    struct event_base *base = c->event.ev_base;
    if (c->ev_flags == new_flags)
        return 1;
    if (c->ev_flags != 0) {
        if (event_del(&c->event) == -1) return 0;
    }
    event_set(&c->event, c->sfd, new_flags, event_handler, (void *)c);
    event_base_set(base, &c->event);
    c->ev_flags = new_flags;
    if (event_add(&c->event, 0) == -1) return 0;
    return 1;
}

int process_command(conn *c, char *command) {
    if (strcmp(command, "quit") == 0) {
        c->state = conn_closing;
        return STAY_IN;
    } else if (strcmp(command, "stop") == 0) {
        exit(0);
    } else if (strcmp(command, "version") == 0) {
        // compat with old php Memcache client
        out_string(c, VERSION);
        return STAY_IN;
    } else {
        if (event_del(&c->event) == -1) {
            out_string(c, "SERVER_ERROR can't forward");
            return STAY_IN;
        }
        gettimeofday(&c->tv, NULL);
        c->ev_flags = 0;
        c->cmd = command;
        cq_push(&REQ, c);
        return FORWARD_OUT;
    }
}

/* get the command word in receive data */
int try_read_command(conn *c) {
    char *el, *cont;

    if (!c->rbytes)
        return 0;
    el = (char *)memchr(c->rcurr, '\n', c->rbytes);
    if (!el)
        return 0;
    cont = el + 1;
    if (el - c->rcurr > 1 && *(el - 1) == '\r') {
        el--;
    }
    *el = '\0';

    int res = process_command(c, c->rcurr);

    c->rbytes -= (cont - c->rcurr);
    c->rcurr = cont;

    return res;
}

int try_read_network(conn *c) {
    int gotdata = 0;
    int res;

    if (c->rcurr != c->rbuf) {
        if (c->rbytes != 0) /* otherwise there's nothing to copy */
            memmove(c->rbuf, c->rcurr, c->rbytes);
        c->rcurr = c->rbuf;
    }

    while (1) {
        if (c->rbytes >= c->rsize) {
            char *new_rbuf = (char *)realloc(c->rbuf, c->rsize*2);
            if (!new_rbuf) {
                if (settings.verbose > 0)
                    fprintf(stderr, "Couldn't realloc input buffer\n");
                c->rbytes = 0; /* ignore what we read */
                out_string(c, "SERVER_ERROR out of memory");
                c->write_and_go = conn_closing;
                return 1;
            }
            c->rcurr  = c->rbuf = new_rbuf;
            c->rsize *= 2;
        }
        int avail = c->rsize - c->rbytes;
        res = read(c->sfd, c->rbuf + c->rbytes, avail);
        if (res > 0) {
            gotdata = 1;
            c->rbytes += res;
            if (res == avail) {
                continue;
            } else {
                break;
            }
        }
        if (res == 0) {
            /* connection closed */
            c->state = conn_closing;
            return 1;
        }

        if (res == -1) {
            if (errno == EAGAIN || errno == EWOULDBLOCK) break;
            else {
                c->state = conn_closing;
                return 1;
            }
        }
    }
    return gotdata;
}

void drive_machine(conn *c) {
    int stop = 0;
    int sfd, flags = 1;
    socklen_t addrlen;
    struct sockaddr_in addr;
    conn *newc;
    int res;

    assert(c != NULL);

    while (!stop) {
        switch(c->state) {
        case conn_listening:
            addrlen = sizeof(addr);
            if ((sfd = accept(c->sfd, (struct sockaddr *)&addr, &addrlen)) == -1) {
                if (errno == EAGAIN || errno == EWOULDBLOCK) {
                    /* these are transient, so don't log anything */
                    stop = 1;
                } else if (errno == EMFILE) {
                    if (settings.verbose > 0)
                        fprintf(stderr, "Too many open connections\n");
                    stop = 1;
                } else {
                    perror("accept()");
                    stop = 1;
                }
                break;
            }

            if ((flags = fcntl(sfd, F_GETFL, 0)) < 0 ||
                fcntl(sfd, F_SETFL, flags | O_NONBLOCK) < 0) {
                perror("setting O_NONBLOCK");
                close(sfd);
                break;
            }
            newc = conn_new(sfd, conn_read, EV_READ | EV_PERSIST, c->event.ev_base);
            if (!newc) {
                if (settings.verbose > 0)
                    fprintf(stderr, "couldn't create new connection\n");
                close(sfd);
            }
            break;

        case conn_read:
            res = try_read_command(c);
            if (res == STAY_IN) {
                continue;
            } else if (res == FORWARD_OUT) {
                stop = 1;
                break;
            }
            if (try_read_network(c) != 0) {
                continue;
            }
            /* we have no command line and no data to read from network */
            if (!update_event(c, EV_READ | EV_PERSIST)) {
                if (settings.verbose > 0)
                    fprintf(stderr, "Couldn't update event\n");
                c->state = conn_closing;
                break;
            }
            stop = 1;
            break;

        case conn_write:
            if (c->wbytes == 0) {
                c->state = c->write_and_go;
                break;
            }

            res = write(c->sfd, c->wcurr, c->wbytes);
            if (res > 0) {
                c->wcurr  += res;
                c->wbytes -= res;
                break;
            }
            if (res == -1 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
                if (!update_event(c, EV_WRITE | EV_PERSIST)) {
                    if (settings.verbose > 0)
                        fprintf(stderr, "Couldn't update event\n");
                    c->state = conn_closing;
                    break;
                }
                stop = 1;
                break;
            }
            c->state = conn_closing;
            break;

        case conn_closing:
            conn_close(c);
            stop = 1;
            break;
        }
    }

    return;
}

void event_handler(const int fd, const short which, void *arg) {
    conn *c;

    c = (conn *)arg;
    assert(c != NULL);

    c->which = which;

    if (fd != c->sfd) {
        if (settings.verbose > 0)
            fprintf(stderr, "Catastrophic: event fd doesn't match conn fd!\n");
        conn_close(c);
        return;
    }

    drive_machine(c);

    return;
}

void notify_handler(const int fd, const short which, void *arg) {
    if (fd != notify_receive_fd) {
        if (settings.verbose > 0)
            fprintf(stderr, "Catastrophic: event fd doesn't match conn fd!\n");
        return;
    }
    char buf[1];
    if (read(fd, buf, 1) != 1) {
        if (settings.verbose > 0)
            fprintf(stderr, "Can't read from event pipe\n");
    }

    conn *c = cq_peek(&RSP);
    if (c != NULL) {
        c->wcurr = c->wbuf;
        c->state = conn_write;
        c->write_and_go = conn_read;

        drive_machine(c);
    }

    return;
}

int new_socket() {
    int sfd;
    int flags;

    if ((sfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket()");
        return -1;
    }

    if ((flags = fcntl(sfd, F_GETFL, 0)) < 0 ||
        fcntl(sfd, F_SETFL, flags | O_NONBLOCK) < 0) {
        perror("setting O_NONBLOCK");
        close(sfd);
        return -1;
    }
    return sfd;
}

int server_socket(const int port) {
    int sfd;
    struct linger ling = {0, 0};
    struct sockaddr_in addr;
    int flags = 1;

    if ((sfd = new_socket()) == -1) {
        return -1;
    }

    setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, (void *)&flags, sizeof(flags));
    setsockopt(sfd, SOL_SOCKET, SO_KEEPALIVE, (void *)&flags, sizeof(flags));
    setsockopt(sfd, SOL_SOCKET, SO_LINGER, (void *)&ling, sizeof(ling));
    setsockopt(sfd, IPPROTO_TCP, TCP_NODELAY, (void *)&flags, sizeof(flags));

    memset(&addr, 0, sizeof(addr));

    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr = settings.interf;
    if (bind(sfd, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
        perror("bind()");
        close(sfd);
        return -1;
    }

    if (listen(sfd, 1024) == -1) {
        perror("listen()");
        close(sfd);
        return -1;
    }
    return sfd;
}

