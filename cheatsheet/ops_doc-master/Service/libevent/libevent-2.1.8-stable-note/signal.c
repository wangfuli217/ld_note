/*	$OpenBSD: select.c,v 1.2 2002/06/25 15:50:15 mickey Exp $	*/

/*
 * Copyright 2000-2007 Niels Provos <provos@citi.umich.edu>
 * Copyright 2007-2012 Niels Provos and Nick Mathewson
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
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
 */
#include "event2/event-config.h"
#include "evconfig-private.h"

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <winsock2.h>
#include <windows.h>
#undef WIN32_LEAN_AND_MEAN
#endif
#include <sys/types.h>
#ifdef EVENT__HAVE_SYS_TIME_H
#include <sys/time.h>
#endif
#include <sys/queue.h>
#ifdef EVENT__HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef EVENT__HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <errno.h>
#ifdef EVENT__HAVE_FCNTL_H
#include <fcntl.h>
#endif

#include "event2/event.h"
#include "event2/event_struct.h"
#include "event-internal.h"
#include "event2/util.h"
#include "evsignal-internal.h"
#include "log-internal.h"
#include "evmap-internal.h"
#include "evthread-internal.h"

/*
  signal.c

  This is the signal-handling implementation we use for backends that don't
  have a better way to do signal handling.  It uses sigaction() or signal()
  to set a signal handler, and a socket pair to tell the event base when

  Note that I said "the event base" : only one event base can be set up to use
  this at a time.  For historical reasons and backward compatibility, if you
  add an event for a signal to event_base A, then add an event for a signal
  (any signal!) to event_base B, event_base B will get informed about the
  signal, but event_base A won't.

  It would be neat to change this behavior in some future version of Libevent.
  kqueue already does something far more sensible.  We can make all backends
  on Linux do a reasonable thing using signalfd.
*/

#ifndef _WIN32
/* Windows wants us to call our signal handlers as __cdecl.  Nobody else
 * expects you to do anything crazy like this. */
#define __cdecl
#endif

static int evsig_add(struct event_base *, evutil_socket_t, short, short, void *);
static int evsig_del(struct event_base *, evutil_socket_t, short, short, void *);

// 信号事件的后台处理方法
static const struct eventop evsigops = {
	"signal",
	NULL,
	evsig_add,
	evsig_del,
	NULL,
	NULL,
	0, 0, 0
};

#ifndef EVENT__DISABLE_THREAD_SUPPORT
/* Lock for evsig_base and evsig_base_n_signals_added fields. */
static void *evsig_base_lock = NULL;
#endif
/* The event base that's currently getting informed about signals. */
static struct event_base *evsig_base = NULL;
/* A copy of evsig_base->sigev_n_signals_added. */
// 当前event_base中增加的信号事件的总数
static int evsig_base_n_signals_added = 0;
// 信号事件的文件描述符,base->sig.ev_signal_pair[1]，即用来写入信号的内部管道
static evutil_socket_t evsig_base_fd = -1;

static void __cdecl evsig_handler(int sig);

#define EVSIGBASE_LOCK() EVLOCK_LOCK(evsig_base_lock, 0)
#define EVSIGBASE_UNLOCK() EVLOCK_UNLOCK(evsig_base_lock, 0)

// 信号的一些static变量设置
void
evsig_set_base_(struct event_base *base)
{
	EVSIGBASE_LOCK();
	evsig_base = base;
	evsig_base_n_signals_added = base->sig.ev_n_signals_added;
	evsig_base_fd = base->sig.ev_signal_pair[1];
	EVSIGBASE_UNLOCK();
}

/* Callback for when the signal handler write a byte to our signaling socket */
// 当信号句柄往信号处理管道中写入字节时的event_base返回可读事件后的回调函数
// arg一般是event_base句柄
// 每当注册信号发生时，就会将该信号绑定的回调函数插入到激活队列中
static void
evsig_cb(evutil_socket_t fd, short what, void *arg)
{
    // 用来存储信号通知管道的数据，每个字节代表一个信号
	static char signals[1024];
	ev_ssize_t n;
	int i;
    // NSIG是linux系统定义的常量
    // 用来存储捕捉的信号次数，每个数组变量代表一个信号
	int ncaught[NSIG];
	struct event_base *base;

	base = arg;

    // 清空存储捕捉信号的缓存
	memset(&ncaught, 0, sizeof(ncaught));

    // 循环读取信号管道socketpair中的数据，直到读完或者无法读取为止。
    // 读到的数据即是信号，并记录该信号发生的次数
    // 管道的读端注意是非阻塞的
	while (1) {
#ifdef _WIN32
		n = recv(fd, signals, sizeof(signals), 0);
#else
		n = read(fd, signals, sizeof(signals));
#endif
		if (n == -1) {
			int err = evutil_socket_geterror(fd);
			if (! EVUTIL_ERR_RW_RETRIABLE(err))
				event_sock_err(1, fd, "%s: recv", __func__);
			break;
		} else if (n == 0) {
			/* XXX warn? */
			break;
		}
        // 遍历缓存中的每个字节，即信号值
        // 如果信号值合法，则表示该信号发生一次，增加该信号发生次数
		for (i = 0; i < n; ++i) {
			ev_uint8_t sig = signals[i];
			if (sig < NSIG)
				ncaught[sig]++;
		}
	}

	EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    // 遍历当前信号发生次数，激活与信号相关的事件，
    // 实际上是将信号相关的回调函数插入到激活事件队列中
	for (i = 0; i < NSIG; ++i) {
		if (ncaught[i])
			evmap_signal_active_(base, i, ncaught[i]);
	}
	EVBASE_RELEASE_LOCK(base, th_base_lock);
}

