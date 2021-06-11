/*
 * Copyright 2003 Niels Provos <provos@citi.umich.edu>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * Mon 03/10/2003 - Modified by Davide Libenzi <davidel@xmailserver.org>
 *
 *     Added chain event propagation to improve the sensitivity of
 *     the measure respect to the event loop efficency.
 *
 *
 */

#define	timersub(tvp, uvp, vvp)						\
	do {								\
		(vvp)->tv_sec = (tvp)->tv_sec - (uvp)->tv_sec;		\
		(vvp)->tv_usec = (tvp)->tv_usec - (uvp)->tv_usec;	\
		if ((vvp)->tv_usec < 0) {				\
			(vvp)->tv_sec--;				\
			(vvp)->tv_usec += 1000000;			\
		}							\
	} while (0)
#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <sys/signal.h>
#include <sys/resource.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <assert.h>

#if WITH_libev
# include "ev.h"
struct ev_loop *ev_loop0;
#endif

#if WITH_libevent
#include "event.h"
#endif

#if WITH_picoev
# include "picoev.h"
picoev_loop* pe_loop;
#endif

#if WITH_libuv
#include "uv.h"
uv_loop_t uv_loop;
#endif

#if WITH_libuev
#include "uev/uev.h"
uev_ctx_t uev_ctx;
#endif


static int count, writes, fired;
static int *pipes;
static int num_pipes, num_active, num_writes, num_runs, use_pipes;
static int timers;

#if WITH_libevent
static struct event *events;
#endif

#if WITH_libev
static struct ev_io *evio;
static struct ev_timer *evto;
#endif

#if WITH_libuev
static uev_t *uev_watchers;
#endif

#if WITH_libuv
static uv_poll_t *uv_polls;
#endif

static enum libraries {
#if WITH_libev
	LIB_libev    = 0,
#endif
#if WITH_libevent
	LIB_libevent = 1,
#endif
#if WITH_libuev
	LIB_libuev   = 2,
#endif
#if WITH_libuv
	LIB_libuv    = 3,
#endif
#if WITH_picoev
	LIB_picoev   = 4,
#endif
} library;

void
read_cb(int fd, short which, void *arg)
{
	intptr_t idx = (intptr_t) arg, widx = idx + 1;
	u_char ch;

	if (timers) {
		double drand = drand48();
		switch (library) {
#if WITH_libev
		case LIB_libev:
			evto [idx].repeat = 10. + drand;
			ev_timer_again (ev_loop0, &evto [idx]);
			break;
#endif
#if WITH_libevent
		case LIB_libevent:
			{
			struct timeval tv;
			event_del (&events [idx]);
			tv.tv_sec  = 10;
			tv.tv_usec = drand * 1e6;
			event_add(&events[idx], &tv);
			}
			break;
#endif
#if WITH_libuev
		case LIB_libuev:
			abort();
			break;
#endif
#if WITH_libuv
		case LIB_libuv:
			abort();
			break;
#endif
#if WITH_picoev
		case LIB_picoev:
			picoev_set_timeout(pe_loop, fd, 10);
			break;
#endif
		default:
			abort();
		}
	}

	count += read(fd, &ch, sizeof(ch));
	if (writes) {
		if (widx >= num_pipes)
			widx -= num_pipes;
		write(pipes[2 * widx + 1], "e", 1);
		writes--;
		fired++;
	}
}

#if WITH_picoev
void
cb_picoev(picoev_loop* loop, int fd, int revents, void* cb_arg)
{
	read_cb(fd, revents, cb_arg);
}
#endif

#if WITH_libev
void
read_thunk(struct ev_loop *loop, struct ev_io *w, int revents)
{
	read_cb (w->fd, revents, w->data);
}

void
timer_cb (struct ev_loop *loop, struct ev_timer *w, int revents)
{
	assert(0);
}
#endif

#if WITH_libuev
void uev_read_cb(uev_t *w, void *arg, int events)
{
	read_cb (w->fd, events, w->arg);
}
#endif

#if WITH_libuv
void uv_read_cb_func(uv_poll_t *p, int status, int events)
{
	intptr_t idx = p - uv_polls;
	int fd = pipes[idx * 2];

	read_cb(fd, events, (void*)idx);
}
#endif

