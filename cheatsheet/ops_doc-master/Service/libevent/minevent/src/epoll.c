#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/epoll.h>
#include <sys/queue.h>
#include <sys/tree.h>
#include <sys/time.h>
#include <sys/types.h>
#include <fcntl.h>
#include "log.h"
#include "event.h"
#include "event_internal.h"

/*
 * 由于epoll接口的限制, 我们自己需要跟踪所有文件fd
 */
struct evepoll {
    struct event *evread;
    struct event *evwrite;
};

/**
 * 这个I/O实例为全局变量, 所以不能用于多线程
 */
struct epollop {
    struct evepoll *fds;
    int nfds;
    struct epoll_event *events; //指向保存返回事件的文件描述符集合的数组(epoll_event类型数组)
    int nevents;
    int epfd;                   //epoll例程
} epollop;

void *epoll_init (void);
int epoll_add (void *, struct event *);
int epoll_del (void *, struct event *);
int epoll_recalc (struct event_base *, void *, int);
int epoll_dispatch (struct event_base *, void *, struct timeval *);

struct eventop epollops = {
    "epoll",
    epoll_init,
    epoll_add,
    epoll_del,
    epoll_recalc,
    epoll_dispatch
};

#ifdef HAVE_SETFD
#define FD_CLOSEONEXEC(x) do { \
		if (fcntl(x, F_SETFD, 1) == -1) \
			LOG_ERROR("fcntl(%d, F_SETFD)", x); \
} while(0)
#else
#define FD_CLOSEONEXEC(x)

#define NEVENT	32000

void *epoll_init (void) {
    int epfd, nfiles = NEVENT;

    memset (&epollop, 0, sizeof (epollop));

    //创建epoll例侱
    if ((epfd = epoll_create (nfiles)) == -1)
        LOG_ERROR ("epoll_create(%d)", nfiles);

    FD_CLOSEONEXEC (epfd);

    epollop.epfd = epfd;

    /*初始化epollop的字段 */
    epollop.events = malloc (nfiles * sizeof (struct epoll_event));
    if (epollop.events == NULL)
        return (NULL);
    epollop.nevents = nfiles;

    epollop.fds = calloc (nfiles, sizeof (struct evepoll));
    if (epollop.fds == NULL) {
        free (epollop.events);
        return (NULL);
    }
    epollop.nfds = nfiles;

    return (&epollop);
}

int epoll_recalc (struct event_base *base, void *arg, int max) {
    struct epollop *epollop = arg;

    if (max > epollop->nfds) {
        struct evepoll *fds;
        int nfds;

        nfds = epollop->nfds;
        while (nfds < max)
            nfds <<= 1;

        fds = realloc (epollop->fds, nfds * sizeof (struct evepoll));
        if (fds == NULL)
            LOG_ERROR ("realloc() error");

        epollop->fds = fds;
        memset (fds + epollop->nfds, 0, (nfds - epollop->nfds) * sizeof (struct evepoll));
        epollop->nfds = nfds;
    }

    return (0);
}

int epoll_dispatch (struct event_base *base, void *arg, struct timeval *tv) {
    struct epollop *epollop = arg;
    struct epoll_event *events = epollop->events;
    struct evepoll *evep;
    int i, res, timeout;

    timeout = tv->tv_sec * 1000 + (tv->tv_usec + 999) / 1000;
    res = epoll_wait (epollop->epfd, events, epollop->nevents, timeout);

    if (res == -1) {
        if (errno != EINTR)
            LOG_ERROR ("epoll_wait() error! %s", strerror (errno));

        return 0;
    }

    for (i = 0; i < res; i++) {
        int which = 0;
        int what = events[i].events;    //发生的事件集! (EPOLLIN EPOLLOUT)
        struct event *evread = NULL, *evwrite = NULL;

        evep = (struct evepoll *) events[i].data.ptr;

        if (what & EPOLLHUP)
            what |= EPOLLIN | EPOLLOUT;
        else if (what & EPOLLERR)
            what |= EPOLLIN | EPOLLOUT;

        if (what & EPOLLIN) {
            evread = evep->evread;
            which |= EVENT_READ;
        }

        if (what & EPOLLOUT) {
            evwrite = evep->evwrite;
            which |= EVENT_WRITE;
        }

        if (!which)
            continue;

        if (evread != NULL && !(evread->ev_events & EVENT_PERSIST))
            event_del (evread);
        if (evwrite != NULL && evwrite != evread && !(evwrite->ev_events & EVENT_PERSIST))
            event_del (evwrite);

        if (evread != NULL)
            event_active (evread, EVENT_READ);
        if (evwrite != NULL)
            event_active (evwrite, EVENT_WRITE);
    }

    return (0);
}

int epoll_add (void *arg, struct event *ev) {
    struct epollop *epollop = arg;
    struct epoll_event epev;
    struct evepoll *evep;
    int fd, op, events;

    fd = ev->ev_fd;

    if (fd >= epollop->nfds) {
        if (epoll_recalc (ev->ev_base, epollop, fd) == -1)
            return (-1);
    }
    evep = &epollop->fds[fd];
    op = EPOLL_CTL_ADD;
    events = 0;
    if (evep->evread != NULL) {
        events |= EPOLLIN;
        op = EPOLL_CTL_MOD;
    }
    if (evep->evwrite != NULL) {
        events |= EPOLLOUT;
        op = EPOLL_CTL_MOD;
    }

    if (ev->ev_events & EVENT_READ)
        events |= EPOLLIN;
    if (ev->ev_events & EVENT_WRITE)
        events |= EPOLLOUT;

    epev.data.ptr = evep;
    epev.events = events;
    if (epoll_ctl (epollop->epfd, op, ev->ev_fd, &epev) == -1)
        return (-1);

    /*更新响应事件 */
    if (ev->ev_events & EVENT_READ)
        evep->evread = ev;
    if (ev->ev_events & EVENT_WRITE)
        evep->evwrite = ev;

    return (0);
}

int epoll_del (void *arg, struct event *ev) {
    struct epollop *epollop = arg;
    struct epoll_event epev;
    struct evepoll *evep;
    int fd, events, op;
    int needwritedelete = 1, needreaddelete = 1;

    fd = ev->ev_fd;
    if (fd >= epollop->nfds)
        return (0);
    evep = &epollop->fds[fd];

    op = EPOLL_CTL_DEL;
    events = 0;

    if (ev->ev_events & EVENT_READ)
        events |= EPOLLIN;
    if (ev->ev_events & EVENT_WRITE)
        events |= EPOLLOUT;

    if ((events & (EPOLLIN | EPOLLOUT)) != (EPOLLIN | EPOLLOUT)) {
        if ((events & EPOLLIN) && evep->evwrite != NULL) {
            needwritedelete = 0;
            events = EPOLLOUT;
            op = EPOLL_CTL_MOD;
        } else if ((events & EPOLLOUT) && evep->evread != NULL) {
            needreaddelete = 0;
            events = EPOLLIN;
            op = EPOLL_CTL_MOD;
        }
    }

    epev.events = events;
    epev.data.ptr = evep;

    if (epoll_ctl (epollop->epfd, op, fd, &epev) == -1)
        return (-1);

    if (needreaddelete)
        evep->evread = NULL;
    if (needwritedelete)
        evep->evwrite = NULL;

    return (0);
}

#endif