// 初始化内部信号事件
// 主要是将信号事件base->sig.ev_signal[0]绑定到base上，信号关联文件描述符；
// base->sig.ev_signal_pair是文件描述符对，一个是用来读取数据的，一个是用来写数据的；
// 其中base->sig.ev_signal_pair[0]，即用来读取信号的；
// base->sig.ev_signal_pair[1]是用来写信号的，此处只是绑定0，因为这是信号接收端
// 只有真有外部信号事件注册时，才会绑定base->sig.ev_signal_pair[0]
int
evsig_init_(struct event_base *base)
{
	/*
	 * Our signal handler is going to write to one end of the socket
	 * pair to wake up our event loop.  The event loop then scans for
	 * signals that got delivered.
	 */
    // 创建内部使用的通知管道，将创建好的文件描述符存在ev_signal_pair中
	if (evutil_make_internal_pipe_(base->sig.ev_signal_pair) == -1) {
#ifdef _WIN32
		/* Make this nonfatal on win32, where sometimes people
		   have localhost firewalled. */
		event_sock_warn(-1, "%s: socketpair", __func__);
#else
		event_sock_err(1, -1, "%s: socketpair", __func__);
#endif
		return -1;
	}

    // 如果存在原有信号句柄则释放，并置空
	if (base->sig.sh_old) {
		mm_free(base->sig.sh_old);
	}
	base->sig.sh_old = NULL;
	base->sig.sh_old_max = 0;

    // 将信号事件base->sig.ev_signal绑定在base上，关联文件描述符base->sig.ev_signal_pair[0]，
    // ev_signal_pair[0]是用来读的，事件类型是EV_READ|EV_PERSIST，包括可读和持久化，事件发生
    // 时的回调函数是evsig_cb函数，回调函数的参数是base
    // 这里就说明了，base->sig.ev_signal是内部事件，是用来外部信号发生时，通知内部信号处理函数的；
    // 其实就是将外部信号转换为内部IO事件来处理
	event_assign(&base->sig.ev_signal, base, base->sig.ev_signal_pair[0],
		EV_READ | EV_PERSIST, evsig_cb, base);

    // 设置信号事件的事件状态为EVLIST_INTERNAL，即内部事件
	base->sig.ev_signal.ev_flags |= EVLIST_INTERNAL;
    // 设置信号事件的优先级为0，即最高优先级，信号事件优先处理
	event_priority_set(&base->sig.ev_signal, 0);

    // 设置信号事件的后台处理方法
	base->evsigsel = &evsigops;

	return 0;
}

/* Helper: set the signal handler for evsignal to handler in base, so that
 * we can restore the original handler when we clear the current one. */
