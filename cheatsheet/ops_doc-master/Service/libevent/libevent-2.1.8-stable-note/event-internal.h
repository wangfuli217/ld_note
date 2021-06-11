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
#ifndef EVENT_INTERNAL_H_INCLUDED_
#define EVENT_INTERNAL_H_INCLUDED_

#ifdef __cplusplus
extern "C" {
#endif

#include "event2/event-config.h"
#include "evconfig-private.h"

#include <time.h>
#include <sys/queue.h>
#include "event2/event_struct.h"
#include "minheap-internal.h"
#include "evsignal-internal.h"
#include "mm-internal.h"
#include "defer-internal.h"

/* map union members back */

/* mutually exclusive */
// 获取event中的ev_存储的下一个signal或io事件地址
#define ev_signal_next	ev_.ev_signal.ev_signal_next
#define ev_io_next	ev_.ev_io.ev_io_next
// 获取event中的ev_存储的用户设置的超时时间(相对时间?)
#define ev_io_timeout	ev_.ev_io.ev_timeout

/* used only by signals */
// 事件需要激活的次数
#define ev_ncalls	ev_.ev_signal.ev_ncalls
#define ev_pncalls	ev_.ev_signal.ev_pncalls

// 获取event中的ev_evcallback的相关回调结构体属性
#define ev_pri ev_evcallback.evcb_pri
#define ev_flags ev_evcallback.evcb_flags
#define ev_closure ev_evcallback.evcb_closure
#define ev_callback ev_evcallback.evcb_cb_union.evcb_callback
#define ev_arg ev_evcallback.evcb_arg

/** @name Event closure codes

    Possible values for evcb_closure in struct event_callback

    @{
 */
/** A regular event. Uses the evcb_callback callback */
// 具体参见event_process_active_single_queue()函数switch..case..
// 常规事件，使用evcb_callback回调
#define EV_CLOSURE_EVENT 0
/** A signal event. Uses the evcb_callback callback */
// 信号事件；使用evcb_callback回调
#define EV_CLOSURE_EVENT_SIGNAL 1
/** A persistent non-signal event. Uses the evcb_callback callback */
// 永久性非信号事件；使用evcb_callback回调
#define EV_CLOSURE_EVENT_PERSIST 2
/** A simple callback. Uses the evcb_selfcb callback. */
// 简单回调，使用evcb_selfcb回调
#define EV_CLOSURE_CB_SELF 3
/** A finalizing callback. Uses the evcb_cbfinalize callback. */
// 结束型回调，使用evcb_cbfinalize回调
#define EV_CLOSURE_CB_FINALIZE 4
/** A finalizing event. Uses the evcb_evfinalize callback. */
// 结束事件，使用evcb_evfinalize回调
#define EV_CLOSURE_EVENT_FINALIZE 5
/** A finalizing event that should get freed after. Uses the evcb_evfinalize
 * callback. */
// 结束事件之后应该释放，使用evcb_evfinalize回调
#define EV_CLOSURE_EVENT_FINALIZE_FREE 6
/** @} */

/** Structure to define the backend of a given event_base. */
// 表示IO多路复用的相关信息，名字以及支持的方法
struct eventop {
	/** The name of this backend. */
    // 后台方法名字，即epoll，select，poll等
	const char *name;
	/** Function to set up an event_base to use this backend.  It should
	 * create a new structure holding whatever information is needed to
	 * run the backend, and return it.  The returned pointer will get
	 * stored by event_init into the event_base.evbase field.  On failure,
	 * this function should return NULL. */
    // 配置libevent句柄event_base使用当前后台方法；他应该创建新的数据结构，
    // 隐藏了后台方法运行所需的信息，然后返回这些信息的结构体，为了支持多种
    // 结构体，因此返回void*；返回的指针将保存在event_base.evbase中；如果失败，
    // 将返回NULL
	void *(*init)(struct event_base *);
	/** Enable reading/writing on a given fd or signal.  'events' will be
	 * the events that we're trying to enable: one or more of EV_READ,
	 * EV_WRITE, EV_SIGNAL, and EV_ET.  'old' will be those events that
	 * were enabled on this fd previously.  'fdinfo' will be a structure
	 * associated with the fd by the evmap; its size is defined by the
	 * fdinfo field below.  It will be set to 0 the first time the fd is
	 * added.  The function should return 0 on success and -1 on error.
	 */
    // 使给定的文件描述符或者信号变得可读或者可写。’events’将是我们尝试添加的
    // 事件类型：一个或者更多的EV_READ,EV_WRITE,EV_SIGNAL,EV_ET。’old’是这些事件
    // 先前的事件类型；’fdinfo’将是fd在evmap中的辅助结构体信息，它的大小由下面的
    // fdinfo_len给出。fd第一次添加时将设置为0.成功则返回0，失败则返回－1
	int (*add)(struct event_base *, evutil_socket_t fd, short old, short events, void *fdinfo);
	/** As "add", except 'events' contains the events we mean to disable. */
    // 删除事件
	int (*del)(struct event_base *, evutil_socket_t fd, short old, short events, void *fdinfo);
	/** Function to implement the core of an event loop.  It must see which
	    added events are ready, and cause event_active to be called for each
	    active event (usually via event_io_active or such).  It should
	    return 0 on success and -1 on error.
	 */
    // event_loop实现的核心代码。他必须察觉哪些添加的事件已经准备好，然后触发每个
    // 活跃事件都被调用（通常是通过event_io_active或者类似这样）。成功返回0，失败则－1
	int (*dispatch)(struct event_base *, struct timeval *);
	/** Function to clean up and free our data from the event_base. */
    // 清除event_base并释放数据
	void (*dealloc)(struct event_base *);
	/** Flag: set if we need to reinitialize the event base after we fork.
	 */
    // 在执行fork之后是否需要重新初始化的标识位
	int need_reinit;
	/** Bit-array of supported event_method_features that this backend can
	 * provide. */
    // 后台方法可以提供的特征
	enum event_method_feature features;
	/** Length of the extra information we should record for each fd that
	    has one or more active events.  This information is recorded
	    as part of the evmap entry for each fd, and passed as an argument
	    to the add and del functions above.
	 */
    // 应该为每个文件描述符保留的额外信息长度，额外信息可能包括一个或者多个
    // 活跃事件。这个信息是存储在每个文件描述符的evmap中，然后通过参数传递
    // 到上面的add和del函数中
	size_t fdinfo_len;
};

#ifdef _WIN32
/* If we're on win32, then file descriptors are not nice low densely packed
   integers.  Instead, they are pointer-like windows handles, and we want to
   use a hashtable instead of an array to map fds to events.
*/
#define EVMAP_USE_HT
#endif

/* #define HT_CACHE_HASH_VALS */

#ifdef EVMAP_USE_HT
#define HT_NO_CACHE_HASH_VALUES
#include "ht-internal.h"
struct event_map_entry;
HT_HEAD(event_io_map, event_map_entry);
#else
#define event_io_map event_signal_map
#endif

/* Used to map signal numbers to a list of events.  If EVMAP_USE_HT is not
   defined, this structure is also used as event_io_map, which maps fds to a
   list of events.
*/
// 用来存储信号数字和一系列事件之间的映射。
// struct event_io_map和struct event_signal_map一致，event_io_map是将fds和事件映射到一块
struct event_signal_map {
	/* An array of evmap_io * or of evmap_signal *; empty entries are
	 * set to NULL. */
    // 二级指针，元素是evmap_signal*数组，而evmap_signal是一个event的队列
    // 如： entries[fd]: 存储的是fd对应的一系列事件
    void **entries;
	/* The number of entries available in entries */
    // 元素个数
    int nentries;
};

/* A list of events waiting on a given 'common' timeout value.  Ordinarily,
 * events waiting for a timeout wait on a minheap.  Sometimes, however, a
 * queue can be faster.
 **/
// 公用超时队列，处于同一个公用超时队列中的所有事件具有相同的超时控制
struct common_timeout_list {
	/* List of events currently waiting in the queue. */
    // 超时event队列。将所有具有相同超时时长的超时event放到一个队列里面
	struct event_list events;
	/* 'magic' timeval used to indicate the duration of events in this
	 * queue. */
    // 超时时长
	struct timeval duration;
	/* Event that triggers whenever one of the events in the queue is
	 * ready to activate */
    // 具有相同超时时长的超时event代表
	struct event timeout_event;
	/* The event_base that this timeout list is part of */
	struct event_base *base;
};

/** Mask used to get the real tv_usec value from a common timeout. */
#define COMMON_TIMEOUT_MICROSECONDS_MASK       0x000fffff

struct event_change;

/* List of 'changes' since the last call to eventop.dispatch.  Only maintained
 * if the backend is using changesets. */
// 列举自从上一次eventop.dispatch调用之后的改变列表。
// 只有在后台使用改变集合时才会维护这个列表，否则不维护？
struct event_changelist {
	struct event_change *changes;
    // changes 的总个数
	int n_changes;
	int changes_size;
};

#ifndef EVENT__DISABLE_DEBUG_MODE
/* Global internal flag: set to one if debug mode is on. */
extern int event_debug_mode_on_;
#define EVENT_DEBUG_MODE_IS_ON() (event_debug_mode_on_)
#else
#define EVENT_DEBUG_MODE_IS_ON() (0)
#endif

TAILQ_HEAD(evcallback_list, event_callback);

/* Sets up an event for processing once */
// 设置一次处理事件
struct event_once {
    // 一次处理事件的链表
	LIST_ENTRY(event_once) next_once;
	struct event ev;

	void (*cb)(evutil_socket_t, short, void *);
	void *arg;
};

// libevent中基于Reactor模式的事件处理框架对应event_base，在event在完成创建后，
// 需要向event_base注册事件，监控事件的当前状态，当事件状态为激活状(EV_ACTIVE)时，调用回调函数执行
struct event_base {
	/** Function pointers and other data to describe this event_base's
	 * backend. */
    // I/O多路复用机制的封装,静态全局数组变量eventops[]数组中一项，
    // 决定了该event_base使用哪种I/O多路复用技术
	const struct eventop *evsel;
	/** Pointer to backend-specific data. */
    // 指向后台特定的数据，是由evsel->init返回的句柄
    // I/O多路复用机制的一个实例，void出于兼容性考虑
	void *evbase;

	/** List of changes to tell backend about at next dispatch.  Only used
	 * by the O(1) backends. */
    // 告诉后台方法下一次调度的变化列表
	struct event_changelist changelist;

	/** Function pointers used to describe the backend that this event_base
	 * uses for signals */
    // 用于描述当前event_base用于信号的后台方法
	const struct eventop *evsigsel;
	/** Data to implement the common signal handelr code. */
    // 存储信号处理的信息
	struct evsig_info sig;

	/** Number of virtual events */
    // 虚拟事件的数量
	int virtual_event_count;
	/** Maximum number of virtual events active */
    // 虚拟事件的最大数量
	int virtual_event_count_max;
	/** Number of total events added to this event_base */
    // 添加到event_base上事件总数
	int event_count;
	/** Maximum number of total events added to this event_base */
    // 添加到event_base上的最大个数
	int event_count_max;
	/** Number of total events active in this event_base */
    // 当前event_base中活跃事件的个数
	int event_count_active;
	/** Maximum number of total events active in this event_base */
    // 当前event_base中活跃事件的最大个数
	int event_count_active_max;

	/** Set if we should terminate the loop once we're done processing
	 * events. */
    // 一旦我们完成处理事件了，如果我们应该终止loop，可以设置这个
	int event_gotterm;
	/** Set if we should terminate the loop immediately */
    // 如果需要中止loop立即退出，可以设置这个变量
	int event_break;
	/** Set if we should start a new instance of the loop immediately. */
    // 如果立即启动一个新的事件循环，可以设置这个
	int event_continue;

	/** The currently running priority of events */
    // 当前运行事件的优先级
	int event_running_priority;

	/** Set if we're running the event_base_loop function, to prevent
	 * reentrant invocation. */
    // 是否正在进行事件循环,防止event_base_loop重入的
	int running_loop;

	/** Set to the number of deferred_cbs we've made 'active' in the
	 * loop.  This is a hack to prevent starvation; it would be smarter
	 * to just use event_config_set_max_dispatch_interval's max_callbacks
	 * feature */
    // 设置已经在loop中设置为’active’的deferred_cbs的个数，这是为了避免
    // 饥饿的hack方法；只需要使用event_config_set_max_dispatch_interval’s的
    // max_callbacks特征就可以变的更智能
	int n_deferreds_queued;

	/* Active event management. */
    // 活跃事件管理
	/** An array of nactivequeues queues for active event_callbacks (ones
	 * that have triggered, and whose callbacks need to be called).  Low
	 * priority numbers are more important, and stall higher ones.
	 */
    // 存储激活事件的event_callbacks的链表，这些event_callbacks都需要调用；
    // 是一个指针数组，activequeues[priority]指向优先级为priority的链表
	struct evcallback_list *activequeues;
	/** The length of the activequeues array */
    // 活跃事件的个数,即activequeues数组元素个数(每个元素是队列)
	int nactivequeues;
	/** A list of event_callbacks that should become active the next time
	 * we process events, but not this time. */
    // 下一次会变成激活状态的回调函数的列表，但是当前这次不会调用
	struct evcallback_list active_later_queue;

	/* common timeout logic */
    // 公用超时逻辑，每个公用超时队列要取出一个代表插入到小根堆

	/** An array of common_timeout_list* for all of the common timeout
	 * values we know. */
    // 公用超时事件列表，因为可以有多个不同时长的超时event,所以为二级指针，
    // 每个元素都是具有同样超时时间事件的列表
	struct common_timeout_list **common_timeout_queues;
	/** The number of entries used in common_timeout_queues */
    // 公用超时队列中的项目个数
	int n_common_timeouts;
	/** The total size of common_timeout_queues. */
    // 公用超时队列的总个数
	int n_common_timeouts_allocated;

	/** Mapping from file descriptors to enabled (added) events */
    // 文件描述符和事件之间的映射表
	struct event_io_map io;

	/** Mapping from signal numbers to enabled (added) events. */
    // 信号数字和事件之间映射表
	struct event_signal_map sigmap;

	/** Priority queue of events with timeouts. */
    // 管理定时事件的最小堆
	struct min_heap timeheap;

	/** Stored timeval: used to avoid calling gettimeofday/clock_gettime
	 * too often. */
    // 缓存的时间：用来避免频繁调用gettimeofday/clock_gettime
	struct timeval tv_cache;

    // monotonic格式的时间(boot启动后到现在的时间)
	struct evutil_monotonic_timer monotonic_timer;

	/** Difference between internal time (maybe from clock_gettime) and
	 * gettimeofday. */
    // 内部缓存的时间tv_cache和直接调用gettimeofday时间的差值
	struct timeval tv_clock_diff;
	/** Second in which we last updated tv_clock_diff, in monotonic time. */
    // 上一次更新tv_clock_diff时对应的当时的时间
	time_t last_updated_clock_diff;

#ifndef EVENT__DISABLE_THREAD_SUPPORT
	/* threading support */
    // 线程id,锁，条件变量，阻塞的线程个数
	/** The thread currently running the event_loop for this base */
	unsigned long th_owner_id;
	/** A lock to prevent conflicting accesses to this event_base */
	void *th_base_lock;
	/** A condition that gets signalled when we're done processing an
	 * event with waiters on it. */
	void *current_event_cond;
	/** Number of threads blocking on current_event_cond. */
	int current_event_waiters;
#endif
	/** The event whose callback is executing right now */
    // 当前执行的回调函数
	struct event_callback *current_event;

#ifdef _WIN32
	/** IOCP support structure, if IOCP is enabled. */
	struct event_iocp_port *iocp;
#endif

	/** Flags that this base was configured with */
    // event_base配置的特征值
	enum event_base_config_flag flags;

    // 最大调度时间间隔
	struct timeval max_dispatch_time;
    // 最大调度的回调函数个数
	int max_dispatch_callbacks;
    // 如果优先级 < limit_after_prio，即当事件优先级高于limit_after_prio时，是不需要查看新事件的；
    // 如果优先级 >＝ limit_after_prio，即当事件优先级不高于limit_after_prio时，是需要根据maxcb以及end_time检查新事件；
	int limit_callbacks_after_prio;

	/* Notify main thread to wake up break, etc. */
	/** True if the base already has a pending notify, and we don't need
	 * to add any more. */
    // 如果event_base已经有关于未决事件的通知，那么我们就不需要再次添加了
    // 表示即子线程已经通知了，但主线程还没处理这个通知
	int is_notify_pending;
	/** A socketpair used by some th_notify functions to wake up the main
	 * thread. */
    // 某些th_notify函数用于唤醒主线程的socketpair，0读1写
	evutil_socket_t th_notify_fd[2];
	/** An event used by some th_notify functions to wake up the main
	 * thread. */
    // 用于th_notify函数唤醒主线程的事件
    // 用于监听th_notify_fd的读端
	struct event th_notify;
	/** A function used to wake up the main thread from another thread. */
    // 用于从其他线程唤醒主线程的函数,evthread_make_base_notifiable_nolock_()中指定
	int (*th_notify_fn)(struct event_base *base);

	/** Saved seed for weak random number generator. Some backends use
	 * this to produce fairness among sockets. Protected by th_base_lock. */
    // 保存弱随机数产生器的种子。某些后台方法会使用这个种子来公平的选择sockets
	struct evutil_weakrand_state weakrand_seed;

	/** List of event_onces that have not yet fired. */
    // 尚未触发的event_once列表
	LIST_HEAD(once_event_list, event_once) once_events;

};

// 表示要屏蔽的后台方法
struct event_config_entry {
    // 下一个避免使用的后台方法名
	TAILQ_ENTRY(event_config_entry) next;

    // 避免使用的后台方法名
	const char *avoid_method;
};

/** Internal structure: describes the configuration we want for an event_base
 * that we're about to allocate. */
// 内部结构体，用于描述对event_base进行配置的配置信息
struct event_config {
    // 避免使用的后台方法列表
	TAILQ_HEAD(event_configq, event_config_entry) entries;

    // cpu个数，这个仅仅是对event_base的建议，不是强制的
	int n_cpus_hint;
    // 如果不执行以下检查，默认情况下，event_base会按照当前优先级队列的顺序，一直将本优先级
    // 队列的事件执行完毕之后才会检查新事件，这样的好处是吞吐量大，但是在低优先级队列比较长时，
    // 会导致某些高优先级一直在等待执行，无法抢占cpu
    // event_base在event_loop中两次检查新事件之间执行回调函数的时间间隔
    // 需要每次执行完回调函数之后都进行检查
	struct timeval max_dispatch_interval;
    // event_base在event_loop中两次检查新事件之间执行调度回调函数的最大个数
    // 需要每次执行完回调函数之后都进行检查
	int max_dispatch_callbacks;
    // 用于启动上面两个检查的开关，如果＝0，则每次执行完毕回调函数之后都强制进行检查；
    // 如果＝n，则只有在执行完毕>=n的优先级事件之后才会强制执行上述检查
	int limit_callbacks_after_prio;
    // event_base后台方法需要的特征
	enum event_method_feature require_features;
    // event_base配置的特征值
	enum event_base_config_flag flags;
};

/* Internal use only: Functions that might be missing from <sys/queue.h> */
#ifndef TAILQ_FIRST
#define	TAILQ_FIRST(head)		((head)->tqh_first)
#endif
#ifndef TAILQ_END
#define	TAILQ_END(head)			NULL
#endif
#ifndef TAILQ_NEXT
#define	TAILQ_NEXT(elm, field)		((elm)->field.tqe_next)
#endif

#ifndef TAILQ_FOREACH
#define TAILQ_FOREACH(var, head, field)					\
	for ((var) = TAILQ_FIRST(head);					\
	     (var) != TAILQ_END(head);					\
	     (var) = TAILQ_NEXT(var, field))
#endif

#ifndef TAILQ_INSERT_BEFORE
#define	TAILQ_INSERT_BEFORE(listelm, elm, field) do {			\
	(elm)->field.tqe_prev = (listelm)->field.tqe_prev;		\
	(elm)->field.tqe_next = (listelm);				\
	*(listelm)->field.tqe_prev = (elm);				\
	(listelm)->field.tqe_prev = &(elm)->field.tqe_next;		\
} while (0)
#endif

