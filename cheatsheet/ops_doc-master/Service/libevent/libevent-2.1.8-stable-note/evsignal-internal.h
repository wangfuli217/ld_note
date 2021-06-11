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
#ifndef EVSIGNAL_INTERNAL_H_INCLUDED_
#define EVSIGNAL_INTERNAL_H_INCLUDED_

#ifndef evutil_socket_t
#include "event2/util.h"
#endif
#include <signal.h>

typedef void (*ev_sighandler_t)(int);

/* Data structure for the default signal-handling implementation in signal.c
 */
// 存储信号处理的信息
struct evsig_info {
	/* Event watching ev_signal_pair[1] */
    // 监听ev_signal_pair[1]的事件，即内部信号管道监听事件
	struct event ev_signal;
	/* Socketpair used to send notifications from the signal handler */
    // 内部信号通知的管道，0读1写
	evutil_socket_t ev_signal_pair[2];
	/* True iff we've added the ev_signal event yet. */
    // 是否已经将ev_signal这个event加入到event_base中了
	int ev_signal_added;
	/* Count of the number of signals we're currently watching. */
    // 统计当前event_base到底监听了多少信号
	int ev_n_signals_added;

	/* Array of previous signal handler objects before Libevent started
	 * messing with them.  Used to restore old signal handlers. */
#ifdef EVENT__HAVE_SIGACTION
    // 用户可能已经设置过某个信号的信号捕抓函数。但
    // Libevent还是要为这个信号设置另外一个信号捕抓函数，
    // 此时，就要保存用户之前设置的信号捕抓函数。当用户不要
    // 监听这个信号时，就能够恢复用户之前的捕抓函数。
    // 因为是有多个信号，所以得用一个数组保存。
    // 数组的一个元素就存放一个信号的handler。信号值等于其下标
	struct sigaction **sh_old;
#else
    // 保存的是捕抓函数的函数指针，又因为是数组。所以是二级指针
	ev_sighandler_t **sh_old;
#endif
	/* Size of sh_old. */
    // 原有的信号句柄的最大个数
	int sh_old_max;
};
int evsig_init_(struct event_base *);
void evsig_dealloc_(struct event_base *);

void evsig_set_base_(struct event_base *base);
void evsig_free_globals_(void);

#endif /* EVSIGNAL_INTERNAL_H_INCLUDED_ */
