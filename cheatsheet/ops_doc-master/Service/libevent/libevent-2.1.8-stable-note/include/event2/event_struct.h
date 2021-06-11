/*
 * Copyright (c) 2000-2007 Niels Provos <provos@citi.umich.edu>
 * Copyright (c) 2007-2012 Niels Provos and Nick Mathewson
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
#ifndef EVENT2_EVENT_STRUCT_H_INCLUDED_
#define EVENT2_EVENT_STRUCT_H_INCLUDED_

/** @file event2/event_struct.h

  Structures used by event.h.  Using these structures directly WILL harm
  forward compatibility: be careful.

  No field declared in this file should be used directly in user code.  Except
  for historical reasons, these fields would not be exposed at all.
 */

#ifdef __cplusplus
extern "C" {
#endif

#include <event2/event-config.h>
#ifdef EVENT__HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#ifdef EVENT__HAVE_SYS_TIME_H
#include <sys/time.h>
#endif

/* For int types. */
#include <event2/util.h>

/* For evkeyvalq */
#include <event2/keyvalq_struct.h>

// 事件在time min_heap堆中
#define EVLIST_TIMEOUT	    0x01
// 事件在已注册事件链表中
#define EVLIST_INSERTED	    0x02
// 目前未使用
#define EVLIST_SIGNAL	    0x04
// 事件在激活链表中(如果event监听的事件发生了或者超时了，处于激活状态)
// event_base的active_queue中
#define EVLIST_ACTIVE	    0x08
// 内部使用标记
#define EVLIST_INTERNAL	    0x10
// 事件在下一次激活链表中
#define EVLIST_ACTIVE_LATER 0x20
// 事件已经终止
#define EVLIST_FINALIZING   0x40
// 事件已被初始化(用event_new创建的event都是处于已初始化状态的)
#define EVLIST_INIT	    0x80
// 包含所有事件状态，用于判断合法性的
#define EVLIST_ALL          0xff

/* Fix so that people don't have to run with <sys/queue.h> */
#ifndef TAILQ_ENTRY
#define EVENT_DEFINED_TQENTRY_
// 可以指向任意类型的的一个双向链表节点
#define TAILQ_ENTRY(type)						\
struct {								\
	struct type *tqe_next;	/* next element */			\
	struct type **tqe_prev;	/* address of previous next element */	\
}
#endif /* !TAILQ_ENTRY */

#ifndef TAILQ_HEAD
#define EVENT_DEFINED_TQHEAD_
#define TAILQ_HEAD(name, type)			\
struct name {					\
	struct type *tqh_first;			\
	struct type **tqh_last;			\
}
#endif

/* Fix so that people don't have to run with <sys/queue.h> */
#ifndef LIST_ENTRY
#define EVENT_DEFINED_LISTENTRY_
#define LIST_ENTRY(type)						\
struct {								\
	struct type *le_next;	/* next element */			\
	struct type **le_prev;	/* address of previous next element */	\
}
#endif /* !LIST_ENTRY */

#ifndef LIST_HEAD
#define EVENT_DEFINED_LISTHEAD_
#define LIST_HEAD(name, type)						\
struct name {								\
	struct type *lh_first;  /* first element */			\
	}
#endif /* !LIST_HEAD */

struct event;

// event的回调函数
struct event_callback {
    TAILQ_ENTRY(event_callback) evcb_active_next; //链表结点，事件发生后链接到激活链表
    //回调事件的状态标识，具体为：
     //           #define EVLIST_TIMEOUT 0x01 // event在time堆中，min_heap
     //           #define EVLIST_INSERTED 0x02 // event在已注册事件链表中，event_base的queue中
     //           #define EVLIST_SIGNAL 0x04 // 未见使用
     //           #define EVLIST_ACTIVE 0x08 // event在激活链表中，event_base的active_queue中
     //           #define EVLIST_INTERNAL 0x10 // 内部使用标记
     //           #define EVLIST_ACTIVE_LATER 0x20 event在下一次激活链表中
     //           #define EVLIST_INIT     0x80 // event已被初始化
      //          #define EVLIST_ALL          0xff // 主要用于判断事件状态的合法性
	short evcb_flags;
    // 回调函数的优先级，越小优先级越高
    ev_uint8_t evcb_pri;	/* smaller numbers are higher priority */
    // EV_CLOSURE_XXX对应不同的回调函数
	ev_uint8_t evcb_closure;
	/* allows us to adopt for different types of events */
    // 允许我们自动适配不同类型的回调事件
        union {
		void (*evcb_callback)(evutil_socket_t, short, void *);
		void (*evcb_selfcb)(struct event_callback *, void *);
		void (*evcb_evfinalize)(struct event *, void *);
		void (*evcb_cbfinalize)(struct event_callback *, void *);
	} evcb_cb_union;
    // 回调参数
	void *evcb_arg;
};

struct event_base;
// event结构体表示一个事件，事件可以是IO事件，信号时间，定时器超时事件
// 一个event由一个event_base管理
struct event {
    // event的回调函数，被event_base调用
     // 以下为一些常用的宏定义
     // #define ev_pri ev_evcallback.evcb_pri
     // #define ev_flags ev_evcallback.evcb_flags
     // #define ev_closure ev_evcallback.evcb_closure
     // #define ev_callback ev_evcallback.evcb_cb_union.evcb_callback
     // #define ev_arg ev_evcallback.evcb_arg
	struct event_callback ev_evcallback;

	/* for managing timeouts */
    // 用来管理超时事件
	union {
        // 公用超时队列
		TAILQ_ENTRY(event) ev_next_with_common_timeout;
        // 其在管理超时事件的小根堆中的索引
		int min_heap_idx;
	} ev_timeout_pos;
    // 如果是I/O事件，ev_fd为文件描述符；如果是信号，ev_fd为信号
	evutil_socket_t ev_fd;

    // 该事件所属的反应堆实例,一个libevent实例
	struct event_base *ev_base;

    // 用共用体来同时表现IO事件和信号
    // 以下为一些方便调用的宏定义
    /* mutually exclusive */
    // #define ev_signal_next    ev_.ev_signal.ev_signal_next
    // #define ev_io_next    ev_.ev_io.ev_io_next
    // #define ev_io_timeout    ev_.ev_io.ev_timeout

    /* used only by signals */
    // #define ev_ncalls    ev_.ev_signal.ev_ncalls
    // #define ev_pncalls    ev_.ev_signal.ev_pncalls
	union {
		/* used for io events */
		struct {
            // 下一个io事件
			LIST_ENTRY (event) ev_io_next;
            // 事件超时时间（既可以是相对时间，也可以是绝对时间）
			struct timeval ev_timeout;
		} ev_io;

		/* used by signal events */
		struct {
            // 下一个信号
			LIST_ENTRY (event) ev_signal_next;
            // 信号准备激活时，调用ev_callback的次数
			short ev_ncalls;
			/* Allows deletes in callback */
            // 通常指向 ev_ncalls或者NULL
			short *ev_pncalls;
		} ev_signal;
	} ev_;

    // 事件类型，它可以是以下三种类型，其中io事件和信号无法同时成立
    // io事件： EV_READ,EV_WRITE
    // 定时事件：EV_TIMEOUT
    // 信号：EV_SIGNAL
    // 以下是辅助选项，可以和任何事件同时成立
    // EV_PERSIST，表明是一个永久事件，表示执行完毕不会移除，如不加，则执行完毕之后会自动移除
    // EV_ET: 边沿触发，如果后台方法可用的话，就可以使用；注意区分水平触发
    // EV_FINALIZE：删除事件时就不会阻塞了，不会等到回调函数执行完毕；为了在多线程中安全使用，需要使用
    // event_finalize()或者event_free_finalize()
    // EV_CLOSED： 可以自动监测关闭的连接，然后放弃读取未完的数据，但是不是所有后台方法都支持这个选项
	short ev_events;
    // 记录当前激活事件的类型
	short ev_res;		/* result passed to event callback */
    // 保存事件的绝对超时时间
	struct timeval ev_timeout;
};

TAILQ_HEAD (event_list, event);

#ifdef EVENT_DEFINED_TQENTRY_
#undef TAILQ_ENTRY
#endif

#ifdef EVENT_DEFINED_TQHEAD_
#undef TAILQ_HEAD
#endif

LIST_HEAD (event_dlist, event); 

#ifdef EVENT_DEFINED_LISTENTRY_
#undef LIST_ENTRY
#endif

#ifdef EVENT_DEFINED_LISTHEAD_
#undef LIST_HEAD
#endif

#ifdef __cplusplus
}
#endif

#endif /* EVENT2_EVENT_STRUCT_H_INCLUDED_ */