#define N_ACTIVE_CALLBACKS(base)					\
	((base)->event_count_active)

int evsig_set_handler_(struct event_base *base, int evsignal,
			  void (*fn)(int));
int evsig_restore_handler_(struct event_base *base, int evsignal);

int event_add_nolock_(struct event *ev,
    const struct timeval *tv, int tv_is_absolute);
/** Argument for event_del_nolock_. Tells event_del not to block on the event
 * if it's running in another thread. */
#define EVENT_DEL_NOBLOCK 0
/** Argument for event_del_nolock_. Tells event_del to block on the event
 * if it's running in another thread, regardless of its value for EV_FINALIZE
 */
#define EVENT_DEL_BLOCK 1
/** Argument for event_del_nolock_. Tells event_del to block on the event
 * if it is running in another thread and it doesn't have EV_FINALIZE set.
 */
#define EVENT_DEL_AUTOBLOCK 2
/** Argument for event_del_nolock_. Tells event_del to procede even if the
 * event is set up for finalization rather for regular use.*/
#define EVENT_DEL_EVEN_IF_FINALIZING 3
int event_del_nolock_(struct event *ev, int blocking);
int event_remove_timer_nolock_(struct event *ev);

void event_active_nolock_(struct event *ev, int res, short count);
int event_callback_activate_(struct event_base *, struct event_callback *);
int event_callback_activate_nolock_(struct event_base *, struct event_callback *);
int event_callback_cancel_(struct event_base *base,
    struct event_callback *evcb);