// 设置外部信号的捕捉处理句柄
// 在event_base中为信号设置信号处理句柄handler，
// 并保存旧的handler到sig->sh_old,这样当清除当前信号时，就可以重新存储一般的信号处理句柄
int
evsig_set_handler_(struct event_base *base,
    int evsignal, void (__cdecl *handler)(int))
{
#ifdef EVENT__HAVE_SIGACTION
	struct sigaction sa;
#else
	ev_sighandler_t sh;
#endif
	struct evsig_info *sig = &base->sig;
	void *p;

	/*
	 * resize saved signal handler array up to the highest signal number.
	 * a dynamic array is used to keep footprint on the low side.
	 */
    // 重新调整信号句柄数组大小，以适应最大的信号值。
    // 一旦当前信号值大于原有最大信号值，则需要重新申请空间
	if (evsignal >= sig->sh_old_max) {
		int new_max = evsignal + 1;
		event_debug(("%s: evsignal (%d) >= sh_old_max (%d), resizing",
			    __func__, evsignal, sig->sh_old_max));
		p = mm_realloc(sig->sh_old, new_max * sizeof(*sig->sh_old));
		if (p == NULL) {
			event_warn("realloc");
			return (-1);
		}

		memset((char *)p + sig->sh_old_max * sizeof(*sig->sh_old),
		    0, (new_max - sig->sh_old_max) * sizeof(*sig->sh_old));

		sig->sh_old_max = new_max;
		sig->sh_old = p;
	}

	/* allocate space for previous handler out of dynamic array */
    // 为新增的信号分配空间
    //注意sh_old是一个二级指针。元素是一个一级指针。为这个一级指针分配内存
	sig->sh_old[evsignal] = mm_malloc(sizeof *sig->sh_old[evsignal]);
	if (sig->sh_old[evsignal] == NULL) {
		event_warn("malloc");
		return (-1);
	}

	/* save previous handler and setup new handler */
    // 保存以前的信号句柄，并配置新的信号句柄
    // 将新增信号和信号处理函数handler绑定到一起
#ifdef EVENT__HAVE_SIGACTION
	memset(&sa, 0, sizeof(sa));
	sa.sa_handler = handler;
	sa.sa_flags |= SA_RESTART;
	sigfillset(&sa.sa_mask);

    //设置信号处理函数
	if (sigaction(evsignal, &sa, sig->sh_old[evsignal]) == -1) {
		event_warn("sigaction");
		mm_free(sig->sh_old[evsignal]);
		sig->sh_old[evsignal] = NULL;
		return (-1);
	}
#else
	if ((sh = signal(evsignal, handler)) == SIG_ERR) {
		event_warn("signal");
		mm_free(sig->sh_old[evsignal]);
		sig->sh_old[evsignal] = NULL;
		return (-1);
	}
	*sig->sh_old[evsignal] = sh;
#endif

	return (0);
}

// 将信号事件注册到event_base上,同时将信号和捕捉信号的函数
// 通过signal系统函数绑定到一起，一旦捕捉信号的函数捕捉到信号，
// 则会将信号写入内部信号通知管道，然后会触发内部信号通知事件，
// 内部信号通知事件会从内部信号通知管道读取信号，
// 然后根据信号值，触发相应外部信号事件回调函数
// base：绑定到哪个event_base上
// evsignal：需要绑定的信号
// old：该信号上的老的事件类型
// events：该信号上当前的事件类型
// p：目前尚未用到
static int
evsig_add(struct event_base *base, evutil_socket_t evsignal, short old, short events, void *p)
{
    // 这里实际上是内部信号通知事件，用于将外部信号转换为内部事件的具体实现
	struct evsig_info *sig = &base->sig;
	(void)p;

    // NSIG是信号的个数。定义在系统头文件中
	EVUTIL_ASSERT(evsignal >= 0 && evsignal < NSIG);

	/* catch signals if they happen quickly */
	EVSIGBASE_LOCK();
    // 如果有多个event_base，那么捕抓信号这个工作只能由其中一个完成
	if (evsig_base != base && evsig_base_n_signals_added) {
		event_warnx("Added a signal to event base %p with signals "
		    "already added to event_base %p.  Only one can have "
		    "signals at a time with the %s backend.  The base with "
		    "the most recently added signal or the most recent "
		    "event_base_loop() call gets preference; do "
		    "not rely on this behavior in future Libevent versions.",
		    base, evsig_base, base->evsel->name);
	}
	evsig_base = base;
	evsig_base_n_signals_added = ++sig->ev_n_signals_added;
	evsig_base_fd = base->sig.ev_signal_pair[1];
	EVSIGBASE_UNLOCK();

	event_debug(("%s: %d: changing signal handler", __func__, (int)evsignal));
    // 将信号注册到信号捕捉函数evsig_handler上
    // evsig_handler会捕捉信号，然后将信号写入base->sig.ev_signal_pair[1]，
    // 用来通知内部管道，进而通知event_base处理
	if (evsig_set_handler_(base, (int)evsignal, evsig_handler) == -1) {
		goto err;
	}


    // 这里实际上是在添加外部信号事件时，会添加内部信号通知事件，
    // 目的是为了将外部信号事件借助内部管道将捕捉到的外部信号转换为内部IO事件
	if (!sig->ev_signal_added) {
		if (event_add_nolock_(&sig->ev_signal, NULL, 0))
			goto err;
		sig->ev_signal_added = 1;
	}

	return (0);

err:
	EVSIGBASE_LOCK();
	--evsig_base_n_signals_added;
	--sig->ev_n_signals_added;
	EVSIGBASE_UNLOCK();
	return (-1);
}