struct timeval *
run_once(void)
{
	intptr_t i;
	int *cp, space;
	static struct timeval ta, ts, te, tv;

	gettimeofday(&ta, NULL);
	for (cp = pipes, i = 0; i < num_pipes; i++, cp += 2) {
		double drand = drand48();
		switch (library) {
#if WITH_libev
		case LIB_libev:
			if (ev_is_active (&evio [i]))
				ev_io_stop (ev_loop0, &evio [i]);

			ev_io_set (&evio [i], cp [0], EV_READ);
			ev_io_start (ev_loop0, &evio [i]);

			evto [i].repeat = 10. + drand;
			ev_timer_again (ev_loop0, &evto [i]);
			break;
#endif
#if WITH_libevent
		case LIB_libevent:
			if (events[i].ev_base)
				event_del(&events[i]);
			event_set(&events[i], cp[0], EV_READ | EV_PERSIST, read_cb, (void *) i);
			tv.tv_sec  = 10.;
			tv.tv_usec = drand * 1e6;
			event_add(&events[i], timers ? &tv : 0);
			break;
#endif
#if WITH_libuev
		case LIB_libuev:
			if (uev_io_active(&uev_watchers[i])) {
				uev_io_stop(&uev_watchers[i]);
			}
			{
			int rc = uev_io_init(&uev_ctx, &uev_watchers[i],
					     uev_read_cb, (void*)i, cp[0], UEV_READ);
			assert(!rc);
			}
			break;
#endif
#if WITH_libuv
		case LIB_libuv:
			//uv_poll_stop(&uv_polls[i]);

			uv_poll_init(&uv_loop, &uv_polls[i], cp[0]);
			uv_poll_start(&uv_polls[i], UV_READABLE, uv_read_cb_func);
			break;
#endif
#if WITH_picoev
		case LIB_picoev:
			if (picoev_is_active(pe_loop, cp[0])) {
				picoev_del(pe_loop, cp[0]);
			}
			picoev_add(pe_loop, cp[0], PICOEV_READ, 10, cb_picoev, (void*)i);
			break;
#endif
		default:
			abort();
		}
	}

	switch (library) {
#if WITH_libev
	case LIB_libev:
		ev_run(ev_loop0, EVRUN_ONCE | EVRUN_NOWAIT);
		break;
#endif
#if WITH_libevent
	case LIB_libevent:
		event_loop(EVLOOP_ONCE | EVLOOP_NONBLOCK);
		break;
#endif
#if WITH_libuev
	case LIB_libuev:
		/* there are no timeouts on events, so cannot call a loop now */
		//uev_run(&uev_ctx, UEV_ONCE);
		break;
#endif
#if WITH_libuv
	case LIB_libuv:
		/* there are no timeouts on events, so cannot call a loop now */
		//uv_run(&uv_loop, UV_RUN_ONCE);
		break;
#endif
#if WITH_picoev
	case LIB_picoev:
		picoev_loop_once(pe_loop, 0);
		break;
#endif
	default:
		abort();
	}

	fired = 0;
	space = num_pipes / num_active;
	space = space * 2;
	for (i = 0; i < num_active; i++, fired++) {
		write(pipes[i * space + 1], "e", 1);
	}

	count = 0;
	writes = num_writes;
	{
		int xcount = 0;
		gettimeofday(&ts, NULL);
		do {
			switch (library) {
#if WITH_libev
			case LIB_libev:
				ev_run(ev_loop0, EVRUN_ONCE | EVRUN_NOWAIT);
				break;
#endif
#if WITH_libevent
			case LIB_libevent:
				event_loop(EVLOOP_ONCE | EVLOOP_NONBLOCK);
				break;
#endif
#if WITH_libuev
			case LIB_libuev:
				uev_run(&uev_ctx, UEV_ONCE);
				break;
#endif
#if WITH_libuv
			case LIB_libuv:
				uv_run(&uv_loop, UV_RUN_ONCE);
				break;
#endif
#if WITH_picoev
			case LIB_picoev:
				picoev_loop_once(pe_loop, 0);
				break;
#endif
			default:
				abort();
			}
			xcount++;
		} while (count != fired);
		gettimeofday(&te, NULL);

		//if (xcount != count) fprintf(stderr, "Xcount: %d, Rcount: %d\n", xcount, count);
	}

	timersub(&te, &ta, &ta);
	timersub(&te, &ts, &ts);
	fprintf(stdout, "%8ld %8ld\n",
		ta.tv_sec * 1000000L + ta.tv_usec,
		ts.tv_sec * 1000000L + ts.tv_usec
	       );

	return (&te);
}