void event_callback_finalize_nolock_(struct event_base *base, unsigned flags, struct event_callback *evcb, void (*cb)(struct event_callback *, void *));
void event_callback_finalize_(struct event_base *base, unsigned flags, struct event_callback *evcb, void (*cb)(struct event_callback *, void *));
int event_callback_finalize_many_(struct event_base *base, int n_cbs, struct event_callback **evcb, void (*cb)(struct event_callback *, void *));


void event_active_later_(struct event *ev, int res);
void event_active_later_nolock_(struct event *ev, int res);
int event_callback_activate_later_nolock_(struct event_base *base,
    struct event_callback *evcb);
int event_callback_cancel_nolock_(struct event_base *base,
    struct event_callback *evcb, int even_if_finalizing);
void event_callback_init_(struct event_base *base,
    struct event_callback *cb);

/* FIXME document. */
void event_base_add_virtual_(struct event_base *base);
void event_base_del_virtual_(struct event_base *base);

/** For debugging: unless assertions are disabled, verify the referential
    integrity of the internal data structures of 'base'.  This operation can
    be expensive.

    Returns on success; aborts on failure.
*/
void event_base_assert_ok_(struct event_base *base);
void event_base_assert_ok_nolock_(struct event_base *base);


/* Helper function: Call 'fn' exactly once every inserted or active event in
 * the event_base 'base'.
 *
 * If fn returns 0, continue on to the next event. Otherwise, return the same
 * value that fn returned.
 *
 * Requires that 'base' be locked.
 */
int event_base_foreach_event_nolock_(struct event_base *base,
    event_base_foreach_event_cb cb, void *arg);

/* Cleanup function to reset debug mode during shutdown.
 *
 * Calling this function doesn't mean it'll be possible to re-enable
 * debug mode if any events were added.
 */
void event_disable_debug_mode(void);

#ifdef __cplusplus
}
#endif

#endif /* EVENT_INTERNAL_H_INCLUDED_ */