int
evsig_restore_handler_(struct event_base *base, int evsignal)
{
	int ret = 0;
	struct evsig_info *sig = &base->sig;
#ifdef EVENT__HAVE_SIGACTION
	struct sigaction *sh;
#else
	ev_sighandler_t *sh;
#endif

	if (evsignal >= sig->sh_old_max) {
		/* Can't actually restore. */
		/* XXXX.*/
		return 0;
	}

	/* restore previous handler */
	sh = sig->sh_old[evsignal];
	sig->sh_old[evsignal] = NULL;
#ifdef EVENT__HAVE_SIGACTION
	if (sigaction(evsignal, sh, NULL) == -1) {
		event_warn("sigaction");
		ret = -1;
	}
#else
	if (signal(evsignal, *sh) == SIG_ERR) {
		event_warn("signal");
		ret = -1;
	}
#endif

	mm_free(sh);

	return ret;
}

static int
evsig_del(struct event_base *base, evutil_socket_t evsignal, short old, short events, void *p)
{
	EVUTIL_ASSERT(evsignal >= 0 && evsignal < NSIG);

	event_debug(("%s: "EV_SOCK_FMT": restoring signal handler",
		__func__, EV_SOCK_ARG(evsignal)));

	EVSIGBASE_LOCK();
	--evsig_base_n_signals_added;
	--base->sig.ev_n_signals_added;
	EVSIGBASE_UNLOCK();

	return (evsig_restore_handler_(base, (int)evsignal));
}

// 信号捕捉函数
static void __cdecl
evsig_handler(int sig)
{
	int save_errno = errno;
#ifdef _WIN32
	int socket_errno = EVUTIL_SOCKET_ERROR();
#endif
	ev_uint8_t msg;

	if (evsig_base == NULL) {
		event_warnx(
			"%s: received signal %d, but have no base configured",
			__func__, sig);
		return;
	}

#ifndef EVENT__HAVE_SIGACTION
	signal(sig, evsig_handler);
#endif

	/* Wake up our notification mechanism */
	msg = sig;
#ifdef _WIN32
	send(evsig_base_fd, (char*)&msg, 1, 0);
#else
	{
        // 往管道写入该信号值，则event_base被唤醒，监听到对端可读，并判断是哪个信号发生
		int r = write(evsig_base_fd, (char*)&msg, 1);
		(void)r; /* Suppress 'unused return value' and 'unused var' */
	}
#endif
	errno = save_errno;
#ifdef _WIN32
	EVUTIL_SET_SOCKET_ERROR(socket_errno);
#endif
}

void
evsig_dealloc_(struct event_base *base)
{
	int i = 0;
	if (base->sig.ev_signal_added) {
		event_del(&base->sig.ev_signal);
		base->sig.ev_signal_added = 0;
	}
	/* debug event is created in evsig_init_/event_assign even when
	 * ev_signal_added == 0, so unassign is required */
	event_debug_unassign(&base->sig.ev_signal);

	for (i = 0; i < NSIG; ++i) {
		if (i < base->sig.sh_old_max && base->sig.sh_old[i] != NULL)
			evsig_restore_handler_(base, i);
	}
	EVSIGBASE_LOCK();
	if (base == evsig_base) {
		evsig_base = NULL;
		evsig_base_n_signals_added = 0;
		evsig_base_fd = -1;
	}
	EVSIGBASE_UNLOCK();

	if (base->sig.ev_signal_pair[0] != -1) {
		evutil_closesocket(base->sig.ev_signal_pair[0]);
		base->sig.ev_signal_pair[0] = -1;
	}
	if (base->sig.ev_signal_pair[1] != -1) {
		evutil_closesocket(base->sig.ev_signal_pair[1]);
		base->sig.ev_signal_pair[1] = -1;
	}
	base->sig.sh_old_max = 0;

	/* per index frees are handled in evsig_del() */
	if (base->sig.sh_old) {
		mm_free(base->sig.sh_old);
		base->sig.sh_old = NULL;
	}
}

static void
evsig_free_globals_locks(void)
{
#ifndef EVENT__DISABLE_THREAD_SUPPORT
	if (evsig_base_lock != NULL) {
		EVTHREAD_FREE_LOCK(evsig_base_lock, 0);
		evsig_base_lock = NULL;
	}
#endif
	return;
}

void
evsig_free_globals_(void)
{
	evsig_free_globals_locks();
}

#ifndef EVENT__DISABLE_THREAD_SUPPORT
int
evsig_global_setup_locks_(const int enable_locks)
{
	EVTHREAD_SETUP_GLOBAL_LOCK(evsig_base_lock, 0);
	return 0;
}

#endif