int
main (int argc, char **argv)
{
	struct rlimit rl;
	intptr_t i;
	int c, rc;
	struct timeval *tv;
	int *cp;
	extern char *optarg;

#if WITH_libev
	library = LIB_libev;
#elif WITH_libevent
	library = LIB_libevent;
#elif WITH_libuev
	library = LIB_libuev;
#elif WITH_libuv
	library = LIB_libuv;
#elif WITH_picoev
	library = LIB_picoev;
#else
#error nothing enabled
#endif

	use_pipes = 0;
	num_runs = 2;
	num_pipes = 100;
	num_active = 1;
	num_writes = num_pipes;
	while ((c = getopt(argc, argv, "n:a:r:w:pte:")) != -1) {
		switch (c) {
		case 'n':
			num_pipes = atoi(optarg);
			break;
		case 'a':
			num_active = atoi(optarg);
			break;
		case 'r':
			num_runs = atoi(optarg);
			break;
		case 'w':
			num_writes = atoi(optarg);
			break;
		case 'e':
#if WITH_libev
			if (strcmp(optarg, "libev") == 0) {
				library = LIB_libev;
			} else
#endif
#if WITH_libevent
			if (strcmp(optarg, "libevent") == 0) {
				library = LIB_libevent;
			} else
#endif
#if WITH_libuev
			if (strcmp(optarg, "libuev") == 0) {
				library = LIB_libuev;
			} else
#endif
#if WITH_libuv
			if (strcmp(optarg, "libuv") == 0) {
				library = LIB_libuv;
			} else
#endif
#if WITH_picoev
			if (strcmp(optarg, "picoev") == 0) {
				library = LIB_picoev;
			} else
#endif
			{
				fprintf(stderr, "unknown event loop: \"%s\"\n",
					optarg);
				exit(1);
			}
			break;
		case 'p':
			use_pipes = 1;
			break;
		case 't':
			timers = 1;
			break;
		default:
			fprintf(stderr, "Illegal argument \"%c\"\n", c);
			exit(1);
		}
	}

#if 1
	rl.rlim_cur = rl.rlim_max = num_pipes * 2 + 50;
	if (setrlimit(RLIMIT_NOFILE, &rl) == -1) {
		perror("setrlimit");
	}
#endif

#if WITH_picoev
	picoev_init(num_pipes * 2 + 20);
	pe_loop = picoev_create_loop(60);
#endif

#if WITH_libev
	evio = calloc(num_pipes, sizeof(struct ev_io));
	assert(evio);
	evto = calloc(num_pipes, sizeof(struct ev_timer));
	assert(evto);
#endif

#if WITH_libevent
	events = calloc(num_pipes, sizeof(struct event));
	assert(events);
	event_init();
#endif

#if WITH_libuv
	uv_polls = calloc(num_pipes, sizeof(uv_poll_t));
	assert(uv_polls);
	uv_loop_init(&uv_loop);
#endif

#if WITH_libuev
	uev_watchers = calloc(num_pipes, sizeof(uev_t));
	uev_init(&uev_ctx);
#endif

	pipes = calloc(num_pipes * 2, sizeof(int));
	assert(pipes);

	for (cp = pipes, i = 0; i < num_pipes; i++, cp += 2) {
#if WITH_libev
		if (library == LIB_libev) {
			ev_init (&evto [i], timer_cb);
			ev_init (&evio [i], read_thunk);
			evio [i].data = (void *)i;
			ev_loop0 = ev_default_loop(0);
		}
#endif
		if (use_pipes)
			rc = pipe(cp);
		else
			rc = socketpair(AF_UNIX, SOCK_STREAM, 0, cp);
		if (rc == -1) {
			perror(use_pipes ? "pipe" : "socketpair");
			exit(1);
		}
	}

	for (i = 0; i < num_runs; i++) {
		tv = run_once();
	}

	exit(0);
}
