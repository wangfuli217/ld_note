#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>
#include <sys/tree.h>
#include <sys/time.h>
#include <sys/types.h>
#include <string.h>
#include <unistd.h>

#include "log.h"
#include "event.h"
#include "event_internal.h"

#ifndef howmany
#define howmany(x, y)	(((x)+((y)-1))/(y))
#endif

void *select_init (void);
int select_add (void *, struct event *);
int select_del (void *, struct event *);
int select_recalc (struct event_base *, void *, int);
int select_dispatch (struct event_base *, void *, struct timeval *);

/**
 * 这个I/O实例为全局变量, 所以不能用于多线程
 */
const struct eventop selectops = {
    "select",
    select_init,
    select_add,
    select_del,
    select_recalc,
    select_dispatch
};

struct selectop {
    int event_fds;
    int event_fdsz;
    fd_set *event_readset;
    fd_set *event_writeset;
} sop;

void *select_init (void) {
    memset (&sop, 0, sizeof (sop));
    return (&sop);
}

int select_add (void *arg, struct event *ev) {
    struct selectop *sop = arg;

    if (sop->event_fds < ev->ev_fd)
        sop->event_fds = ev->ev_fd;

    return (0);
}

/**
 * Nothing to be done here
 */
int select_del (void *arg, struct event *ev) {
    return (0);
}

int select_recalc (struct event_base *base, void *arg, int max) {
    struct selectop *sop = arg;
    fd_set *readset, *writeset;
    struct event *ev;
    int fdsz;

    if (sop->event_fds < max)
        sop->event_fds = max;

    if (!sop->event_fds) {
        TAILQ_FOREACH (ev, &base->eventqueue, ev_next)
            if (ev->ev_fd > sop->event_fds)
            sop->event_fds = ev->ev_fd;
    }

    fdsz = howmany (sop->event_fds + 1, NFDBITS) * sizeof (fd_mask);

    if (fdsz > sop->event_fdsz) {
        if ((readset = realloc (sop->event_readset, fdsz)) == NULL)
            LOG_ERROR ("malloc() error! out of memory.");

        if ((writeset = realloc (sop->event_writeset, fdsz)) == NULL) {
            free (readset);
            LOG_ERROR ("malloc() error!, out of memory.");
        }

        memset ((char *) readset + sop->event_fdsz, 0, fdsz - sop->event_fdsz);
        memset ((char *) writeset + sop->event_fdsz, 0, fdsz - sop->event_fdsz);

        sop->event_readset = readset;
        sop->event_writeset = writeset;
        sop->event_fdsz = fdsz;

    }

    return (0);
}

int select_dispatch (struct event_base *base, void *arg, struct timeval *tv) {
    int maxfd, res;
    struct event *ev, *next;
    struct selectop *sop = arg;

    memset (sop->event_readset, 0, sop->event_fdsz);
    memset (sop->event_writeset, 0, sop->event_fdsz);

    TAILQ_FOREACH (ev, &base->eventqueue, ev_next) {
        if (ev->ev_events & EVENT_READ)
            FD_SET (ev->ev_fd, sop->event_readset);

        if (ev->ev_events & EVENT_WRITE)
            FD_SET (ev->ev_fd, sop->event_writeset);
    }

    res = select (sop->event_fds + 1, sop->event_readset, sop->event_writeset, NULL, tv);

    if (res == -1) {
        if (errno != EINTR) {
            LOG_DEBUG ("select() error! %s", strerror (errno));
            return (-1);
        }

        return (0);
    }

    LOG_DEBUG ("select reports %d", res);

    maxfd = 0;

    for (ev = TAILQ_FIRST (&base->eventqueue); ev != NULL; ev = next) {
        next = TAILQ_NEXT (ev, ev_next);

        res = 0;
        if (FD_ISSET (ev->ev_fd, sop->event_readset))
            res |= EVENT_READ;
        if (FD_ISSET (ev->ev_fd, sop->event_writeset))
            res |= EVENT_WRITE;

        if (res) {
            if (!(ev->ev_events & EVENT_PERSIST))
                event_del (ev);
            else if (ev->ev_fd > maxfd)
                maxfd = ev->ev_fd;

            event_active (ev, res);
        } else if (ev->ev_fd > maxfd)
            maxfd = ev->ev_fd;
    }

    sop->event_fds = maxfd;

    return (0);
}
