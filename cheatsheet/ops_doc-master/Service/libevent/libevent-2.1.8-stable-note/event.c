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
#include "event2/event-config.h"
#include "evconfig-private.h"

#ifdef _WIN32
#include <winsock2.h>
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#undef WIN32_LEAN_AND_MEAN
#endif
#include <sys/types.h>
#if !defined(_WIN32) && defined(EVENT__HAVE_SYS_TIME_H)
#include <sys/time.h>
#endif
#include <sys/queue.h>
#ifdef EVENT__HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#ifdef EVENT__HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <ctype.h>
#include <errno.h>
#include <signal.h>
#include <string.h>
#include <time.h>
#include <limits.h>

#include "event2/event.h"
#include "event2/event_struct.h"
#include "event2/event_compat.h"
#include "event-internal.h"
#include "defer-internal.h"
#include "evthread-internal.h"
#include "event2/thread.h"
#include "event2/util.h"
#include "log-internal.h"
#include "evmap-internal.h"
#include "iocp-internal.h"
#include "changelist-internal.h"
#define HT_NO_CACHE_HASH_VALUES
#include "ht-internal.h"
#include "util-internal.h"


#ifdef EVENT__HAVE_WORKING_KQUEUE
#include "kqueue-internal.h"
#endif

#ifdef EVENT__HAVE_EVENT_PORTS
extern const struct eventop evportops;
#endif
#ifdef EVENT__HAVE_SELECT
extern const struct eventop selectops;
#endif
#ifdef EVENT__HAVE_POLL
extern const struct eventop pollops;
#endif
#ifdef EVENT__HAVE_EPOLL
extern const struct eventop epollops;
#endif
#ifdef EVENT__HAVE_WORKING_KQUEUE
extern const struct eventop kqops;
#endif
#ifdef EVENT__HAVE_DEVPOLL
extern const struct eventop devpollops;
#endif
#ifdef _WIN32
extern const struct eventop win32ops;
#endif

/* Array of backends in order of preference. */
// IO复用方法的全局静态数组,按优先顺序排列
static const struct eventop *eventops[] = {
#ifdef EVENT__HAVE_EVENT_PORTS
    &evportops,
#endif
#ifdef EVENT__HAVE_WORKING_KQUEUE
    &kqops,
#endif
#ifdef EVENT__HAVE_EPOLL
    &epollops,
#endif
#ifdef EVENT__HAVE_DEVPOLL
    &devpollops,
#endif
#ifdef EVENT__HAVE_POLL
    &pollops,
#endif
#ifdef EVENT__HAVE_SELECT
    &selectops,
#endif
#ifdef _WIN32
    &win32ops,
#endif
    NULL
};

/* Global state; deprecated */
// “当前”event_base 是一个由所有线程共享的全局设置
struct event_base *event_global_current_base_ = NULL;
#define current_base event_global_current_base_

/* Global state */

static void *event_self_cbarg_ptr_ = NULL;

/* Prototypes */
static void	event_queue_insert_active(struct event_base *, struct event_callback *);
static void	event_queue_insert_active_later(struct event_base *, struct event_callback *);
static void	event_queue_insert_timeout(struct event_base *, struct event *);
static void	event_queue_insert_inserted(struct event_base *, struct event *);
static void	event_queue_remove_active(struct event_base *, struct event_callback *);
static void	event_queue_remove_active_later(struct event_base *, struct event_callback *);
static void	event_queue_remove_timeout(struct event_base *, struct event *);
static void	event_queue_remove_inserted(struct event_base *, struct event *);
static void event_queue_make_later_events_active(struct event_base *base);

static int evthread_make_base_notifiable_nolock_(struct event_base *base);
static int event_del_(struct event *ev, int blocking);

#ifdef USE_REINSERT_TIMEOUT
/* This code seems buggy; only turn it on if we find out what the trouble is. */
static void	event_queue_reinsert_timeout(struct event_base *,struct event *, int was_common, int is_common, int old_timeout_idx);
#endif

static int	event_haveevents(struct event_base *);

static int	event_process_active(struct event_base *);

static int	timeout_next(struct event_base *, struct timeval **);
static void	timeout_process(struct event_base *);

static inline void	event_signal_closure(struct event_base *, struct event *ev);
static inline void	event_persist_closure(struct event_base *, struct event *ev);

static int	evthread_notify_base(struct event_base *base);

static void insert_common_timeout_inorder(struct common_timeout_list *ctl,
                                          struct event *ev);

#ifndef EVENT__DISABLE_DEBUG_MODE
/* These functions implement a hashtable of which 'struct event *' structures
 * have been setup or added.  We don't want to trust the content of the struct
 * event itself, since we're trying to work through cases where an event gets
 * clobbered or freed.  Instead, we keep a hashtable indexed by the pointer.
 */

struct event_debug_entry {
    HT_ENTRY(event_debug_entry) node;
    const struct event *ptr;
    unsigned added : 1;
};

static inline unsigned
hash_debug_entry(const struct event_debug_entry *e)
{
    /* We need to do this silliness to convince compilers that we
     * honestly mean to cast e->ptr to an integer, and discard any
     * part of it that doesn't fit in an unsigned.
     */
    unsigned u = (unsigned) ((ev_uintptr_t) e->ptr);
    /* Our hashtable implementation is pretty sensitive to low bits,
     * and every struct event is over 64 bytes in size, so we can
     * just say >>6. */
    return (u >> 6);
}

static inline int
eq_debug_entry(const struct event_debug_entry *a,
               const struct event_debug_entry *b)
{
    return a->ptr == b->ptr;
}

int event_debug_mode_on_ = 0;


#if !defined(EVENT__DISABLE_THREAD_SUPPORT) && !defined(EVENT__DISABLE_DEBUG_MODE)
/**
 * @brief debug mode variable which is set for any function/structure that needs
 *        to be shared across threads (if thread support is enabled).
 *
 *        When and if evthreads are initialized, this variable will be evaluated,
 *        and if set to something other than zero, this means the evthread setup
 *        functions were called out of order.
 *
 *        See: "Locks and threading" in the documentation.
 */
int event_debug_created_threadable_ctx_ = 0;
#endif

/* Set if it's too late to enable event_debug_mode. */
static int event_debug_mode_too_late = 0;
#ifndef EVENT__DISABLE_THREAD_SUPPORT
static void *event_debug_map_lock_ = NULL;
#endif
static HT_HEAD(event_debug_map, event_debug_entry) global_debug_map =
        HT_INITIALIZER();

HT_PROTOTYPE(event_debug_map, event_debug_entry, node, hash_debug_entry,
             eq_debug_entry)
HT_GENERATE(event_debug_map, event_debug_entry, node, hash_debug_entry,
            eq_debug_entry, 0.5, mm_malloc, mm_realloc, mm_free)

/* Macro: record that ev is now setup (that is, ready for an add) */
#define event_debug_note_setup_(ev) do {				\
    if (event_debug_mode_on_) {					\
    struct event_debug_entry *dent,find;			\
    find.ptr = (ev);					\
    EVLOCK_LOCK(event_debug_map_lock_, 0);			\
    dent = HT_FIND(event_debug_map, &global_debug_map, &find); \
    if (dent) {						\
    dent->added = 0;				\
    } else {						\
    dent = mm_malloc(sizeof(*dent));		\
    if (!dent)					\
    event_err(1,				\
    "Out of memory in debugging code");	\
    dent->ptr = (ev);				\
    dent->added = 0;				\
    HT_INSERT(event_debug_map, &global_debug_map, dent); \
    }							\
    EVLOCK_UNLOCK(event_debug_map_lock_, 0);		\
    }								\
    event_debug_mode_too_late = 1;					\
    } while (0)
/* Macro: record that ev is no longer setup */
#define event_debug_note_teardown_(ev) do {				\
    if (event_debug_mode_on_) {					\
    struct event_debug_entry *dent,find;			\
    find.ptr = (ev);					\
    EVLOCK_LOCK(event_debug_map_lock_, 0);			\
    dent = HT_REMOVE(event_debug_map, &global_debug_map, &find); \
    if (dent)						\
    mm_free(dent);					\
    EVLOCK_UNLOCK(event_debug_map_lock_, 0);		\
    }								\
    event_debug_mode_too_late = 1;					\
    } while (0)
/* Macro: record that ev is now added */
#define event_debug_note_add_(ev)	do {				\
    if (event_debug_mode_on_) {					\
    struct event_debug_entry *dent,find;			\
    find.ptr = (ev);					\
    EVLOCK_LOCK(event_debug_map_lock_, 0);			\
    dent = HT_FIND(event_debug_map, &global_debug_map, &find); \
    if (dent) {						\
    dent->added = 1;				\
    } else {						\
    event_errx(EVENT_ERR_ABORT_,			\
    "%s: noting an add on a non-setup event %p" \
    " (events: 0x%x, fd: "EV_SOCK_FMT		\
    ", flags: 0x%x)",				\
    __func__, (ev), (ev)->ev_events,		\
    EV_SOCK_ARG((ev)->ev_fd), (ev)->ev_flags);	\
    }							\
    EVLOCK_UNLOCK(event_debug_map_lock_, 0);		\
    }								\
    event_debug_mode_too_late = 1;					\
    } while (0)
/* Macro: record that ev is no longer added */
#define event_debug_note_del_(ev) do {					\
    if (event_debug_mode_on_) {					\
    struct event_debug_entry *dent,find;			\
    find.ptr = (ev);					\
    EVLOCK_LOCK(event_debug_map_lock_, 0);			\
    dent = HT_FIND(event_debug_map, &global_debug_map, &find); \
    if (dent) {						\
    dent->added = 0;				\
    } else {						\
    event_errx(EVENT_ERR_ABORT_,			\
    "%s: noting a del on a non-setup event %p"	\
    " (events: 0x%x, fd: "EV_SOCK_FMT		\
    ", flags: 0x%x)",				\
    __func__, (ev), (ev)->ev_events,		\
    EV_SOCK_ARG((ev)->ev_fd), (ev)->ev_flags);	\
    }							\
    EVLOCK_UNLOCK(event_debug_map_lock_, 0);		\
    }								\
    event_debug_mode_too_late = 1;					\
    } while (0)
/* Macro: assert that ev is setup (i.e., okay to add or inspect) */
#define event_debug_assert_is_setup_(ev) do {				\
    if (event_debug_mode_on_) {					\
    struct event_debug_entry *dent,find;			\
    find.ptr = (ev);					\
    EVLOCK_LOCK(event_debug_map_lock_, 0);			\
    dent = HT_FIND(event_debug_map, &global_debug_map, &find); \
    if (!dent) {						\
    event_errx(EVENT_ERR_ABORT_,			\
    "%s called on a non-initialized event %p"	\
    " (events: 0x%x, fd: "EV_SOCK_FMT\
    ", flags: 0x%x)",				\
    __func__, (ev), (ev)->ev_events,		\
    EV_SOCK_ARG((ev)->ev_fd), (ev)->ev_flags);	\
    }							\
    EVLOCK_UNLOCK(event_debug_map_lock_, 0);		\
    }								\
    } while (0)
/* Macro: assert that ev is not added (i.e., okay to tear down or set
 * up again) */
#define event_debug_assert_not_added_(ev) do {				\
    if (event_debug_mode_on_) {					\
    struct event_debug_entry *dent,find;			\
    find.ptr = (ev);					\
    EVLOCK_LOCK(event_debug_map_lock_, 0);			\
    dent = HT_FIND(event_debug_map, &global_debug_map, &find); \
    if (dent && dent->added) {				\
    event_errx(EVENT_ERR_ABORT_,			\
    "%s called on an already added event %p"	\
    " (events: 0x%x, fd: "EV_SOCK_FMT", "	\
    "flags: 0x%x)",				\
    __func__, (ev), (ev)->ev_events,		\
    EV_SOCK_ARG((ev)->ev_fd), (ev)->ev_flags);	\
    }							\
    EVLOCK_UNLOCK(event_debug_map_lock_, 0);		\
    }								\
    } while (0)
#else
#define event_debug_note_setup_(ev) \
    ((void)0)
#define event_debug_note_teardown_(ev) \
    ((void)0)
#define event_debug_note_add_(ev) \
    ((void)0)
#define event_debug_note_del_(ev) \
    ((void)0)
#define event_debug_assert_is_setup_(ev) \
    ((void)0)
#define event_debug_assert_not_added_(ev) \
    ((void)0)
#endif

#define EVENT_BASE_ASSERT_LOCKED(base)		\
    EVLOCK_ASSERT_LOCKED((base)->th_base_lock)

/* How often (in seconds) do we check for changes in wall clock time relative
 * to monotonic time?  Set this to -1 for 'never.' */
#define CLOCK_SYNC_INTERVAL 5

/** Set 'tp' to the current time according to 'base'.  We must hold the lock
 * on 'base'.  If there is a cached time, return it.  Otherwise, use
 * clock_gettime or gettimeofday as appropriate to find out the right time.
 * Return 0 on success, -1 on failure.
 */
// 此函数主要用来获取当前event_base中缓存的时间存到tp，
// 如果base中有缓存的时间，则将缓存的时间赋给tp，然后返回即可；
// 如果base中没有缓存的时间，则使用clock_gettime获取当前系统的monotonic时间；
// 否则根据上次更新系统时间的时间点、更新间隔、以及当前使用clock_gettime等函数获取当前的系统时间
// 查看是否需要更新base->tv_clock_diff以及base->last_updated_clock_diff
static int
gettime(struct event_base *base, struct timeval *tp)
{
    EVENT_BASE_ASSERT_LOCKED(base);

    // 首先查看base中是否有缓存的时间，如果有，直接使用缓存时间，然后返回即可
    if (base->tv_cache.tv_sec) {
        *tp = base->tv_cache;
        return (0);
    }

    // 使用monotonic_timer获取当前时间，
    // CLOCK_MONOTONIC_COARSE 或 CLOCK_MONOTONIC
    // 默认情况下是 CLOCK_MONOTONIC模式
    if (evutil_gettime_monotonic_(&base->monotonic_timer, tp) == -1) {
        return -1;
    }

    // 查看是否需要更新缓存的时间?
    if (base->last_updated_clock_diff + CLOCK_SYNC_INTERVAL
            < tp->tv_sec) {
        struct timeval tv;
        // 使用gettimeofday获取当前系统real时间
        evutil_gettimeofday(&tv,NULL);
        // 将当前系统real时间和monotonic时间做差，存到base中
        evutil_timersub(&tv, tp, &base->tv_clock_diff);
        // 保存当前更新的时间点
        base->last_updated_clock_diff = tp->tv_sec;
    }

    return 0;
}

// 获取到的时间为开始执行此轮事件回调函数的时间
// 成功返回 0 失败返回负数
int
event_base_gettimeofday_cached(struct event_base *base, struct timeval *tv)
{
    int r;
    if (!base) {
        base = current_base;
        if (!current_base)
            return evutil_gettimeofday(tv, NULL);
    }

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    if (base->tv_cache.tv_sec == 0) {
        r = evutil_gettimeofday(tv, NULL);
    } else {
        evutil_timeradd(&base->tv_cache, &base->tv_clock_diff, tv);
        r = 0;
    }
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return r;
}

/** Make 'base' have no current cached time. */
static inline void
clear_time_cache(struct event_base *base)
{
    base->tv_cache.tv_sec = 0;
}

/** Replace the cached time in 'base' with the current time. */
// 更新base的缓存时间
static inline void
update_time_cache(struct event_base *base)
{
    base->tv_cache.tv_sec = 0;
    if (!(base->flags & EVENT_BASE_FLAG_NO_CACHE_TIME))
        gettime(base, &base->tv_cache);
}

int
event_base_update_cache_time(struct event_base *base)
{

    if (!base) {
        base = current_base;
        if (!current_base)
            return -1;
    }

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    if (base->running_loop)
        update_time_cache(base);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return 0;
}

static inline struct event *
        event_callback_to_event(struct event_callback *evcb)
{
    EVUTIL_ASSERT((evcb->evcb_flags & EVLIST_INIT));
    return EVUTIL_UPCAST(evcb, struct event, ev_evcallback);
}

// 获取event对应的回调函数
static inline struct event_callback *
        event_to_event_callback(struct event *ev)
{
    return &ev->ev_evcallback;
}

// 初始化event_base结构体，赋值全局current_base
struct event_base *
        event_init(void)
{
    struct event_base *base = event_base_new_with_config(NULL);

    if (base == NULL) {
        event_errx(1, "%s: Unable to construct event_base", __func__);
        return NULL;
    }

    current_base = base;

    return (base);
}

// 创建默认的event_base
struct event_base *
        event_base_new(void)
{
    struct event_base *base = NULL;
    // 调用event_config_new函数创建默认的struct event_config对象
    struct event_config *cfg = event_config_new();
    if (cfg) {
        // 使用配置信息创建event_base
        base = event_base_new_with_config(cfg);
        // 释放配置信息对象struct event_config
        event_config_free(cfg);
    }
    return base;
}

/** Return true iff 'method' is the name of a method that 'cfg' tells us to
 * avoid. */
// 查看cfg中是否有被屏蔽的后台方法method
static int
event_config_is_avoided_method(const struct event_config *cfg,
                               const char *method)
{
    struct event_config_entry *entry;

    TAILQ_FOREACH(entry, &cfg->entries, next) {
        if (entry->avoid_method != NULL &&
                strcmp(entry->avoid_method, method) == 0)
            return (1);
    }

    return (0);
}

/** Return true iff 'method' is disabled according to the environment. */
// 检查环境变量是否支持name
static int
event_is_method_disabled(const char *name)
{
    char environment[64];
    int i;

    evutil_snprintf(environment, sizeof(environment), "EVENT_NO%s", name);
    for (i = 8; environment[i] != '\0'; ++i)
        environment[i] = EVUTIL_TOUPPER_(environment[i]);
    /* Note that evutil_getenv_() ignores the environment entirely if
     * we're setuid */
    return (evutil_getenv_(environment) != NULL);
}

// 获取后台方法的工作模式
int
event_base_get_features(const struct event_base *base)
{
    return base->evsel->features;
}

void
event_enable_debug_mode(void)
{
#ifndef EVENT__DISABLE_DEBUG_MODE
    if (event_debug_mode_on_)
        event_errx(1, "%s was called twice!", __func__);
    if (event_debug_mode_too_late)
        event_errx(1, "%s must be called *before* creating any events "
                      "or event_bases",__func__);

    event_debug_mode_on_ = 1;

    HT_INIT(event_debug_map, &global_debug_map);
#endif
}

void
event_disable_debug_mode(void)
{
#ifndef EVENT__DISABLE_DEBUG_MODE
    struct event_debug_entry **ent, *victim;

    EVLOCK_LOCK(event_debug_map_lock_, 0);
    for (ent = HT_START(event_debug_map, &global_debug_map); ent; ) {
        victim = *ent;
        ent = HT_NEXT_RMV(event_debug_map, &global_debug_map, ent);
        mm_free(victim);
    }
    HT_CLEAR(event_debug_map, &global_debug_map);
    EVLOCK_UNLOCK(event_debug_map_lock_ , 0);

    event_debug_mode_on_  = 0;
#endif
}

// 使用配置信息创建event_base
struct event_base *
        event_base_new_with_config(const struct event_config *cfg)
{
    int i;
    struct event_base *base;
    int should_check_environment;

#ifndef EVENT__DISABLE_DEBUG_MODE
    event_debug_mode_too_late = 1;
#endif

    //在堆上分配内存存储event_base，所有字段初始化为0
    if ((base = mm_calloc(1, sizeof(struct event_base))) == NULL) {
        event_warn("%s: calloc", __func__);
        return NULL;
    }

    if (cfg)
        base->flags = cfg->flags;

    // 默认情况下，cfg->flags ＝ EVENT_BASE_FLAG_NOBLOCK，所以是没有设置忽略环境变量，
    // 因此should_check_enviroment ＝ 1，是应该检查环境变量的
    should_check_environment =
            !(cfg && (cfg->flags & EVENT_BASE_FLAG_IGNORE_ENV));

    {
        struct timeval tmp;
        // 如果使用精确时间，则precise_time为1，否则为0
        // 默认配置下，cfg->flags＝EVENT_BASE_FLAG_NOBLOCK，所以precise_time ＝ 0
        int precise_time =
                cfg && (cfg->flags & EVENT_BASE_FLAG_PRECISE_TIMER);
        int flags;
        //如果没有设置使用更精准的时间标志，但是在环境变量中设置使用更精准的时间那就设置标志
        // 意思是，虽然配置结构体struct event_config中没有指定,
        // 但是如果开启检查环境变量的开关，则需要检查是否在编译时打开了使用精确时间的模式。
        // 例如在CMakeList中就有有关开启选项
        if (should_check_environment && !precise_time) {
            precise_time = evutil_getenv_("EVENT_PRECISE_TIMER") != NULL;
            base->flags |= EVENT_BASE_FLAG_PRECISE_TIMER;
        }
        // 根据precise_time的标志信息，确认是否使用MONOT_PRECISE模式
        flags = precise_time ? EV_MONOT_PRECISE : 0;
        evutil_configure_monotonic_time_(&base->monotonic_timer, flags);

        // 获取base当前的时间
        gettime(base, &tmp);
    }

    // 初始化超时时间优先级队列（最小堆）
    min_heap_ctor_(&base->timeheap);

    // 内部信号通知的管道，0读1写
    base->sig.ev_signal_pair[0] = -1;
    base->sig.ev_signal_pair[1] = -1;
    // 内部线程通知的文件描述符，0读1写
    base->th_notify_fd[0] = -1;
    base->th_notify_fd[1] = -1;

    // 初始化下一次激活的队列
    TAILQ_INIT(&base->active_later_queue);

    // 初始化IO事件和文件描述符的映射
    evmap_io_initmap_(&base->io);
    // 初始化信号和文件描述符的映射
    evmap_signal_initmap_(&base->sigmap);
    // 初始化变化事件列表
    event_changelist_init_(&base->changelist);

    // 在没有初始化后台方法之前，后台方法必需的数据信息为空
    base->evbase = NULL;

    // 如果配置信息对象struct event_config存在，则依据配置信息配置
    if (cfg) {
        memcpy(&base->max_dispatch_time,
               &cfg->max_dispatch_interval, sizeof(struct timeval));
        base->limit_callbacks_after_prio =
                cfg->limit_callbacks_after_prio;
    } else {
        // max_dispatch_time.tv_sec＝－1即不进行此项检查
        // limit_callbacks_after_prio=1是指>=1时都需要检查，最高优先级为0，
        // 即除了最高优先级事件执行时不需要检查之外，其他优先级都需要检查
        base->max_dispatch_time.tv_sec = -1;
        base->limit_callbacks_after_prio = 1;
    }
    if (cfg && cfg->max_dispatch_callbacks >= 0) {
        base->max_dispatch_callbacks = cfg->max_dispatch_callbacks;
    } else {
        base->max_dispatch_callbacks = INT_MAX;
    }
    if (base->max_dispatch_callbacks == INT_MAX &&
            base->max_dispatch_time.tv_sec == -1)
        base->limit_callbacks_after_prio = INT_MAX;

    // 遍历静态全局变量eventops，对选择的后台方法进行初始化
    for (i = 0; eventops[i] && !base->evbase; i++) {
        if (cfg != NULL) {
            /* determine if this backend should be avoided */
            // 如果方法已经屏蔽，则跳过去，继续遍历下一个方法
            // 默认情况下，是不屏蔽任何后台方法，除非通过编译选项控制或者使用API屏蔽
            if (event_config_is_avoided_method(cfg,
                                               eventops[i]->name))
                continue;
            // 如果后台方法的工作模式特征和配置的工作模式不同，则跳过去
            if ((eventops[i]->features & cfg->require_features)
                    != cfg->require_features)
                continue;
        }

        /* also obey the environment variables */
        // 如果检查环境变量，并发现OS环境不支持的话，也会跳过去
        if (should_check_environment &&
                event_is_method_disabled(eventops[i]->name))
            continue;

        // 保存后台方法句柄，实际是静态全局变量数组成员
        base->evsel = eventops[i];

        // 调用相应后台方法的初始化函数进行初始化
        base->evbase = base->evsel->init(base);
    }

    // 如果遍历一遍没有发现合适的后台方法，就报错退出，退出前释放资源
    if (base->evbase == NULL) {
        event_warnx("%s: no event mechanism available",
                    __func__);
        base->evsel = NULL;
        event_base_free(base);
        return NULL;
    }

    // 获取环境变量EVENT_SHOW_METHOD，是否打印输出选择的后台方法名字
    if (evutil_getenv_("EVENT_SHOW_METHOD"))
        event_msgx("libevent using: %s", base->evsel->name);

    /* allocate a single active event queue */
    // 分配的优先级队列成员个数为1
    if (event_base_priority_init(base, 1) < 0) {
        event_base_free(base);
        return NULL;
    }

    /* prepare for threading */

#if !defined(EVENT__DISABLE_THREAD_SUPPORT) && !defined(EVENT__DISABLE_DEBUG_MODE)
    event_debug_created_threadable_ctx_ = 1;
#endif

#ifndef EVENT__DISABLE_THREAD_SUPPORT
    // 使能了线程的支持
    if (EVTHREAD_LOCKING_ENABLED() &&
            (!cfg || !(cfg->flags & EVENT_BASE_FLAG_NOLOCK))) {
        int r;
        EVTHREAD_ALLOC_LOCK(base->th_base_lock, 0);
        EVTHREAD_ALLOC_COND(base->current_event_cond);
        // 用于初始化通知
        r = evthread_make_base_notifiable(base);
        if (r<0) {
            event_warnx("%s: Unable to make base notifiable.", __func__);
            event_base_free(base);
            return NULL;
        }
    }
#endif

#ifdef _WIN32
    if (cfg && (cfg->flags & EVENT_BASE_FLAG_STARTUP_IOCP))
        event_base_start_iocp_(base, cfg->n_cpus_hint);
#endif

    return (base);
}

int
event_base_start_iocp_(struct event_base *base, int n_cpus)
{
#ifdef _WIN32
    if (base->iocp)
        return 0;
    base->iocp = event_iocp_port_launch_(n_cpus);
    if (!base->iocp) {
        event_warnx("%s: Couldn't launch IOCP", __func__);
        return -1;
    }
    return 0;
#else
    return -1;
#endif
}

void
event_base_stop_iocp_(struct event_base *base)
{
#ifdef _WIN32
    int rv;

    if (!base->iocp)
        return;
    rv = event_iocp_shutdown_(base->iocp, -1);
    EVUTIL_ASSERT(rv >= 0);
    base->iocp = NULL;
#endif
}

static int
event_base_cancel_single_callback_(struct event_base *base,
                                   struct event_callback *evcb,
                                   int run_finalizers)
{
    int result = 0;

    if (evcb->evcb_flags & EVLIST_INIT) {
        struct event *ev = event_callback_to_event(evcb);
        if (!(ev->ev_flags & EVLIST_INTERNAL)) {
            event_del_(ev, EVENT_DEL_EVEN_IF_FINALIZING);
            result = 1;
        }
    } else {
        EVBASE_ACQUIRE_LOCK(base, th_base_lock);
        event_callback_cancel_nolock_(base, evcb, 1);
        EVBASE_RELEASE_LOCK(base, th_base_lock);
        result = 1;
    }

    if (run_finalizers && (evcb->evcb_flags & EVLIST_FINALIZING)) {
        switch (evcb->evcb_closure) {
        case EV_CLOSURE_EVENT_FINALIZE:
        case EV_CLOSURE_EVENT_FINALIZE_FREE: {
            struct event *ev = event_callback_to_event(evcb);
            ev->ev_evcallback.evcb_cb_union.evcb_evfinalize(ev, ev->ev_arg);
            if (evcb->evcb_closure == EV_CLOSURE_EVENT_FINALIZE_FREE)
                mm_free(ev);
            break;
        }
        case EV_CLOSURE_CB_FINALIZE:
            evcb->evcb_cb_union.evcb_cbfinalize(evcb, evcb->evcb_arg);
            break;
        default:
            break;
        }
    }
    return result;
}

static int event_base_free_queues_(struct event_base *base, int run_finalizers)
{
    int deleted = 0, i;

    for (i = 0; i < base->nactivequeues; ++i) {
        struct event_callback *evcb, *next;
        for (evcb = TAILQ_FIRST(&base->activequeues[i]); evcb; ) {
            next = TAILQ_NEXT(evcb, evcb_active_next);
            deleted += event_base_cancel_single_callback_(base, evcb, run_finalizers);
            evcb = next;
        }
    }

    {
        struct event_callback *evcb;
        while ((evcb = TAILQ_FIRST(&base->active_later_queue))) {
            deleted += event_base_cancel_single_callback_(base, evcb, run_finalizers);
        }
    }

    return deleted;
}

static void
event_base_free_(struct event_base *base, int run_finalizers)
{
    int i, n_deleted=0;
    struct event *ev;
    /* XXXX grab the lock? If there is contention when one thread frees
     * the base, then the contending thread will be very sad soon. */

    /* event_base_free(NULL) is how to free the current_base if we
     * made it with event_init and forgot to hold a reference to it. */
    if (base == NULL && current_base)
        base = current_base;
    /* Don't actually free NULL. */
    if (base == NULL) {
        event_warnx("%s: no base to free", __func__);
        return;
    }
    /* XXX(niels) - check for internal events first */

#ifdef _WIN32
    event_base_stop_iocp_(base);
#endif

    /* threading fds if we have them */
    if (base->th_notify_fd[0] != -1) {
        event_del(&base->th_notify);
        EVUTIL_CLOSESOCKET(base->th_notify_fd[0]);
        if (base->th_notify_fd[1] != -1)
            EVUTIL_CLOSESOCKET(base->th_notify_fd[1]);
        base->th_notify_fd[0] = -1;
        base->th_notify_fd[1] = -1;
        event_debug_unassign(&base->th_notify);
    }

    /* Delete all non-internal events. */
    evmap_delete_all_(base);

    while ((ev = min_heap_top_(&base->timeheap)) != NULL) {
        event_del(ev);
        ++n_deleted;
    }
    for (i = 0; i < base->n_common_timeouts; ++i) {
        struct common_timeout_list *ctl =
                base->common_timeout_queues[i];
        event_del(&ctl->timeout_event); /* Internal; doesn't count */
        event_debug_unassign(&ctl->timeout_event);
        for (ev = TAILQ_FIRST(&ctl->events); ev; ) {
            struct event *next = TAILQ_NEXT(ev,
                                            ev_timeout_pos.ev_next_with_common_timeout);
            if (!(ev->ev_flags & EVLIST_INTERNAL)) {
                event_del(ev);
                ++n_deleted;
            }
            ev = next;
        }
        mm_free(ctl);
    }
    if (base->common_timeout_queues)
        mm_free(base->common_timeout_queues);

    for (;;) {
        /* For finalizers we can register yet another finalizer out from
         * finalizer, and iff finalizer will be in active_later_queue we can
         * add finalizer to activequeues, and we will have events in
         * activequeues after this function returns, which is not what we want
         * (we even have an assertion for this).
         *
         * A simple case is bufferevent with underlying (i.e. filters).
         */
        int i = event_base_free_queues_(base, run_finalizers);
        if (!i) {
            break;
        }
        n_deleted += i;
    }

    if (n_deleted)
        event_debug(("%s: %d events were still set in base",
                     __func__, n_deleted));

    while (LIST_FIRST(&base->once_events)) {
        struct event_once *eonce = LIST_FIRST(&base->once_events);
        LIST_REMOVE(eonce, next_once);
        mm_free(eonce);
    }

    if (base->evsel != NULL && base->evsel->dealloc != NULL)
        base->evsel->dealloc(base);

    for (i = 0; i < base->nactivequeues; ++i)
        EVUTIL_ASSERT(TAILQ_EMPTY(&base->activequeues[i]));

    EVUTIL_ASSERT(min_heap_empty_(&base->timeheap));
    min_heap_dtor_(&base->timeheap);

    mm_free(base->activequeues);

    evmap_io_clear_(&base->io);
    evmap_signal_clear_(&base->sigmap);
    event_changelist_freemem_(&base->changelist);

    EVTHREAD_FREE_LOCK(base->th_base_lock, 0);
    EVTHREAD_FREE_COND(base->current_event_cond);

    /* If we're freeing current_base, there won't be a current_base. */
    if (base == current_base)
        current_base = NULL;
    mm_free(base);
}

void
event_base_free_nofinalize(struct event_base *base)
{
    event_base_free_(base, 0);
}

// 释放event_base对象
// 注意：这个函数不会释放当前与 event_base 关联的任何事件,或者关闭他们的套接字,或者释放任何指针
// 如果未决的关闭类型的回调，本函数会唤醒这些回调
void
event_base_free(struct event_base *base)
{
    event_base_free_(base, 1);
}

/* Fake eventop; used to disable the backend temporarily inside event_reinit
 * so that we can call event_del() on an event without telling the backend.
 */
static int
nil_backend_del(struct event_base *b, evutil_socket_t fd, short old,
                short events, void *fdinfo)
{
    return 0;
}
const struct eventop nil_eventop = {
    "nil",
    NULL, /* init: unused. */
    NULL, /* add: unused. */
    nil_backend_del, /* del: used, so needs to be killed. */
    NULL, /* dispatch: unused. */
    NULL, /* dealloc: unused. */
    0, 0, 0
};

/* reinitialize the event base after a fork */
// 如果在使用 fork()或者其他相关系统调用启动新进程之后,
// 希望在新子进程中继续使用 event_base,就需要进行重新初始化
int
event_reinit(struct event_base *base)
{
    const struct eventop *evsel;
    int res = 0;
    int was_notifiable = 0;
    int had_signal_added = 0;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);

    evsel = base->evsel;

    /* check if this event mechanism requires reinit on the backend */
    if (evsel->need_reinit) {
        /* We're going to call event_del() on our notify events (the
         * ones that tell about signals and wakeup events).  But we
         * don't actually want to tell the backend to change its
         * state, since it might still share some resource (a kqueue,
         * an epoll fd) with the parent process, and we don't want to
         * delete the fds from _that_ backend, we temporarily stub out
         * the evsel with a replacement.
         */
        base->evsel = &nil_eventop;
    }

    /* We need to re-create a new signal-notification fd and a new
     * thread-notification fd.  Otherwise, we'll still share those with
     * the parent process, which would make any notification sent to them
     * get received by one or both of the event loops, more or less at
     * random.
     */
    if (base->sig.ev_signal_added) {
        event_del_nolock_(&base->sig.ev_signal, EVENT_DEL_AUTOBLOCK);
        event_debug_unassign(&base->sig.ev_signal);
        memset(&base->sig.ev_signal, 0, sizeof(base->sig.ev_signal));
        had_signal_added = 1;
        base->sig.ev_signal_added = 0;
    }
    if (base->sig.ev_signal_pair[0] != -1)
        EVUTIL_CLOSESOCKET(base->sig.ev_signal_pair[0]);
    if (base->sig.ev_signal_pair[1] != -1)
        EVUTIL_CLOSESOCKET(base->sig.ev_signal_pair[1]);
    if (base->th_notify_fn != NULL) {
        was_notifiable = 1;
        base->th_notify_fn = NULL;
    }
    if (base->th_notify_fd[0] != -1) {
        event_del_nolock_(&base->th_notify, EVENT_DEL_AUTOBLOCK);
        EVUTIL_CLOSESOCKET(base->th_notify_fd[0]);
        if (base->th_notify_fd[1] != -1)
            EVUTIL_CLOSESOCKET(base->th_notify_fd[1]);
        base->th_notify_fd[0] = -1;
        base->th_notify_fd[1] = -1;
        event_debug_unassign(&base->th_notify);
    }

    /* Replace the original evsel. */
    base->evsel = evsel;

    if (evsel->need_reinit) {
        /* Reconstruct the backend through brute-force, so that we do
         * not share any structures with the parent process. For some
         * backends, this is necessary: epoll and kqueue, for
         * instance, have events associated with a kernel
         * structure. If didn't reinitialize, we'd share that
         * structure with the parent process, and any changes made by
         * the parent would affect our backend's behavior (and vice
         * versa).
         */
        if (base->evsel->dealloc != NULL)
            base->evsel->dealloc(base);
        base->evbase = evsel->init(base);
        if (base->evbase == NULL) {
            event_errx(1,
                       "%s: could not reinitialize event mechanism",
                       __func__);
            res = -1;
            goto done;
        }

        /* Empty out the changelist (if any): we are starting from a
         * blank slate. */
        event_changelist_freemem_(&base->changelist);

        /* Tell the event maps to re-inform the backend about all
         * pending events. This will make the signal notification
         * event get re-created if necessary. */
        if (evmap_reinit_(base) < 0)
            res = -1;
    } else {
        res = evsig_init_(base);
        if (res == 0 && had_signal_added) {
            res = event_add_nolock_(&base->sig.ev_signal, NULL, 0);
            if (res == 0)
                base->sig.ev_signal_added = 1;
        }
    }

    /* If we were notifiable before, and nothing just exploded, become
     * notifiable again. */
    if (was_notifiable && res == 0)
        res = evthread_make_base_notifiable_nolock_(base);

done:
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return (res);
}

/* Get the monotonic time for this event_base' timer */
int
event_gettime_monotonic(struct event_base *base, struct timeval *tv)
{
    int rv = -1;

    if (base && tv) {
        EVBASE_ACQUIRE_LOCK(base, th_base_lock);
        rv = evutil_gettime_monotonic_(&(base->monotonic_timer), tv);
        EVBASE_RELEASE_LOCK(base, th_base_lock);
    }

    return rv;
}

// 获取当前环境可以支持的后台方法
// 返回指针数组，每个指针指向支持方法的名字。数组的末尾指向NULL
const char **
event_get_supported_methods(void)
{
    static const char **methods = NULL;
    const struct eventop **method;
    const char **tmp;
    int i = 0, k;

    /* count all methods */
    // 遍历静态全局数组eventops，获得编译后的后台方法个数
    for (method = &eventops[0]; *method != NULL; ++method) {
        ++i;
    }

    /* allocate one more than we need for the NULL pointer */
    // 分配临时空间，二级指针，用来存放名字指针
    tmp = mm_calloc((i + 1), sizeof(char *));
    if (tmp == NULL)
        return (NULL);

    /* populate the array with the supported methods */
    // 在tmp数组中保存名字指针
    for (k = 0, i = 0; eventops[k] != NULL; ++k) {
        tmp[i++] = eventops[k]->name;
    }
    tmp[i] = NULL;

    if (methods != NULL)
        mm_free((char**)methods);

    methods = tmp;

    return (methods);
}

// 分配新的event_config对象并赋初值。event_config对象用来改变event_base的行为。
// 返回event_config对象，里面存放着配置信息，失败则返回NULL
// 相关查看event_base_new_with_config，event_config_free，event_config结构体等
struct event_config *
        event_config_new(void)
{
    // 使用内部分配api mm_calloc分配event_config对象
    struct event_config *cfg = mm_calloc(1, sizeof(*cfg));

    if (cfg == NULL)
        return (NULL);

    // 初始化屏蔽的后台方法列表
    TAILQ_INIT(&cfg->entries);
    // 设置最大调度时间间隔，初始为非法值
    cfg->max_dispatch_interval.tv_sec = -1;
    // 设置最大调度回调函数个数，初始值为int的最大值
    cfg->max_dispatch_callbacks = INT_MAX;
    // 设置优先级后的回调函数的限制，初始值为1
    cfg->limit_callbacks_after_prio = 1;

    return (cfg);
}

// 屏蔽的后台方法释放
static void
event_config_entry_free(struct event_config_entry *entry)
{
    if (entry->avoid_method != NULL)
        mm_free((char *)entry->avoid_method);
    mm_free(entry);
}

// 释放event_config对象的所有内存，和event_config_new配对使用
void
event_config_free(struct event_config *cfg)
{
    struct event_config_entry *entry;

    // 遍历屏蔽的后台方法列表，释放屏蔽的后台方法项目
    while ((entry = TAILQ_FIRST(&cfg->entries)) != NULL) {
        TAILQ_REMOVE(&cfg->entries, entry, next);
        event_config_entry_free(entry);
    }
    mm_free(cfg);
}

// 设置event_base的工作模式，需要在申请event_config之后运行，在配置event_base之前执行；
// 可以设置多个工作模式同时存在，但是需要注意的是不是每种工作模式都是可以设置的，
// 需要查看本地内核环境以及后台方法是否支持
// 从enum event_base_config_flag中选择
int
event_config_set_flag(struct event_config *cfg, int flag)
{
    if (!cfg)
        return -1;
    cfg->flags |= flag;
    return 0;
}

// 可以通过名字让 libevent 避免使用特定的可用后端,
// 可以用来避免某些不支持特定文件描述符类型的后台方法
int
event_config_avoid_method(struct event_config *cfg, const char *method)
{
    // 申请存储屏蔽后台方法名字的空间
    struct event_config_entry *entry = mm_malloc(sizeof(*entry));
    if (entry == NULL)
        return (-1);

    // 申请后台方法名字空间
    if ((entry->avoid_method = mm_strdup(method)) == NULL) {
        mm_free(entry);
        return (-1);
    }

    // 将屏蔽的方法插入屏蔽队列
    TAILQ_INSERT_TAIL(&cfg->entries, entry, next);

    return (0);
}

// 设置后台方法特征，让 libevent 不使用不能提供所有指定特征的后端；
// 设置后台方法特征的代码应该在event_base_new_with_config之前进行；
// 注意，这里不是采用或的方式，而是直接替换为输入的方法特征
// EV_FEATURE_ET, EV_FEATURE_O1, EV_FEATURE_FDS, EV_FEATURE_EARLY_CLOSE
int
event_config_require_features(struct event_config *cfg,
                              int features)
{
    if (!cfg)
        return (-1);
    cfg->require_features = features;
    return (0);
}

// 这个函数当前仅在 Windows 上使用 IOCP 时有用,
// 告诉 event_config 在生成多线程 event_base 的时候,应该试图使用给定数目的 CPU
int
event_config_set_num_cpus_hint(struct event_config *cfg, int cpus)
{
    if (!cfg)
        return (-1);
    cfg->n_cpus_hint = cpus;
    return (0);
}

// 设置event_base调度的一些间隔信息
int
event_config_set_max_dispatch_interval(struct event_config *cfg,
                                       const struct timeval *max_interval, int max_callbacks, int min_priority)
{
    // 如果max_interval不为空，则将输入的参数拷贝到cfg中，否则设置为非法值
    if (max_interval)
        memcpy(&cfg->max_dispatch_interval, max_interval,
               sizeof(struct timeval));
    else
        cfg->max_dispatch_interval.tv_sec = -1;
    // 如果max_callbacks >=0,则设置为max_callbacks，否则设置为INT_MAX
    cfg->max_dispatch_callbacks =
            max_callbacks >= 0 ? max_callbacks : INT_MAX;
    // 如果<0，则所有优先级都执行检查，否则设置为传入参数
    if (min_priority < 0)
        min_priority = 0;
    cfg->limit_callbacks_after_prio = min_priority;
    return (0);
}

int
event_priority_init(int npriorities)
{
    return event_base_priority_init(current_base, npriorities);
}

// 设置event_base的优先级个数,并分配base->activequeues
// 优 先 级 将 从0( 最 高 ) 到n_priorities-1(最低)
int
event_base_priority_init(struct event_base *base, int npriorities)
{
    int i, r;
    r = -1;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);

    // 由N_ACTIVE_CALLBACKS宏可以知道，本函数应该要在event_base_dispatch
    // 函数调用前调用,且优先级个数，要小于EVENT_MAX_PRIORITIES,不然将无法设置
    if (N_ACTIVE_CALLBACKS(base) || npriorities < 1
            || npriorities >= EVENT_MAX_PRIORITIES)
        goto err;

    // 之前和现在要设置的优先级数是一样的
    if (npriorities == base->nactivequeues)
        goto ok;

    // 释放之前的，因为N_ACTIVE_CALLBACKS,所以没有active的event。
    // 可以随便mm_free
    if (base->nactivequeues) {
        mm_free(base->activequeues);
        base->nactivequeues = 0;
    }

    /* Allocate our priority queues */
    // 分配一个优先级数组
    base->activequeues = (struct evcallback_list *)
            mm_calloc(npriorities, sizeof(struct evcallback_list));
    if (base->activequeues == NULL) {
        event_warn("%s: calloc", __func__);
        goto err;
    }
    base->nactivequeues = npriorities;

    for (i = 0; i < base->nactivequeues; ++i) {
        TAILQ_INIT(&base->activequeues[i]);
    }

ok:
    r = 0;
err:
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return (r);
}

// 获取event_base的优先级个数
int
event_base_get_npriorities(struct event_base *base)
{

    int n;
    if (base == NULL)
        base = current_base;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    n = base->nactivequeues;
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return (n);
}

int
event_base_get_num_events(struct event_base *base, unsigned int type)
{
    int r = 0;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);

    if (type & EVENT_BASE_COUNT_ACTIVE)
        r += base->event_count_active;

    if (type & EVENT_BASE_COUNT_VIRTUAL)
        r += base->virtual_event_count;

    if (type & EVENT_BASE_COUNT_ADDED)
        r += base->event_count;

    EVBASE_RELEASE_LOCK(base, th_base_lock);

    return r;
}

int
event_base_get_max_events(struct event_base *base, unsigned int type, int clear)
{
    int r = 0;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);

    if (type & EVENT_BASE_COUNT_ACTIVE) {
        r += base->event_count_active_max;
        if (clear)
            base->event_count_active_max = 0;
    }

    if (type & EVENT_BASE_COUNT_VIRTUAL) {
        r += base->virtual_event_count_max;
        if (clear)
            base->virtual_event_count_max = 0;
    }

    if (type & EVENT_BASE_COUNT_ADDED) {
        r += base->event_count_max;
        if (clear)
            base->event_count_max = 0;
    }

    EVBASE_RELEASE_LOCK(base, th_base_lock);

    return r;
}

/* Returns true iff we're currently watching any events. */
static int
event_haveevents(struct event_base *base)
{
    /* Caller must hold th_base_lock */
    return (base->virtual_event_count > 0 || base->event_count > 0);
}

/* "closure" function called when processing active signal events */
// 处理激活的信号事件时的调用函数
static inline void
event_signal_closure(struct event_base *base, struct event *ev)
{
    short ncalls;
    int should_break;

    /* Allows deletes to work */
    ncalls = ev->ev_ncalls;
    if (ncalls != 0)
        ev->ev_pncalls = &ncalls;
    // while循环里面会调用用户设置的回调函数可能会执行很久,所以要解锁先.
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    // 根据事件调用次数循环调用信号事件回调函数
    while (ncalls) {
        ncalls--;
        ev->ev_ncalls = ncalls;
        if (ncalls == 0)
            ev->ev_pncalls = NULL;
        (*ev->ev_callback)(ev->ev_fd, ev->ev_res, ev->ev_arg);

        EVBASE_ACQUIRE_LOCK(base, th_base_lock);
        // 如果其他线程调用event_base_loopbreak函数，则中断之
        should_break = base->event_break;
        EVBASE_RELEASE_LOCK(base, th_base_lock);

        if (should_break) {
            if (ncalls != 0)
                ev->ev_pncalls = NULL;
            return;
        }
    }
}

/* Common timeouts are special timeouts that are handled as queues rather than
 * in the minheap.  This is more efficient than the minheap if we happen to
 * know that we're going to get several thousands of timeout events all with
 * the same timeout value.
 *
 * Since all our timeout handling code assumes timevals can be copied,
 * assigned, etc, we can't use "magic pointer" to encode these common
 * timeouts.  Searching through a list to see if every timeout is common could
 * also get inefficient.  Instead, we take advantage of the fact that tv_usec
 * is 32 bits long, but only uses 20 of those bits (since it can never be over
 * 999999.)  We use the top bits to encode 4 bites of magic number, and 8 bits
 * of index into the event_base's aray of common timeouts.
 */
// common_timeout的相关标志
// 对一个struct timeval结构体,成员tv_usec的单位是微秒，
// 所以最大也就是999999,只需低20比特位就能存储了。
// 但成员tv_usec的类型是int或者long，肯定有32比特位。
// 所以，就有高12比特位是空闲的
// libevent使用最高的4比特位作为标志位，标志它是一个专门用于common-timeout的时间，
// 次8比特位用来记录该超时时长在common_timeout_queues数组中的位置，即下标值。
// 这也限制了common_timeout_queues数组的长度，最大为2的8次方，即256
#define MICROSECONDS_MASK       COMMON_TIMEOUT_MICROSECONDS_MASK
#define COMMON_TIMEOUT_IDX_MASK 0x0ff00000
#define COMMON_TIMEOUT_IDX_SHIFT 20
#define COMMON_TIMEOUT_MASK     0xf0000000
#define COMMON_TIMEOUT_MAGIC    0x50000000

#define COMMON_TIMEOUT_IDX(tv) \
    (((tv)->tv_usec & COMMON_TIMEOUT_IDX_MASK)>>COMMON_TIMEOUT_IDX_SHIFT)

/** Return true iff if 'tv' is a common timeout in 'base' */
// 判断是否为common-timeout时间
static inline int
is_common_timeout(const struct timeval *tv,
                  const struct event_base *base)
{
    int idx;
    // 不具有common-timeout标志位，那么就肯定不是commont-timeout时间了
    if ((tv->tv_usec & COMMON_TIMEOUT_MASK) != COMMON_TIMEOUT_MAGIC)
        return 0;
    // 获取超时时长在common_timeout_queues数组中的位置
    idx = COMMON_TIMEOUT_IDX(tv);
    // 可用返回值来来决定是插入小根堆还是common-timeout
    return idx < base->n_common_timeouts;
}

/* True iff tv1 and tv2 have the same common-timeout index, or if neither
 * one is a common timeout. */
static inline int
is_same_common_timeout(const struct timeval *tv1, const struct timeval *tv2)
{
    return (tv1->tv_usec & ~MICROSECONDS_MASK) ==
            (tv2->tv_usec & ~MICROSECONDS_MASK);
}

/** Requires that 'tv' is a common timeout.  Return the corresponding
 * common_timeout_list. */
// 获取公用超时队列
static inline struct common_timeout_list *
        get_common_timeout_list(struct event_base *base, const struct timeval *tv)
{
    return base->common_timeout_queues[COMMON_TIMEOUT_IDX(tv)];
}

#if 0
static inline int
common_timeout_ok(const struct timeval *tv,
                  struct event_base *base)
{
    const struct timeval *expect =
            &get_common_timeout_list(base, tv)->duration;
    return tv->tv_sec == expect->tv_sec &&
            tv->tv_usec == expect->tv_usec;
}
#endif

/* Add the timeout for the first event in given common timeout list to the
 * event_base's minheap. */
// 将给定公共超时列表中第一个超时事件head的添加到最小堆中
static void
common_timeout_schedule(struct common_timeout_list *ctl,
                        const struct timeval *now, struct event *head)
{
    struct timeval timeout = head->ev_timeout;
    // 获取真正的us时间，清除common-timeout标志
    timeout.tv_usec &= MICROSECONDS_MASK;
    // 由于已经清除了common-timeout标志，所以这次将插入到小根堆中，绝对超时时间
    event_add_nolock_(&ctl->timeout_event, &timeout, 1);
}

/* Callback: invoked when the timeout for a common timeout queue triggers.
 * This means that (at least) the first event in that queue should be run,
 * and the timeout should be rescheduled if there are more events. */
// 当common_timeout_list的内部event成员被激活时的回调函数
static void
common_timeout_callback(evutil_socket_t fd, short what, void *arg)
{
    struct timeval now;
    struct common_timeout_list *ctl = arg;
    struct event_base *base = ctl->base;
    struct event *ev = NULL;
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    gettime(base, &now);
    while (1) {
        ev = TAILQ_FIRST(&ctl->events);
        // 该超时event还没到超时时间。不要检查其他了。因为是升序的
        if (!ev || ev->ev_timeout.tv_sec > now.tv_sec ||
                (ev->ev_timeout.tv_sec == now.tv_sec &&
                 (ev->ev_timeout.tv_usec&MICROSECONDS_MASK) > now.tv_usec))
            break;
        // 一系列的删除操作,包括从这个超时event队列中删除
        event_del_nolock_(ev, EVENT_DEL_NOBLOCK);
        // 手动激活超时event。注意，这个ev是用户的超时event
        event_active_nolock_(ev, EV_TIMEOUT, 1);
    }
    // 不是NULL，说明该队列还有超时event。那么需要再次common_timeout_schedule，进行监听
    if (ev)
        common_timeout_schedule(ctl, &now, ev);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

#define MAX_COMMON_TIMEOUTS 256

// 申请一个时长为duration的common_timeout_list
const struct timeval *
        event_base_init_common_timeout(struct event_base *base,
                                       const struct timeval *duration)
{
    int i;
    struct timeval tv;
    // 具有common-timeout标志的超时时间
    const struct timeval *result=NULL;
    struct common_timeout_list *new_ctl;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    // 这个时间的微秒位应该进位。用户没有将之进位成秒
    if (duration->tv_usec > 1000000) {
        memcpy(&tv, duration, sizeof(struct timeval));
        if (is_common_timeout(duration, base))
            // 去除common-timeout标志，获取真正的us值
            tv.tv_usec &= MICROSECONDS_MASK;
        // 进位
        tv.tv_sec += tv.tv_usec / 1000000;
        tv.tv_usec %= 1000000;
        duration = &tv;
    }
    // 查找是否有duration时间对应的超时队列
    for (i = 0; i < base->n_common_timeouts; ++i) {
        const struct common_timeout_list *ctl =
                base->common_timeout_queues[i];
        // 具有相同的duration， 即之前有申请过这个超时时长。那么就不用分配空间。
        if (duration->tv_sec == ctl->duration.tv_sec &&
                duration->tv_usec ==
                // 要&这个宏，才能是正确的时间
                (ctl->duration.tv_usec & MICROSECONDS_MASK)) {
            EVUTIL_ASSERT(is_common_timeout(&ctl->duration, base));
            result = &ctl->duration;
            goto done;
        }
    }
    // 达到了最大申请个数，不能再分配了
    if (base->n_common_timeouts == MAX_COMMON_TIMEOUTS) {
        event_warnx("%s: Too many common timeouts already in use; "
                    "we only support %d per event_base", __func__,
                    MAX_COMMON_TIMEOUTS);
        goto done;
    }
    // 之前分配的空间已经用完了，要重新申请空间
    if (base->n_common_timeouts_allocated == base->n_common_timeouts) {
        int n = base->n_common_timeouts < 16 ? 16 :
                                               base->n_common_timeouts*2;
        struct common_timeout_list **newqueues =
                mm_realloc(base->common_timeout_queues,
                           n*sizeof(struct common_timeout_queue *));
        if (!newqueues) {
            event_warn("%s: realloc",__func__);
            goto done;
        }
        base->n_common_timeouts_allocated = n;
        base->common_timeout_queues = newqueues;
    }
    // 为该超时时长分配一个common_timeout_list结构体
    new_ctl = mm_calloc(1, sizeof(struct common_timeout_list));
    if (!new_ctl) {
        event_warn("%s: calloc",__func__);
        goto done;
    }
    // 为这个结构体进行一些设置
    TAILQ_INIT(&new_ctl->events);
    new_ctl->duration.tv_sec = duration->tv_sec;
    new_ctl->duration.tv_usec =
            // 为这个时间加入common-timeout标志
            duration->tv_usec | COMMON_TIMEOUT_MAGIC |
            // 加入下标值
            (base->n_common_timeouts << COMMON_TIMEOUT_IDX_SHIFT);
    // 对timeout_event这个内部event进行赋值。设置回调函数和回调参数
    evtimer_assign(&new_ctl->timeout_event, base,
                   common_timeout_callback, new_ctl);
    // 标志成内部event
    new_ctl->timeout_event.ev_flags |= EVLIST_INTERNAL;
    // 优先级为最高级
    event_priority_set(&new_ctl->timeout_event, 0);
    new_ctl->base = base;
    // 放到数组对应的位置上
    base->common_timeout_queues[base->n_common_timeouts++] = new_ctl;
    result = &new_ctl->duration;

done:
    if (result)
        EVUTIL_ASSERT(is_common_timeout(result, base));

    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return result;
}

/* Closure function invoked when we're activating a persistent event. */
// 处理永久事件的回调函数
// 重新添加该事件到base中，并执行用户注册的回调函数
static inline void
event_persist_closure(struct event_base *base, struct event *ev)
{
    void (*evcb_callback)(evutil_socket_t, short, void *);

    // Other fields of *ev that must be stored before executing
    evutil_socket_t evcb_fd;
    short evcb_res;
    void *evcb_arg;

    /* reschedule the persistent event if we have a timeout. */
    // 这个if只用于处理具有EV_PERSIST属性的超时event，需要重新安排永久事件
    if (ev->ev_io_timeout.tv_sec || ev->ev_io_timeout.tv_usec) {
        /* If there was a timeout, we want it to run at an interval of
         * ev_io_timeout after the last time it was _scheduled_ for,
         * not ev_io_timeout after _now_.  If it fired for another
         * reason, though, the timeout ought to start ticking _now_. */
        // 重新计算的超时时间 run_at = relative_to + delay
        struct timeval run_at, relative_to, delay, now;
        ev_uint32_t usec_mask = 0;
        EVUTIL_ASSERT(is_same_common_timeout(&ev->ev_timeout,
                                             &ev->ev_io_timeout));
        gettime(base, &now);
        // 如果使用公用超时队列，则需要重新调整掩码；
        if (is_common_timeout(&ev->ev_timeout, base)) {
            delay = ev->ev_io_timeout;
            usec_mask = delay.tv_usec & ~MICROSECONDS_MASK;
            delay.tv_usec &= MICROSECONDS_MASK;
            if (ev->ev_res & EV_TIMEOUT) {
                relative_to = ev->ev_timeout;
                relative_to.tv_usec &= MICROSECONDS_MASK;
            } else {
                relative_to = now;
            }
        } else {
            // 如果不使用公用超时队列，则需要根据是否为超时事件来决定下一次的超时时间从哪个时间点开始算起；
            delay = ev->ev_io_timeout;
            // 如果是因为超时而激活,选用ev->ev_timeout，否则为now
            if (ev->ev_res & EV_TIMEOUT) {
                relative_to = ev->ev_timeout;
            } else {
                relative_to = now;
            }
        }
        // 计算下一次要运行的超时时间run_at，不应该小于now
        // 并比较超时时间和当前时间；如果超时，则将事件重新添加到队列中；
        evutil_timeradd(&relative_to, &delay, &run_at);
        if (evutil_timercmp(&run_at, &now, <)) {
            /* Looks like we missed at least one invocation due to
             * a clock jump, not running the event loop for a
             * while, really slow callbacks, or
             * something. Reschedule relative to now.
             */
            evutil_timeradd(&now, &delay, &run_at);
        }
        run_at.tv_usec |= usec_mask;
        // 把重新计算的新的超时event再次添加到event_base中，此时第三个参数为1，说明是一个绝对时间
        event_add_nolock_(ev, &run_at, 1);
    }

    // Save our callback before we release the lock
    evcb_callback = ev->ev_callback;
    evcb_fd = ev->ev_fd;
    evcb_res = ev->ev_res;
    evcb_arg = ev->ev_arg;

    // Release the lock
    EVBASE_RELEASE_LOCK(base, th_base_lock);

    // Execute the callback
    // 执行用户的回调函数
    (evcb_callback)(evcb_fd, evcb_res, evcb_arg);
}

/*
  Helper for event_process_active to process all the events in a single queue,
  releasing the lock as we go.  This function requires that the lock be held
  when it's invoked.  Returns -1 if we get a signal or an event_break that
  means we should stop processing any active events now.  Otherwise returns
  the number of non-internal event_callbacks that we processed.
*/
// event_process_active函数的帮助实现函数；用于处理单个优先级队列中的所有事件；
// 当执行完毕时，需要释放锁；这个函数要求加锁；如果获得一个信号或者event_break时，
// 意味着需要停止执行任何活跃事件，则返回－1；否则返回已经处理的非内部event_callbacks的个数；
// base：event_base句柄
// activeq：某一优先级下的激活回调函数队列
// max_to_process：检查新事件之间执行的回调函数的最大个数
// endtime：如果超过截止时间，则退出执行
static int
event_process_active_single_queue(struct event_base *base,
                                  struct evcallback_list *activeq,
                                  int max_to_process, const struct timeval *endtime)
{
    struct event_callback *evcb;
    int count = 0;

    EVUTIL_ASSERT(activeq != NULL);

    // 遍历同一优先级的所有event
    for (evcb = TAILQ_FIRST(activeq); evcb; evcb = TAILQ_FIRST(activeq)) {
        struct event *ev=NULL;
        // 如果回调函数状态为初始化状态
        if (evcb->evcb_flags & EVLIST_INIT) {
            ev = event_callback_to_event(evcb);

            // 如果回调函数对应的事件为永久事件，或者事件状态为结束，
            // 则将事件回调函数从激活队列中移除；否则，则需要删除事件；
            if (ev->ev_events & EV_PERSIST || ev->ev_flags & EVLIST_FINALIZING)
                event_queue_remove_active(base, evcb);
            else
                event_del_nolock_(ev, EVENT_DEL_NOBLOCK);
            event_debug((
                            "event_process_active: event: %p, %s%s%scall %p",
                            ev,
                            ev->ev_res & EV_READ ? "EV_READ " : " ",
                            ev->ev_res & EV_WRITE ? "EV_WRITE " : " ",
                            ev->ev_res & EV_CLOSED ? "EV_CLOSED " : " ",
                            ev->ev_callback));
        } else {
            // 如果是其它状态，则将回调函数从激活队列中移除
            event_queue_remove_active(base, evcb);
            event_debug(("event_process_active: event_callback %p, "
                         "closure %d, call %p",
                         evcb, evcb->evcb_closure, evcb->evcb_cb_union.evcb_callback));
        }

        // 如果回调函数状态为非内部状态，则执行的事件个数＋1
        if (!(evcb->evcb_flags & EVLIST_INTERNAL))
            ++count;

        // 记录当前base执行的回调函数
        base->current_event = evcb;
#ifndef EVENT__DISABLE_THREAD_SUPPORT
        base->current_event_waiters = 0;
#endif

        // 根据事件回调函数模式，执行不同的回调函数
        switch (evcb->evcb_closure) {
        // 信号事件
        case EV_CLOSURE_EVENT_SIGNAL:
            EVUTIL_ASSERT(ev != NULL);
            event_signal_closure(base, ev);
            break;
            // 永久性非信号事件
        case EV_CLOSURE_EVENT_PERSIST:
            EVUTIL_ASSERT(ev != NULL);
            event_persist_closure(base, ev);
            break;
            // 常规事件
        case EV_CLOSURE_EVENT: {
            void (*evcb_callback)(evutil_socket_t, short, void *);
            EVUTIL_ASSERT(ev != NULL);
            evcb_callback = *ev->ev_callback;
            EVBASE_RELEASE_LOCK(base, th_base_lock);
            evcb_callback(ev->ev_fd, ev->ev_res, ev->ev_arg);
        }
            break;
            // 简单回调
        case EV_CLOSURE_CB_SELF: {
            void (*evcb_selfcb)(struct event_callback *, void *) = evcb->evcb_cb_union.evcb_selfcb;
            EVBASE_RELEASE_LOCK(base, th_base_lock);
            evcb_selfcb(evcb, evcb->evcb_arg);
        }
            break;
            // 结束事件
        case EV_CLOSURE_EVENT_FINALIZE:
            // 结束事件之后应该释放
        case EV_CLOSURE_EVENT_FINALIZE_FREE: {
            void (*evcb_evfinalize)(struct event *, void *);
            int evcb_closure = evcb->evcb_closure;
            EVUTIL_ASSERT(ev != NULL);
            base->current_event = NULL;
            evcb_evfinalize = ev->ev_evcallback.evcb_cb_union.evcb_evfinalize;
            EVUTIL_ASSERT((evcb->evcb_flags & EVLIST_FINALIZING));
            EVBASE_RELEASE_LOCK(base, th_base_lock);
            evcb_evfinalize(ev, ev->ev_arg);
            event_debug_note_teardown_(ev);
            if (evcb_closure == EV_CLOSURE_EVENT_FINALIZE_FREE)
                mm_free(ev);
        }
            break;
            // 结束型回调
        case EV_CLOSURE_CB_FINALIZE: {
            void (*evcb_cbfinalize)(struct event_callback *, void *) = evcb->evcb_cb_union.evcb_cbfinalize;
            base->current_event = NULL;
            EVUTIL_ASSERT((evcb->evcb_flags & EVLIST_FINALIZING));
            EVBASE_RELEASE_LOCK(base, th_base_lock);
            evcb_cbfinalize(evcb, evcb->evcb_arg);
        }
            break;
        default:
            EVUTIL_ASSERT(0);
        }

        EVBASE_ACQUIRE_LOCK(base, th_base_lock);
        base->current_event = NULL;
#ifndef EVENT__DISABLE_THREAD_SUPPORT
        if (base->current_event_waiters) {
            base->current_event_waiters = 0;
            EVTHREAD_COND_BROADCAST(base->current_event_cond);
        }
#endif

        // 如果中止标志位设置，则中断执行
        if (base->event_break)
            return -1;
        // 如果当前执行的事件个数 大于 检查新事件之间执行回调函数个数，则需要返回检查新事件
        if (count >= max_to_process)
            return count;
        // 如果执行的事件个数不为零，且截止时间不为空，则需要判定当前时间是否超过截止时间，如果超过，则退出执行；
        if (count && endtime) {
            struct timeval now;
            update_time_cache(base);
            gettime(base, &now);
            if (evutil_timercmp(&now, endtime, >=))
                return count;
        }
        if (base->event_continue)
            break;
    }
    return count;
}

/*
 * Active events are stored in priority queues.  Lower priorities are always
 * process before higher priorities.  Low priority events can starve high
 * priority ones.
 */
// 处理存储在活跃的优先级队列中的事件(即回调函数)；；
// 从event_base的activequeueus链表数组上取出event调用回调函数
// 优先调用优先级值最小的event(优先级的数字越小，优先级越高)
static int
event_process_active(struct event_base *base)
{
    /* Caller must hold th_base_lock */
    struct evcallback_list *activeq = NULL;
    int i, c = 0;
    const struct timeval *endtime;
    struct timeval tv;
    // 获取重新检查新事件产生之前，可以处理的回调函数的最大个数；
    // 优先级低于limit_callbacks_after_prio的事件执行时，才会检查新事件，否则不检查
    const int maxcb = base->max_dispatch_callbacks;
    const int limit_after_prio = base->limit_callbacks_after_prio;

    // 如果检查新事件间隔时间 >=0，为了检查间隔更为精确，则需要更新base中的时间，并获取base中当前的时间；
    // 然后计算下一次检查的时间endtime＝base->max_dispatch_time + tv
    if (base->max_dispatch_time.tv_sec >= 0) {
        update_time_cache(base);
        gettime(base, &tv);
        evutil_timeradd(&base->max_dispatch_time, &tv, &tv);
        endtime = &tv;
    } else {
        endtime = NULL;
    }

    // 如果base中激活队列不为空，则根据从高到低的优先级遍历激活队列；
    // 遍历每一个优先级子队列，处理子队列中回调函数；
    // 在执行时，需要根据limit_after_prio设置两次检查新事件之间的间隔；
    // 如果优先级 < limit_after_prio，即当事件优先级高于limit_after_prio时，是不需要查看新事件的；
    // 如果优先级 >＝ limit_after_prio，即当事件优先级不高于limit_after_prio时，是需要根据maxcb以及end_time检查新事件；
    for (i = 0; i < base->nactivequeues; ++i) {
        if (TAILQ_FIRST(&base->activequeues[i]) != NULL) {
            // 记录当前运行的callback的优先级别
            base->event_running_priority = i;
            activeq = &base->activequeues[i];
            if (i < limit_after_prio)
                c = event_process_active_single_queue(base, activeq,
                                                      INT_MAX, NULL);
            else
                c = event_process_active_single_queue(base, activeq,
                                                      maxcb, endtime);
            if (c < 0) {
                goto done;
            } else if (c > 0)
                break; /* Processed a real event; do not
                    * consider lower-priority events */
            /* If we get here, all of the events we processed
             * were internal.  Continue. */
        }
    }

done:
    base->event_running_priority = -1;

    return c;
}

/*
 * Wait continuously for events.  We exit only if no events are left.
 */

int
event_dispatch(void)
{
    return (event_loop(0));
}

// Reactor核心，检测事件、分发事件、调用事件
// 将一直运行,直到没有已经注册的事件了,或者调用了
// event_base_loopbreak()或者 event_base_loopexit()为止
int
event_base_dispatch(struct event_base *event_base)
{
    return (event_base_loop(event_base, 0));
}

// 获取当前正在使用的后台方法名
const char *
event_base_get_method(const struct event_base *base)
{
    EVUTIL_ASSERT(base);
    return (base->evsel->name);
}

/** Callback: used to implement event_base_loopexit by telling the event_base
 * that it's time to exit its loop. */
static void
event_loopexit_cb(evutil_socket_t fd, short what, void *arg)
{
    struct event_base *base = arg;
    base->event_gotterm = 1;
}

int
event_loopexit(const struct timeval *tv)
{
    return (event_once(-1, EV_TIMEOUT, event_loopexit_cb,
                       current_base, tv));
}

// 经过tv时间后退出loop,如果tv参数为NULL,会立即停止循环,没有延时
// 如果 event_base 当前正在执行任何激活事件的回调,
// 则回调会继续运行,直到运行完所有激活事件的回调之才退出
int
event_base_loopexit(struct event_base *event_base, const struct timeval *tv)
{
    return (event_base_once(event_base, -1, EV_TIMEOUT, event_loopexit_cb,
                            event_base, tv));
}

int
event_loopbreak(void)
{
    return (event_base_loopbreak(current_base));
}

// 让 event_base 立即退出循环。它与event_base_loopexit(base,NULL)的不同在于,
// 如果 event_base 当前正在执行激活事件的回调,它将在执行完当前正在处理的事件后立即退出
int
event_base_loopbreak(struct event_base *event_base)
{
    int r = 0;
    if (event_base == NULL)
        return (-1);

    EVBASE_ACQUIRE_LOCK(event_base, th_base_lock);
    event_base->event_break = 1;

    if (EVBASE_NEED_NOTIFY(event_base)) {
        r = evthread_notify_base(event_base);
    } else {
        r = (0);
    }
    EVBASE_RELEASE_LOCK(event_base, th_base_lock);
    return r;
}

int
event_base_loopcontinue(struct event_base *event_base)
{
    int r = 0;
    if (event_base == NULL)
        return (-1);

    EVBASE_ACQUIRE_LOCK(event_base, th_base_lock);
    event_base->event_continue = 1;

    if (EVBASE_NEED_NOTIFY(event_base)) {
        r = evthread_notify_base(event_base);
    } else {
        r = (0);
    }
    EVBASE_RELEASE_LOCK(event_base, th_base_lock);
    return r;
}

// 检测循环是否是event_base_break退出的
int
event_base_got_break(struct event_base *event_base)
{
    int res;
    EVBASE_ACQUIRE_LOCK(event_base, th_base_lock);
    res = event_base->event_break;
    EVBASE_RELEASE_LOCK(event_base, th_base_lock);
    return res;
}

// 检测循环是否是event_base_loopexit退出的
int
event_base_got_exit(struct event_base *event_base)
{
    int res;
    EVBASE_ACQUIRE_LOCK(event_base, th_base_lock);
    res = event_base->event_gotterm;
    EVBASE_RELEASE_LOCK(event_base, th_base_lock);
    return res;
}

/* not thread safe */

int
event_loop(int flags)
{
    return event_base_loop(current_base, flags);
}

// 等待事件变为活跃，然后运行事件回调函数
// 相比event_base_dispatch函数，这个函数更为灵活。默认情况下，loop会一直运行到没有等待事件或者激活的事件，或者
// 运行到调用event_base_loopbreak或者event_base_loopexit函数。你可以使用’flags‘调整loop行为。
// 参数base：event_base_new或者event_base_new_with_config产生的event_base结构体
// flags：可以是EVLOOP_ONCE｜EVLOOP_NONBLOCK
// 返回值：成功则为0，失败则为－1，如果因为没有等待的事件或者激活事件而退出则返回1
// 1. 信号标记被设置，则调用信号的回调函数
// 2. 根据定时器最小时间，设置I/O多路复用的最大等待时间，这样即使没有I/O事件发生，也能在最小定时器超时时返回。
// 3. 调用I/O多路复用，监听事件，将活跃事件添加到活跃事件链表中
// 4. 检查定时事件，将就绪的定时事件从小根堆中删除，插入到活跃事件链表中
// 5. 对活跃事件链表中的事件，调用event_process_active(）函数，在该函数内调用event的回调函数，优先级高的event先处理
int
event_base_loop(struct event_base *base, int flags)
{
    // 获取event_base的I/O多路复用相关信息
    const struct eventop *evsel = base->evsel;
    struct timeval tv;
    struct timeval *tv_p;
    int res, done, retval = 0;

    /* Grab the lock.  We will release it inside evsel.dispatch, and again
     * as we invoke user callbacks. */
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);

    // loop循环已经执行，则直接返回
    if (base->running_loop) {
        event_warnx("%s: reentrant invocation.  Only one event_base_loop"
                    " can run on each event_base at once.", __func__);
        EVBASE_RELEASE_LOCK(base, th_base_lock);
        return -1;
    }

    base->running_loop = 1;

    // 清空当前event_base中缓存的时间，防止误用
    clear_time_cache(base);

    // 如果有信号事件，则指定信号所属的event_base
    if (base->sig.ev_signal_added && base->sig.ev_n_signals_added)
        evsig_set_base_(base);

    done = 0;

#ifndef EVENT__DISABLE_THREAD_SUPPORT
    base->th_owner_id = EVTHREAD_GET_ID();
#endif

    base->event_gotterm = base->event_break = 0;

    while (!done) {
        base->event_continue = 0;
        base->n_deferreds_queued = 0;

        /* Terminate the loop if we have been asked to */
        // 每次loop时，需要判定是否别的地方已经设置了终止或者退出的标志位
        if (base->event_gotterm) {
            // event_loopexit_cb()可设置
            break;
        }
        if (base->event_break) {
            // event_base_loopbreak()可设置
            break;
        }

        tv_p = &tv;
        // 如果event_base的活跃事件数量为空并且不是非阻塞模式，
        // 则根据定时器堆中最小超时时间计算I/O多路复用evsel->dispatch的最大等待时间tv_p
        if (!N_ACTIVE_CALLBACKS(base) && !(flags & EVLOOP_NONBLOCK)) {
            timeout_next(base, &tv_p);
        } else {
            /*
             * if we have active events, we just poll new events
             * without waiting.
             */
            // 有活跃的事件，则把等待时间置为0，马上触发事件
            evutil_timerclear(&tv);
        }

        /* If we have no events, we just exit */
        // 如果没有关注任何事件则退出
        if (0==(flags&EVLOOP_NO_EXIT_ON_EMPTY) &&
                !event_haveevents(base) && !N_ACTIVE_CALLBACKS(base)) {
            event_debug(("%s: no events registered.", __func__));
            retval = 1;
            goto done;
        }

        // 将将下一次激活事件队列中的事件都移动到活跃队列中
        event_queue_make_later_events_active(base);

        // 清空event_base中缓存的时间，防止误用
        clear_time_cache(base);

        // 调用I/O多路复用，监听事件，超时为tv_p
        res = evsel->dispatch(base, tv_p);

        if (res == -1) {
            event_debug(("%s: dispatch returned unsuccessfully.",
                         __func__));
            retval = -1;
            goto done;
        }

        // 更新当前event_base中缓存的时间，可以用来作为超时事件的参考时间
        update_time_cache(base);

        // 主要是从超时事件最小堆中取出超时事件，并将超时事件放入激活队列
        timeout_process(base);

        // 如果激活队列不为空，则处理激活的事件,优先级高的event先处理
        // 否则，如果模式为EVLOOP_ONCE或EVLOOP_NONBLOCK，则退出loop
        if (N_ACTIVE_CALLBACKS(base)) {
            int n = event_process_active(base);
            if ((flags & EVLOOP_ONCE)
                    && N_ACTIVE_CALLBACKS(base) == 0
                    && n != 0)
                done = 1;
        } else if (flags & EVLOOP_NONBLOCK)
            done = 1;
    }
    event_debug(("%s: asked to terminate loop.", __func__));

done:
    clear_time_cache(base);
    base->running_loop = 0;

    EVBASE_RELEASE_LOCK(base, th_base_lock);

    return (retval);
}

/* One-time callback to implement event_base_once: invokes the user callback,
 * then deletes the allocated storage */
static void
event_once_cb(evutil_socket_t fd, short events, void *arg)
{
    struct event_once *eonce = arg;

    (*eonce->cb)(fd, events, eonce->arg);
    EVBASE_ACQUIRE_LOCK(eonce->ev.ev_base, th_base_lock);
    LIST_REMOVE(eonce, next_once);
    EVBASE_RELEASE_LOCK(eonce->ev.ev_base, th_base_lock);
    event_debug_unassign(&eonce->ev);
    mm_free(eonce);
}

/* not threadsafe, event scheduled once. */
int
event_once(evutil_socket_t fd, short events,
           void (*callback)(evutil_socket_t, short, void *),
           void *arg, const struct timeval *tv)
{
    return event_base_once(current_base, fd, events, callback, arg, tv);
}

/* Schedules an event once */
int
event_base_once(struct event_base *base, evutil_socket_t fd, short events,
                void (*callback)(evutil_socket_t, short, void *),
                void *arg, const struct timeval *tv)
{
    struct event_once *eonce;
    int res = 0;
    int activate = 0;

    /* We cannot support signals that just fire once, or persistent
     * events. */
    if (events & (EV_SIGNAL|EV_PERSIST))
        return (-1);

    if ((eonce = mm_calloc(1, sizeof(struct event_once))) == NULL)
        return (-1);

    eonce->cb = callback;
    eonce->arg = arg;

    if ((events & (EV_TIMEOUT|EV_SIGNAL|EV_READ|EV_WRITE|EV_CLOSED)) == EV_TIMEOUT) {
        evtimer_assign(&eonce->ev, base, event_once_cb, eonce);

        if (tv == NULL || ! evutil_timerisset(tv)) {
            /* If the event is going to become active immediately,
             * don't put it on the timeout queue.  This is one
             * idiom for scheduling a callback, so let's make
             * it fast (and order-preserving). */
            activate = 1;
        }
    } else if (events & (EV_READ|EV_WRITE|EV_CLOSED)) {
        events &= EV_READ|EV_WRITE|EV_CLOSED;

        event_assign(&eonce->ev, base, fd, events, event_once_cb, eonce);
    } else {
        /* Bad event combination */
        mm_free(eonce);
        return (-1);
    }

    if (res == 0) {
        EVBASE_ACQUIRE_LOCK(base, th_base_lock);
        if (activate)
            event_active_nolock_(&eonce->ev, EV_TIMEOUT, 1);
        else
            res = event_add_nolock_(&eonce->ev, tv, 0);

        if (res != 0) {
            mm_free(eonce);
            return (res);
        } else {
            LIST_INSERT_HEAD(&base->once_events, eonce, next_once);
        }
        EVBASE_RELEASE_LOCK(base, th_base_lock);
    }

    return (0);
}

// 根据所给条件赋值给事件event
// 将事件ev绑定在base上，关联文件描述符fd，
// 关注的事件类型是events，事件发生时的
// 回调函数是callback，回调函数的参数是arg
// 把给定的event类型对象的每一个成员赋予一个指定的值
int
event_assign(struct event *ev, struct event_base *base, evutil_socket_t fd, short events, void (*callback)(evutil_socket_t, short, void *), void *arg)
{
    if (!base)
        base = current_base;
    // 主要用于回调函数的参数就是其本身event的情况
    if (arg == &event_self_cbarg_ptr_)
        arg = ev;

    event_debug_assert_not_added_(ev);

    // 事件结构体初始设置
    ev->ev_base = base;

    ev->ev_callback = callback;
    ev->ev_arg = arg;
    ev->ev_fd = fd;
    ev->ev_events = events;
    ev->ev_res = 0;
    ev->ev_flags = EVLIST_INIT;
    ev->ev_ncalls = 0;
    ev->ev_pncalls = NULL;

    // 如果是信号事件
    if (events & EV_SIGNAL) {
        // 信号事件与IO事件不能同时存在
        if ((events & (EV_READ|EV_WRITE|EV_CLOSED)) != 0) {
            event_warnx("%s: EV_SIGNAL is not compatible with "
                        "EV_READ, EV_WRITE or EV_CLOSED", __func__);
            return -1;
        }
        // 设置事件关闭时执行回调函数的类型：evcb_callback
        ev->ev_closure = EV_CLOSURE_EVENT_SIGNAL;
    } else {
        // 如果是其它类型的事件：IO事件、定时事件

        // 如果事件是永久事件，即每次调用之后不会移除出事件列表
        // 清空IO超时控制，并设置事件关闭时回调函数类型：evcb_callback
        if (events & EV_PERSIST) {
            evutil_timerclear(&ev->ev_io_timeout);
            ev->ev_closure = EV_CLOSURE_EVENT_PERSIST;
        } else {
            ev->ev_closure = EV_CLOSURE_EVENT;
        }
    }

    // 事件超时控制最小堆初始化
    min_heap_elem_init_(ev);

    // 默认情况下，事件优先级设置为优先级数组长度的一半，即中间优先级
    if (base != NULL) {
        /* by default, we put new events into the middle priority */
        ev->ev_pri = base->nactivequeues / 2;
    }

    event_debug_note_setup_(ev);

    return 0;
}

// 设置event的所属base，优先级
int
event_base_set(struct event_base *base, struct event *ev)
{
    /* Only innocent events may be assigned to a different base */
    // 只能对新建的event设置其所属event_base
    if (ev->ev_flags != EVLIST_INIT)
        return (-1);

    event_debug_assert_is_setup_(ev);

    // 设置所属event_base
    ev->ev_base = base;
    // 设置默认优先级为中间值
    ev->ev_pri = base->nactivequeues/2;

    return (0);
}

// 把相关参数赋值给event
void
event_set(struct event *ev, evutil_socket_t fd, short events,
          void (*callback)(evutil_socket_t, short, void *), void *arg)
{
    int r;
    r = event_assign(ev, current_base, fd, events, callback, arg);
    EVUTIL_ASSERT(r == 0);
}

// 获取event本身
// 很多时候，你可能想创建一个以接收它本身作为回调函数参数的event。
// 你不能只传一个指向event对象的指针，因为调用event_new()时这个event还不存在。
// 为了解决这个问题你可以使用event_self_cbarg()。
void *
event_self_cbarg(void)
{
    return &event_self_cbarg_ptr_;
}

struct event *
        event_base_get_running_event(struct event_base *base)
{
    struct event *ev = NULL;
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    if (EVBASE_IN_THREAD(base)) {
        struct event_callback *evcb = base->current_event;
        if (evcb->evcb_flags & EVLIST_INIT)
            ev = event_callback_to_event(evcb);
    }
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return ev;
}

// 根据监听事件类型，文件描述符，以及回调函数，回调函数参数等创建事件结构体
// base：需要绑定的base
// fd：需要监听的文件描述符或者信号，或者为－1，如果为－1则是定时事件
// events：事件类型，信号事件和IO事件不能同时存在
// callback：回调函数，信号发生或者IO事件或者定时事件发生时
// callback_arg：传递给回调函数的参数，一般是base
struct event *
        event_new(struct event_base *base, evutil_socket_t fd, short events, void (*cb)(evutil_socket_t, short, void *), void *arg)
{
    struct event *ev;
    ev = mm_malloc(sizeof(struct event));
    if (ev == NULL)
        return (NULL);
    if (event_assign(ev, base, fd, events, cb, arg) < 0) {
        mm_free(ev);
        return (NULL);
    }

    return (ev);
}

// 释放由event_new申请的事件
void
event_free(struct event *ev)
{
    /* This is disabled, so that events which have been finalized be a
     * valid target for event_free(). That's */
    // event_debug_assert_is_setup_(ev);

    /* make sure that this event won't be coming back to haunt us. */
    event_del(ev);
    event_debug_note_teardown_(ev);
    mm_free(ev);

}

void
event_debug_unassign(struct event *ev)
{
    event_debug_assert_not_added_(ev);
    event_debug_note_teardown_(ev);

    ev->ev_flags &= ~EVLIST_INIT;
}

#define EVENT_FINALIZE_FREE_ 0x10000
static int
event_finalize_nolock_(struct event_base *base, unsigned flags, struct event *ev, event_finalize_callback_fn cb)
{
    ev_uint8_t closure = (flags & EVENT_FINALIZE_FREE_) ?
                EV_CLOSURE_EVENT_FINALIZE_FREE : EV_CLOSURE_EVENT_FINALIZE;

    event_del_nolock_(ev, EVENT_DEL_NOBLOCK);
    ev->ev_closure = closure;
    ev->ev_evcallback.evcb_cb_union.evcb_evfinalize = cb;
    event_active_nolock_(ev, EV_FINALIZE, 1);
    ev->ev_flags |= EVLIST_FINALIZING;
    return 0;
}

static int
event_finalize_impl_(unsigned flags, struct event *ev, event_finalize_callback_fn cb)
{
    int r;
    struct event_base *base = ev->ev_base;
    if (EVUTIL_FAILURE_CHECK(!base)) {
        event_warnx("%s: event has no event_base set.", __func__);
        return -1;
    }

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    r = event_finalize_nolock_(base, flags, ev, cb);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return r;
}

int
event_finalize(unsigned flags, struct event *ev, event_finalize_callback_fn cb)
{
    return event_finalize_impl_(flags, ev, cb);
}

int
event_free_finalize(unsigned flags, struct event *ev, event_finalize_callback_fn cb)
{
    return event_finalize_impl_(flags|EVENT_FINALIZE_FREE_, ev, cb);
}

void
event_callback_finalize_nolock_(struct event_base *base, unsigned flags, struct event_callback *evcb, void (*cb)(struct event_callback *, void *))
{
    struct event *ev = NULL;
    if (evcb->evcb_flags & EVLIST_INIT) {
        ev = event_callback_to_event(evcb);
        event_del_nolock_(ev, EVENT_DEL_NOBLOCK);
    } else {
        event_callback_cancel_nolock_(base, evcb, 0); /*XXX can this fail?*/
    }

    evcb->evcb_closure = EV_CLOSURE_CB_FINALIZE;
    evcb->evcb_cb_union.evcb_cbfinalize = cb;
    event_callback_activate_nolock_(base, evcb); /* XXX can this really fail?*/
    evcb->evcb_flags |= EVLIST_FINALIZING;
}

void
event_callback_finalize_(struct event_base *base, unsigned flags, struct event_callback *evcb, void (*cb)(struct event_callback *, void *))
{
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    event_callback_finalize_nolock_(base, flags, evcb, cb);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

/** Internal: Finalize all of the n_cbs callbacks in evcbs.  The provided
 * callback will be invoked on *one of them*, after they have *all* been
 * finalized. */
int
event_callback_finalize_many_(struct event_base *base, int n_cbs, struct event_callback **evcbs, void (*cb)(struct event_callback *, void *))
{
    int n_pending = 0, i;

    if (base == NULL)
        base = current_base;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);

    event_debug(("%s: %d events finalizing", __func__, n_cbs));

    /* At most one can be currently executing; the rest we just
     * cancel... But we always make sure that the finalize callback
     * runs. */
    for (i = 0; i < n_cbs; ++i) {
        struct event_callback *evcb = evcbs[i];
        if (evcb == base->current_event) {
            event_callback_finalize_nolock_(base, 0, evcb, cb);
            ++n_pending;
        } else {
            event_callback_cancel_nolock_(base, evcb, 0);
        }
    }

    if (n_pending == 0) {
        /* Just do the first one. */
        event_callback_finalize_nolock_(base, 0, evcbs[0], cb);
    }

    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return 0;
}

/*
 * Set's the priority of an event - if an event is already scheduled
 * changing the priority is going to fail.
 */
// 设置event的优先级
// 高优先级的事件先运行,pri越小优先级越高
int
event_priority_set(struct event *ev, int pri)
{
    event_debug_assert_is_setup_(ev);

    // 不能对活跃的event设置优先级
    // 因此需要在调用event_base_dispatch函数之前使用
    if (ev->ev_flags & EVLIST_ACTIVE)
        return (-1);
    // 优先级不能越界
    if (pri < 0 || pri >= ev->ev_base->nactivequeues)
        return (-1);

    ev->ev_pri = pri;

    return (0);
}

/*
 * Checks if a specific event is pending or scheduled.
 */
// 检查事件ev是否处于未决或者激活状态
// 如果event包含EV_TIMEOUT 标志，则tv会保存事件的超时值
int
event_pending(const struct event *ev, short event, struct timeval *tv)
{
    int flags = 0;

    if (EVUTIL_FAILURE_CHECK(ev->ev_base == NULL)) {
        event_warnx("%s: event has no event_base set.", __func__);
        return 0;
    }

    EVBASE_ACQUIRE_LOCK(ev->ev_base, th_base_lock);
    event_debug_assert_is_setup_(ev);

    // flags记录用户监听了哪些事件
    if (ev->ev_flags & EVLIST_INSERTED)
        flags |= (ev->ev_events & (EV_READ|EV_WRITE|EV_CLOSED|EV_SIGNAL));
    // flags记录event被什么事件激活了.
    if (ev->ev_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER))
        flags |= ev->ev_res;
    // 记录该event是否还有超时属性
    if (ev->ev_flags & EVLIST_TIMEOUT)
        flags |= EV_TIMEOUT;

    // event可以被用户乱设值，然后作为参数。这里为了保证
    // 其值只能是下面的事件
    event &= (EV_TIMEOUT|EV_READ|EV_WRITE|EV_CLOSED|EV_SIGNAL);

    /* See if there is a timeout that we should report */
    if (tv != NULL && (flags & event & EV_TIMEOUT)) {
        struct timeval tmp = ev->ev_timeout;
        tmp.tv_usec &= MICROSECONDS_MASK;
        /* correctly remamp to real time */
        evutil_timeradd(&ev->ev_base->tv_clock_diff, &tmp, tv);
    }

    EVBASE_RELEASE_LOCK(ev->ev_base, th_base_lock);

    return (flags & event);
}

// 检测一个event是否处于已初始化状态
int
event_initialized(const struct event *ev)
{
    if (!(ev->ev_flags & EVLIST_INIT))
        return 0;

    return 1;
}

// 获取event的相关属性
void
event_get_assignment(const struct event *event, struct event_base **base_out, evutil_socket_t *fd_out, short *events_out, event_callback_fn *callback_out, void **arg_out)
{
    event_debug_assert_is_setup_(event);

    if (base_out)
        *base_out = event->ev_base;
    if (fd_out)
        *fd_out = event->ev_fd;
    if (events_out)
        *events_out = event->ev_events;
    if (callback_out)
        *callback_out = event->ev_callback;
    if (arg_out)
        *arg_out = event->ev_arg;
}

size_t
event_get_struct_event_size(void)
{
    return sizeof(struct event);
}

// 返回event监听的文件描述符fd
evutil_socket_t
event_get_fd(const struct event *ev)
{
    event_debug_assert_is_setup_(ev);
    return ev->ev_fd;
}

// 获取event所属的event_base
struct event_base *
        event_get_base(const struct event *ev)
{
    event_debug_assert_is_setup_(ev);
    return ev->ev_base;
}

// 获取该event监听的事件
short
event_get_events(const struct event *ev)
{
    event_debug_assert_is_setup_(ev);
    return ev->ev_events;
}

// 获取event回调函数的函数指针
event_callback_fn
event_get_callback(const struct event *ev)
{
    event_debug_assert_is_setup_(ev);
    return ev->ev_callback;
}

// 获取event的回调函数参数
void *
event_get_callback_arg(const struct event *ev)
{
    event_debug_assert_is_setup_(ev);
    return ev->ev_arg;
}

// 获取event对应的优先级
int
event_get_priority(const struct event *ev)
{
    event_debug_assert_is_setup_(ev);
    return ev->ev_pri;
}

// 在event_new或者event_assign之后执行,将非未决的event注册到base中，成为未决状态.
// 参数 ev：通过event_assign或者event_new初始化过的事件
// 参数 tv：等待事件执行的最长时间，如果NULL则从来不会超时，即永久等待
// 包括IO事件、信号事件、定时事件
// 定时事件：
//（1）最小堆：时间超时时间存储在最小堆，每次执行超时任务都从最小堆堆顶取任务执行
//（2）最小堆＋公用超时队列：相同超时的任务存储在同一个超时队列，每一个超时队列的队首事件存储在最小堆，
//    每次执行超时任务时都从最小堆堆顶取任务执行，然后遍历执行该任务所在公用超时队列中的所有超时任务
int
event_add(struct event *ev, const struct timeval *tv)
{
    int res;

    if (EVUTIL_FAILURE_CHECK(!ev->ev_base)) {
        event_warnx("%s: event has no event_base set.", __func__);
        return -1;
    }

    // 加锁
    EVBASE_ACQUIRE_LOCK(ev->ev_base, th_base_lock);

    res = event_add_nolock_(ev, tv, 0);

    // 解锁
    EVBASE_RELEASE_LOCK(ev->ev_base, th_base_lock);

    return (res);
}

/* Helper callback: wake an event_base from another thread.  This version
 * works by writing a byte to one end of a socketpair, so that the event_base
 * listening on the other end will wake up as the corresponding event
 * triggers */
// 往管道写入一个字节唤醒主线程
static int
evthread_notify_base_default(struct event_base *base)
{
    char buf[1];
    int r;
    buf[0] = (char) 0;
    // 写一个字节通知一下，用来唤醒
#ifdef _WIN32
    r = send(base->th_notify_fd[1], buf, 1, 0);
#else
    r = write(base->th_notify_fd[1], buf, 1);
#endif
    // 即使errno 等于 EAGAIN也无所谓，因为这是由于通信通道已经塞满了
    // 这已经能唤醒主线程了。没必要一定要再写入一个字节
    return (r < 0 && ! EVUTIL_ERR_IS_EAGAIN(errno)) ? -1 : 0;
}

#ifdef EVENT__HAVE_EVENTFD
/* Helper callback: wake an event_base from another thread.  This version
 * assumes that you have a working eventfd() implementation. */
static int
evthread_notify_base_eventfd(struct event_base *base)
{
    ev_uint64_t msg = 1;
    int r;
    do {
        r = write(base->th_notify_fd[0], (void*) &msg, sizeof(msg));
    } while (r < 0 && errno == EAGAIN);

    return (r < 0) ? -1 : 0;
}
#endif


/** Tell the thread currently running the event_loop for base (if any) that it
 * needs to stop waiting in its dispatch function (if it is) and process all
 * active callbacks. */
// 唤醒主线程，base->th_notify_fn完成实际的通知操作
static int
evthread_notify_base(struct event_base *base)
{
    // 确保已经加锁了
    EVENT_BASE_ASSERT_LOCKED(base);
    if (!base->th_notify_fn)
        return -1;
    // 写入一个字节，就能使event_base被唤醒。
    // 如果处于未决状态，就没必要写多一个字节
    if (base->is_notify_pending)
        return 0;
    // 通知处于未决状态，当event_base醒过来就变成已决的了
    base->is_notify_pending = 1;
    return base->th_notify_fn(base);
}

/* Implementation function to remove a timeout on a currently pending event.
 */
int
event_remove_timer_nolock_(struct event *ev)
{
    struct event_base *base = ev->ev_base;

    EVENT_BASE_ASSERT_LOCKED(base);
    event_debug_assert_is_setup_(ev);

    event_debug(("event_remove_timer_nolock: event: %p", ev));

    /* If it's not pending on a timeout, we don't need to do anything. */
    if (ev->ev_flags & EVLIST_TIMEOUT) {
        event_queue_remove_timeout(base, ev);
        evutil_timerclear(&ev->ev_.ev_io.ev_timeout);
    }

    return (0);
}

int
event_remove_timer(struct event *ev)
{
    int res;

    if (EVUTIL_FAILURE_CHECK(!ev->ev_base)) {
        event_warnx("%s: event has no event_base set.", __func__);
        return -1;
    }

    EVBASE_ACQUIRE_LOCK(ev->ev_base, th_base_lock);

    res = event_remove_timer_nolock_(ev);

    EVBASE_RELEASE_LOCK(ev->ev_base, th_base_lock);

    return (res);
}

/* Implementation function to add an event.  Works just like event_add,
 * except: 1) it requires that we have the lock.  2) if tv_is_absolute is set,
 * we treat tv as an absolute time, not as an interval to add to the current
 * time */
// 此函数真正实现将事件添加到event_base的等待列表中
// ev为要添加的事件；tv为超时时间；tv_is_absolute表示是绝对超时时间还是相对超时时间;
// 异常：1）它需要使用者加锁；2）如果tv_is_absolute设置了，则将tv作为绝对时间对待，而不是相对于当前添加时间的时间间隔
int
event_add_nolock_(struct event *ev, const struct timeval *tv,
                  int tv_is_absolute)
{
    struct event_base *base = ev->ev_base;
    int res = 0;
    int notify = 0;

    EVENT_BASE_ASSERT_LOCKED(base);
    event_debug_assert_is_setup_(ev);

    event_debug((
                    "event_add: event: %p (fd "EV_SOCK_FMT"), %s%s%s%scall %p",
                    ev,
                    EV_SOCK_ARG(ev->ev_fd),
                    ev->ev_events & EV_READ ? "EV_READ " : " ",
                    ev->ev_events & EV_WRITE ? "EV_WRITE " : " ",
                    ev->ev_events & EV_CLOSED ? "EV_CLOSED " : " ",
                    tv ? "EV_TIMEOUT " : " ",
                    ev->ev_callback));

    // 事件状态必须处于合法的某种事件状态，否则报错
    EVUTIL_ASSERT(!(ev->ev_flags & ~EVLIST_ALL));

    // 已经处于结束状态的事件再次添加会报错
    if (ev->ev_flags & EVLIST_FINALIZING) {
        /* XXXX debug */
        return (-1);
    }

    /*
     * prepare for timeout insertion further below, if we get a
     * failure on any step, we should not change any state.
     */
    // 如果传入了超时时间，且事件不在time min_heap堆中,
    // 则为将要插入的超时事件在小根堆上预留一个位置.
    // 防止出：事件状态改变已经完成，但是最小堆申请节点却失败；
    // 因此，如果在任何一步出现错误，都不能改变事件状态，这是前提条件
    if (tv != NULL && !(ev->ev_flags & EVLIST_TIMEOUT)) {
        if (min_heap_reserve_(&base->timeheap,
                              1 + min_heap_size_(&base->timeheap)) == -1)
            return (-1);  /* ENOMEM == errno */
    }

    /* If the main thread is currently executing a signal event's
     * callback, and we are not the main thread, then we want to wait
     * until the callback is done before we mess with the event, or else
     * we can race on ev_ncalls and ev_pncalls below. */
    // 如果主线程当前正在执行信号事件的回调函数，同时又不在主线程，则
    // 需要等待回调函数执行完毕才能继续添加事件，或者可能会在
    // ev_ncalls和ev_pncalls上产生竞争
#ifndef EVENT__DISABLE_THREAD_SUPPORT
    if (base->current_event == event_to_event_callback(ev) &&
            (ev->ev_events & EV_SIGNAL)
            && !EVBASE_IN_THREAD(base)) {
        ++base->current_event_waiters;
        EVTHREAD_COND_WAIT(base->current_event_cond, base->th_base_lock);
    }
#endif

    // 如果事件类型是IO事件／信号事件，同时事件状态不是已经插入／激活／下一次激活状态，
    // 则根据事件类型将事件添加到不同的映射表或者队列中
    if ((ev->ev_events & (EV_READ|EV_WRITE|EV_CLOSED|EV_SIGNAL)) &&
            !(ev->ev_flags & (EVLIST_INSERTED|EVLIST_ACTIVE|EVLIST_ACTIVE_LATER))) {
        // 如果事件是IO事件，则将事件插入到IO事件与文件描述符的映射表中
        if (ev->ev_events & (EV_READ|EV_WRITE|EV_CLOSED))
            res = evmap_io_add_(base, ev->ev_fd, ev);
        // 如果事件是信号事件，则将事件插入信号与文件描述符的映射表中
        else if (ev->ev_events & EV_SIGNAL)
            res = evmap_signal_add_(base, (int)ev->ev_fd, ev);
        // 如果上述添加行为正确，则标明事件在已注册事件列表中
        if (res != -1)
            event_queue_insert_inserted(base, ev);
        // 如果上述添加行为正确，则设置通知主线程的标志，因为已经添加了新事件，
        // 1）防止优先级高的事件被优先级低的事件倒挂，2）防止主线程忙等，会通知主线程有新事件
        if (res == 1) {
            /* evmap says we need to notify the main thread. */
            notify = 1;
            res = 0;
        }
    }

    /*
     * we should change the timeout state only if the previous event
     * addition succeeded.
     */
    // 只有当前面事件条件成功执行之后，才能改变超时状态
    if (res != -1 && tv != NULL) {
        struct timeval now;
        int common_timeout;
#ifdef USE_REINSERT_TIMEOUT
        int was_common;
        int old_timeout_idx;
#endif

        /*
         * for persistent timeout events, we remember the
         * timeout value and re-add the event.
         *
         * If tv_is_absolute, this was already set.
         */
        // 对于持久化的定时事件，需要记住超时时间，并重新注册事件
        // 如果tv_is_absolute设置，则事件超时时间就等于输入时间参数
        if (ev->ev_closure == EV_CLOSURE_EVENT_PERSIST && !tv_is_absolute)
            ev->ev_io_timeout = *tv;

#ifndef USE_REINSERT_TIMEOUT
        // 如果没有使用USE_REINSERT_TIMEOUT，则当事件处于超时状态时，需要从队列中移除事件
        // 因为同样的事件不能重新插入，所以当一个事件已经处于超时状态时，为防止执行，需要先移除后插入
        if (ev->ev_flags & EVLIST_TIMEOUT) {
            event_queue_remove_timeout(base, ev);
        }
#endif

        /* Check if it is active due to a timeout.  Rescheduling
         * this timeout before the callback can be executed
         * removes it from the active list. */
        // 如果事件是由于超时而变成活跃事件,则在回调函数执行之前，
        // 需要重新调度这个超时事件，因此需要把它移出激活队列
        if ((ev->ev_flags & EVLIST_ACTIVE) &&
                (ev->ev_res & EV_TIMEOUT)) {
            if (ev->ev_events & EV_SIGNAL) {
                /* See if we are just active executing
                 * this event in a loop
                 */
                if (ev->ev_ncalls && ev->ev_pncalls) {
                    /* Abort loop */
                    *ev->ev_pncalls = 0;
                }
            }

            // 将此事件的回调函数从活跃事件链表移除
            event_queue_remove_active(base, event_to_event_callback(ev));
        }

        // 获取base中的缓存时间
        gettime(base, &now);

        // 检查base是否使用了公用超时队列机制
        common_timeout = is_common_timeout(tv, base);
#ifdef USE_REINSERT_TIMEOUT
        was_common = is_common_timeout(&ev->ev_timeout, base);
        old_timeout_idx = COMMON_TIMEOUT_IDX(&ev->ev_timeout);
#endif

        // 1）如果传入的tv是绝对超时时间，则直接保存该时间
        // 2）如果使用的公用超时队列机制，则根据当前base中时间和输入超时时间间隔计算出时间超时时间，并对超时时间进行公用超时掩码计算
        // 3）如果是其他情况，则直接根据base中时间和输入相对超时时间间隔计算事件的绝对超时时间
        if (tv_is_absolute) {
            ev->ev_timeout = *tv;
        } else if (common_timeout) {
            struct timeval tmp = *tv;
            // 获取真正的us时间部分
            tmp.tv_usec &= MICROSECONDS_MASK;
            // 参照时间 + 相对时间 = ev_timeout存的是绝对时间
            evutil_timeradd(&now, &tmp, &ev->ev_timeout);
            // 加入标志位
            ev->ev_timeout.tv_usec |=
                    (tv->tv_usec & ~MICROSECONDS_MASK);
        } else {
            evutil_timeradd(&now, tv, &ev->ev_timeout);
        }

        event_debug((
                        "event_add: event %p, timeout in %d seconds %d useconds, call %p",
                        ev, (int)tv->tv_sec, (int)tv->tv_usec, ev->ev_callback));

#ifdef USE_REINSERT_TIMEOUT
        // 会插入两个队列：一个是公用超时队列，一个超时队列
        event_queue_reinsert_timeout(base, ev, was_common, common_timeout, old_timeout_idx);
#else
        // 决定该超时事件是插入到最小堆还是超时common_timeout队列当中
        event_queue_insert_timeout(base, ev);
#endif

        // 如果使用了公用超时队列机制，则需要根据当前事件的超时时间将当前事件插入具有相同超时时间的时间列表
        if (common_timeout) {
            // 根据事件超时时间获取应该插入的公用超时队列，注意此处是从队尾插入
            struct common_timeout_list *ctl =
                    get_common_timeout_list(base, &ev->ev_timeout);
            // 如果当前事件是公用超时队列的第一个事件，则需要将此超时事件作为代表插入最小堆
            // 解释：公用超时队列机制：处于同一个公用超时队列中的所有事件具有相同的超时控制，因此只需要将公用超时队列
            // 的第一个事件插入最小堆，当超时触发时，可以通过遍历公用超时队列获取同样的超时事件
            if (ev == TAILQ_FIRST(&ctl->events)) {
                common_timeout_schedule(ctl, &now, ev);
            }
        } else {
            // 如果没有使用公用超时队列，则调整最小堆
            struct event* top = NULL;
            /* See if the earliest timeout is now earlier than it
             * was before: if so, we will need to tell the main
             * thread to wake up earlier than it would otherwise.
             * We double check the timeout of the top element to
             * handle time distortions due to system suspension.
             */
            // 查看当前事件是否就是最小堆根部，如果是，则需要通知主线程
            // 否则，需要查看最小堆根部超时时间是否已经小于当前时间，即已经超时了，如果是，则需要通知主线程
            if (min_heap_elt_is_top_(ev))
                notify = 1;
            else if ((top = min_heap_top_(&base->timeheap)) != NULL &&
                     evutil_timercmp(&top->ev_timeout, &now, <))
                notify = 1;
        }
    }

    /* if we are not in the right thread, we need to wake up the loop */
    // 通知主线程
    if (res != -1 && notify && EVBASE_NEED_NOTIFY(base))
        evthread_notify_base(base);

    event_debug_note_add_(ev);

    return (res);
}

// 内部删除事件函数
// 将使event成为非未决和非激活的
static int
event_del_(struct event *ev, int blocking)
{
    int res;

    if (EVUTIL_FAILURE_CHECK(!ev->ev_base)) {
        event_warnx("%s: event has no event_base set.", __func__);
        return -1;
    }

    EVBASE_ACQUIRE_LOCK(ev->ev_base, th_base_lock);

    res = event_del_nolock_(ev, blocking);

    EVBASE_RELEASE_LOCK(ev->ev_base, th_base_lock);

    return (res);
}

// 从一系列监听的事件中移除事件，函数event_del将取消参数ev中的event。
// 如果event已经执行或者还没有添加成功，则此调用无效
int
event_del(struct event *ev)
{
    return event_del_(ev, EVENT_DEL_AUTOBLOCK);
}

int
event_del_block(struct event *ev)
{
    return event_del_(ev, EVENT_DEL_BLOCK);
}

int
event_del_noblock(struct event *ev)
{
    return event_del_(ev, EVENT_DEL_NOBLOCK);
}

/** Helper for event_del: always called with th_base_lock held.
 *
 * "blocking" must be one of the EVENT_DEL_{BLOCK, NOBLOCK, AUTOBLOCK,
 * EVEN_IF_FINALIZING} values. See those for more information.
 */
// 事件删除的内部实现，不加锁；
// 需要根据事件状态判断是否能够执行删除行为；
// 需要根据事件类型决定删除的具体操作；
int
event_del_nolock_(struct event *ev, int blocking)
{
    struct event_base *base;
    int res = 0, notify = 0;

    event_debug(("event_del: %p (fd "EV_SOCK_FMT"), callback %p",
                 ev, EV_SOCK_ARG(ev->ev_fd), ev->ev_callback));

    /* An event without a base has not been added */
    if (ev->ev_base == NULL)
        return (-1);

    EVENT_BASE_ASSERT_LOCKED(ev->ev_base);

    // 如果事件已经处于结束中的状态，则不需要重复删除
    if (blocking != EVENT_DEL_EVEN_IF_FINALIZING) {
        if (ev->ev_flags & EVLIST_FINALIZING) {
            /* XXXX Debug */
            return 0;
        }
    }

    /* If the main thread is currently executing this event's callback,
     * and we are not the main thread, then we want to wait until the
     * callback is done before we start removing the event.  That way,
     * when this function returns, it will be safe to free the
     * user-supplied argument. */
    base = ev->ev_base;
#ifndef EVENT__DISABLE_THREAD_SUPPORT
    // 如果主线程当前正在执行此事件的回调，并且我们不是主线程，
    // 那么我们要等到回调完成后再开始删除事件
    if (blocking != EVENT_DEL_NOBLOCK &&
            base->current_event == event_to_event_callback(ev) &&
            !EVBASE_IN_THREAD(base) &&
            (blocking == EVENT_DEL_BLOCK || !(ev->ev_events & EV_FINALIZE))) {
        ++base->current_event_waiters;
        EVTHREAD_COND_WAIT(base->current_event_cond, base->th_base_lock);
    }
#endif

    EVUTIL_ASSERT(!(ev->ev_flags & ~EVLIST_ALL));

    /* See if we are just active executing this event in a loop */
    // 如果是信号事件，同时信号触发事件不为0，则放弃执行这些回调函数
    if (ev->ev_events & EV_SIGNAL) {
        if (ev->ev_ncalls && ev->ev_pncalls) {
            /* Abort loop */
            *ev->ev_pncalls = 0;
        }
    }

    // 如果是超时事件，则从超时队列中移除事件
    if (ev->ev_flags & EVLIST_TIMEOUT) {
        /* NOTE: We never need to notify the main thread because of a
         * deleted timeout event: all that could happen if we don't is
         * that the dispatch loop might wake up too early.  But the
         * point of notifying the main thread _is_ to wake up the
         * dispatch loop early anyway, so we wouldn't gain anything by
         * doing it.
         */
        event_queue_remove_timeout(base, ev);
    }

    // 如果事件正处于激活状态，则需要将事件的回调函数从激活队列中删除
    // 如果事件正处于下一次激活状态，则需要将事件的回调函数从下一次激活队列中删除
    if (ev->ev_flags & EVLIST_ACTIVE)
        event_queue_remove_active(base, event_to_event_callback(ev));
    else if (ev->ev_flags & EVLIST_ACTIVE_LATER)
        event_queue_remove_active_later(base, event_to_event_callback(ev));

    // 如果事件正处于已插入状态，则需要将事件从已插入状态队列中删除
    if (ev->ev_flags & EVLIST_INSERTED) {
        event_queue_remove_inserted(base, ev);
        // 如果事件是IO事件，则将事件从IO映射中删除
        // 如果是信号事件，则将信号从信号映射删除
        // 如果删除正确，则需要通知主线程
        if (ev->ev_events & (EV_READ|EV_WRITE|EV_CLOSED))
            res = evmap_io_del_(base, ev->ev_fd, ev);
        else
            res = evmap_signal_del_(base, (int)ev->ev_fd, ev);
        if (res == 1) {
            /* evmap says we need to notify the main thread. */
            notify = 1;
            res = 0;
        }
    }

    /* if we are not in the right thread, we need to wake up the loop */
    // 可能需要通知主线程
    if (res != -1 && notify && EVBASE_NEED_NOTIFY(base))
        evthread_notify_base(base);

    event_debug_note_del_(ev);

    return (res);
}

// 可以手动地把一个event激活
// 否则需要event_base_dispatch死等外界条件把event激活外
// res是激活的原因，是诸如EV_READ EV_TIMEOUT之类的宏.
// ncalls只对EV_SIGNAL信号有用，表示信号的次数
void
event_active(struct event *ev, int res, short ncalls)
{
    if (EVUTIL_FAILURE_CHECK(!ev->ev_base)) {
        event_warnx("%s: event has no event_base set.", __func__);
        return;
    }

    EVBASE_ACQUIRE_LOCK(ev->ev_base, th_base_lock);

    event_debug_assert_is_setup_(ev);

    event_active_nolock_(ev, res, ncalls);

    EVBASE_RELEASE_LOCK(ev->ev_base, th_base_lock);
}

// 激活指定类型的事件,实际上就是将事件的回调函数放入激活队列
// ev：激活的事件
// res：激活的事件类型
// ncalls：该事件需要激活的次数，主要是应对信号事件，某些信号事件可能会注册多次，所以需要激活多次
void
event_active_nolock_(struct event *ev, int res, short ncalls)
{
    struct event_base *base;

    event_debug(("event_active: %p (fd "EV_SOCK_FMT"), res %d, callback %p",
                 ev, EV_SOCK_ARG(ev->ev_fd), (int)res, ev->ev_callback));

    base = ev->ev_base;
    EVENT_BASE_ASSERT_LOCKED(base);

    if (ev->ev_flags & EVLIST_FINALIZING) {
        /* XXXX debug */
        return;
    }

    // 记录当前激活事件的类型
    switch ((ev->ev_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER))) {
    default:
    case EVLIST_ACTIVE|EVLIST_ACTIVE_LATER:
        EVUTIL_ASSERT(0);
        break;
    case EVLIST_ACTIVE:
        /* We get different kinds of events, add them together */
        ev->ev_res |= res;
        return;
    case EVLIST_ACTIVE_LATER:
        ev->ev_res |= res;
        break;
    case 0:
        ev->ev_res = res;
        break;
    }

    // 这将停止处理低优先级的event。一路回退到event_base_loop中
    if (ev->ev_pri < base->event_running_priority)
        base->event_continue = 1;

    // 如果是信号事件，则需要设置调用次数
    if (ev->ev_events & EV_SIGNAL) {
#ifndef EVENT__DISABLE_THREAD_SUPPORT
        if (base->current_event == event_to_event_callback(ev) &&
                !EVBASE_IN_THREAD(base)) {
            ++base->current_event_waiters;
            EVTHREAD_COND_WAIT(base->current_event_cond, base->th_base_lock);
        }
#endif
        ev->ev_ncalls = ncalls;
        ev->ev_pncalls = NULL;
    }

    // 激活事件实际上就是将事件的回调函数放入激活队列
    event_callback_activate_nolock_(base, event_to_event_callback(ev));
}

void
event_active_later_(struct event *ev, int res)
{
    EVBASE_ACQUIRE_LOCK(ev->ev_base, th_base_lock);
    event_active_later_nolock_(ev, res);
    EVBASE_RELEASE_LOCK(ev->ev_base, th_base_lock);
}

void
event_active_later_nolock_(struct event *ev, int res)
{
    struct event_base *base = ev->ev_base;
    EVENT_BASE_ASSERT_LOCKED(base);

    if (ev->ev_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER)) {
        /* We get different kinds of events, add them together */
        ev->ev_res |= res;
        return;
    }

    ev->ev_res = res;

    event_callback_activate_later_nolock_(base, event_to_event_callback(ev));
}

int
event_callback_activate_(struct event_base *base,
                         struct event_callback *evcb)
{
    int r;
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    r = event_callback_activate_nolock_(base, evcb);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return r;
}

// 将事件的回调函数放入激活队列
int
event_callback_activate_nolock_(struct event_base *base,
                                struct event_callback *evcb)
{
    int r = 1;

    // 合法状态检查
    if (evcb->evcb_flags & EVLIST_FINALIZING)
        return 0;

    switch (evcb->evcb_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER)) {
    default:
        EVUTIL_ASSERT(0);
    case EVLIST_ACTIVE_LATER:
        // 如果事件状态为EVLIST_ACTIVE_LATER，则将回调函数从下一次激活队列中移除,
        // 后面再插入激活队列中
        event_queue_remove_active_later(base, evcb);
        r = 0;
        break;
    case EVLIST_ACTIVE:
        return 0;
    case 0:
        break;
    }

    // 将回调函数插入激活队列
    event_queue_insert_active(base, evcb);

    // 如果执行激活动作的线程不是主线程,则唤醒主线程,使得主线程能赶快处理激活event
    if (EVBASE_NEED_NOTIFY(base))
        evthread_notify_base(base);

    return r;
}

int
event_callback_activate_later_nolock_(struct event_base *base,
                                      struct event_callback *evcb)
{
    if (evcb->evcb_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER))
        return 0;

    event_queue_insert_active_later(base, evcb);
    if (EVBASE_NEED_NOTIFY(base))
        evthread_notify_base(base);
    return 1;
}

void
event_callback_init_(struct event_base *base,
                     struct event_callback *cb)
{
    memset(cb, 0, sizeof(*cb));
    cb->evcb_pri = base->nactivequeues - 1;
}

int
event_callback_cancel_(struct event_base *base,
                       struct event_callback *evcb)
{
    int r;
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    r = event_callback_cancel_nolock_(base, evcb, 0);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return r;
}

int
event_callback_cancel_nolock_(struct event_base *base,
                              struct event_callback *evcb, int even_if_finalizing)
{
    if ((evcb->evcb_flags & EVLIST_FINALIZING) && !even_if_finalizing)
        return 0;

    if (evcb->evcb_flags & EVLIST_INIT)
        return event_del_nolock_(event_callback_to_event(evcb),
                                 even_if_finalizing ? EVENT_DEL_EVEN_IF_FINALIZING : EVENT_DEL_AUTOBLOCK);

    switch ((evcb->evcb_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER))) {
    default:
    case EVLIST_ACTIVE|EVLIST_ACTIVE_LATER:
        EVUTIL_ASSERT(0);
        break;
    case EVLIST_ACTIVE:
        /* We get different kinds of events, add them together */
        event_queue_remove_active(base, evcb);
        return 0;
    case EVLIST_ACTIVE_LATER:
        event_queue_remove_active_later(base, evcb);
        break;
    case 0:
        break;
    }

    return 0;
}

void
event_deferred_cb_init_(struct event_callback *cb, ev_uint8_t priority, deferred_cb_fn fn, void *arg)
{
    memset(cb, 0, sizeof(*cb));
    cb->evcb_cb_union.evcb_selfcb = fn;
    cb->evcb_arg = arg;
    cb->evcb_pri = priority;
    cb->evcb_closure = EV_CLOSURE_CB_SELF;
}

void
event_deferred_cb_set_priority_(struct event_callback *cb, ev_uint8_t priority)
{
    cb->evcb_pri = priority;
}

void
event_deferred_cb_cancel_(struct event_base *base, struct event_callback *cb)
{
    if (!base)
        base = current_base;
    event_callback_cancel_(base, cb);
}

#define MAX_DEFERREDS_QUEUED 32
int
event_deferred_cb_schedule_(struct event_base *base, struct event_callback *cb)
{
    int r = 1;
    if (!base)
        base = current_base;
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    if (base->n_deferreds_queued > MAX_DEFERREDS_QUEUED) {
        r = event_callback_activate_later_nolock_(base, cb);
    } else {
        r = event_callback_activate_nolock_(base, cb);
        if (r) {
            ++base->n_deferreds_queued;
        }
    }
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return r;
}

// 获取下一个要等待的超时间隔存于tv_p
static int
timeout_next(struct event_base *base, struct timeval **tv_p)
{
    /* Caller must hold th_base_lock */
    struct timeval now;
    struct event *ev;
    struct timeval *tv = *tv_p;
    int res = 0;

    // 获取最小堆根部事件，如果为空，则返回
    ev = min_heap_top_(&base->timeheap);

    // 堆中没有元素
    if (ev == NULL) {
        /* if no time-based events are active wait for I/O */
        *tv_p = NULL;
        goto out;
    }

    // 获取base中现在的时间，如果base中时间为空，则获取现在系统中的时间
    if (gettime(base, &now) == -1) {
        res = -1;
        goto out;
    }

    // 比较最小堆堆顶和当前base中的时间，如果超时时间<=当前时间，则表明已经超时，不能等待，需要立即返回；
    // 如果超时时间>当前时间，表明超时时间还没到，将(超时时间－当前时间)的结果存储在tv中
    if (evutil_timercmp(&ev->ev_timeout, &now, <=)) {
        // 清零，这样可以让dispatcht不会等待，马上返回
        evutil_timerclear(tv);
        goto out;
    }
    // 计算等待的时间=小根堆时间-当前的时间
    evutil_timersub(&ev->ev_timeout, &now, tv);

    EVUTIL_ASSERT(tv->tv_sec >= 0);
    EVUTIL_ASSERT(tv->tv_usec >= 0);
    event_debug(("timeout_next: event: %p, in %d seconds, %d useconds", ev, (int)tv->tv_sec, (int)tv->tv_usec));

out:
    return (res);
}

/* Activate every event whose timeout has elapsed. */
// 将超时事件放入激活队列，并设置激活原因为EV_TIMEOUT
static void
timeout_process(struct event_base *base)
{
    /* Caller must hold lock. */
    struct timeval now;
    struct event *ev;

    // 如果超时最小堆为空，则没有超时事件，直接返回即可
    if (min_heap_empty_(&base->timeheap)) {
        return;
    }

    // 获取当前base中的时间，用于下面比较超时事件是否超时
    gettime(base, &now);

    // 遍历最小堆，如果最小堆中超时事件没有超时的，则退出循环；
    // 如果有超时的事件，则先将超时事件移除，然后激活超时事件设置原因EV_TIMEOUT；
    // 先将超时事件移除的原因是：事件已超时，所以需要激活，就不需要继续监控了；
    // 还有就是对于永久性EV_PERSIST监控的事件，可以在执行事件时重新加入到监控队列中，重新配置超时时间
    while ((ev = min_heap_top_(&base->timeheap))) {
        // 超时时间比此刻时间大，说明该event还没超时。那么余下的小根堆元素更不用检查了
        if (evutil_timercmp(&ev->ev_timeout, &now, >))
            break;

        /* delete this event from the I/O queues */
        event_del_nolock_(ev, EVENT_DEL_NOBLOCK);

        event_debug(("timeout_process: event: %p, call %p",
                     ev, ev->ev_callback));
        event_active_nolock_(ev, EV_TIMEOUT, 1);
    }
}

#if (EVLIST_INTERNAL >> 4) != 1
#error "Mismatch for value of EVLIST_INTERNAL"
#endif

#ifndef MAX
#define MAX(a,b) (((a)>(b))?(a):(b))
#endif

#define MAX_EVENT_COUNT(var, v) var = MAX(var, v)

/* These are a fancy way to spell
     if (flags & EVLIST_INTERNAL)
         base->event_count--/++;
*/
#define DECR_EVENT_COUNT(base,flags) \
    ((base)->event_count -= (~((flags) >> 4) & 1))
#define INCR_EVENT_COUNT(base,flags) do {					\
    ((base)->event_count += (~((flags) >> 4) & 1));				\
    MAX_EVENT_COUNT((base)->event_count_max, (base)->event_count);		\
    } while (0)

static void
event_queue_remove_inserted(struct event_base *base, struct event *ev)
{
    EVENT_BASE_ASSERT_LOCKED(base);
    if (EVUTIL_FAILURE_CHECK(!(ev->ev_flags & EVLIST_INSERTED))) {
        event_errx(1, "%s: %p(fd "EV_SOCK_FMT") not on queue %x", __func__,
                   ev, EV_SOCK_ARG(ev->ev_fd), EVLIST_INSERTED);
        return;
    }
    DECR_EVENT_COUNT(base, ev->ev_flags);
    ev->ev_flags &= ~EVLIST_INSERTED;
}
// 从base维护的激活事件列表中删除事件的回调函数
static void
event_queue_remove_active(struct event_base *base, struct event_callback *evcb)
{
    EVENT_BASE_ASSERT_LOCKED(base);
    if (EVUTIL_FAILURE_CHECK(!(evcb->evcb_flags & EVLIST_ACTIVE))) {
        event_errx(1, "%s: %p not on queue %x", __func__,
                   evcb, EVLIST_ACTIVE);
        return;
    }
    // base中事件个数－1，同时设置事件回调函数状态为非激活状态
    // 同时base中激活事件个数－1
    DECR_EVENT_COUNT(base, evcb->evcb_flags);
    evcb->evcb_flags &= ~EVLIST_ACTIVE;
    base->event_count_active--;

    // 将base中激活队列中该事件的回调函数删除即可
    TAILQ_REMOVE(&base->activequeues[evcb->evcb_pri],
            evcb, evcb_active_next);
}
static void
event_queue_remove_active_later(struct event_base *base, struct event_callback *evcb)
{
    EVENT_BASE_ASSERT_LOCKED(base);
    if (EVUTIL_FAILURE_CHECK(!(evcb->evcb_flags & EVLIST_ACTIVE_LATER))) {
        event_errx(1, "%s: %p not on queue %x", __func__,
                   evcb, EVLIST_ACTIVE_LATER);
        return;
    }
    DECR_EVENT_COUNT(base, evcb->evcb_flags);
    evcb->evcb_flags &= ~EVLIST_ACTIVE_LATER;
    base->event_count_active--;

    TAILQ_REMOVE(&base->active_later_queue, evcb, evcb_active_next);
}

// 从公用超时队列或最小堆中删除超时事件
static void
event_queue_remove_timeout(struct event_base *base, struct event *ev)
{
    EVENT_BASE_ASSERT_LOCKED(base);
    if (EVUTIL_FAILURE_CHECK(!(ev->ev_flags & EVLIST_TIMEOUT))) {
        event_errx(1, "%s: %p(fd "EV_SOCK_FMT") not on queue %x", __func__,
                   ev, EV_SOCK_ARG(ev->ev_fd), EVLIST_TIMEOUT);
        return;
    }
    // base中事件数量－1，同时设置事件状态为非超时状态
    DECR_EVENT_COUNT(base, ev->ev_flags);
    ev->ev_flags &= ~EVLIST_TIMEOUT;

    // 如果使用了公用超时队列，则找到待删除事件所在公用超时队列，
    // 然后删除公用超时队列
    // 如果使用最小堆，则将事件从最小堆删除即可
    if (is_common_timeout(&ev->ev_timeout, base)) {
        struct common_timeout_list *ctl =
                get_common_timeout_list(base, &ev->ev_timeout);
        TAILQ_REMOVE(&ctl->events, ev,
                     ev_timeout_pos.ev_next_with_common_timeout);
    } else {
        min_heap_erase_(&base->timeheap, ev);
    }
}

#ifdef USE_REINSERT_TIMEOUT
/* Remove and reinsert 'ev' into the timeout queue. */
static void
event_queue_reinsert_timeout(struct event_base *base, struct event *ev,
                             int was_common, int is_common, int old_timeout_idx)
{
    struct common_timeout_list *ctl;
    if (!(ev->ev_flags & EVLIST_TIMEOUT)) {
        event_queue_insert_timeout(base, ev);
        return;
    }

    switch ((was_common<<1) | is_common) {
    case 3: /* Changing from one common timeout to another */
        ctl = base->common_timeout_queues[old_timeout_idx];
        TAILQ_REMOVE(&ctl->events, ev,
                     ev_timeout_pos.ev_next_with_common_timeout);
        ctl = get_common_timeout_list(base, &ev->ev_timeout);
        insert_common_timeout_inorder(ctl, ev);
        break;
    case 2: /* Was common; is no longer common */
        ctl = base->common_timeout_queues[old_timeout_idx];
        TAILQ_REMOVE(&ctl->events, ev,
                     ev_timeout_pos.ev_next_with_common_timeout);
        min_heap_push_(&base->timeheap, ev);
        break;
    case 1: /* Wasn't common; has become common. */
        min_heap_erase_(&base->timeheap, ev);
        ctl = get_common_timeout_list(base, &ev->ev_timeout);
        insert_common_timeout_inorder(ctl, ev);
        break;
    case 0: /* was in heap; is still on heap. */
        min_heap_adjust_(&base->timeheap, ev);
        break;
    default:
        EVUTIL_ASSERT(0); /* unreachable */
        break;
    }
}
#endif

/* Add 'ev' to the common timeout list in 'ev'. */
static void
insert_common_timeout_inorder(struct common_timeout_list *ctl,
                              struct event *ev)
{
    struct event *e;
    /* By all logic, we should just be able to append 'ev' to the end of
     * ctl->events, since the timeout on each 'ev' is set to {the common
     * timeout} + {the time when we add the event}, and so the events
     * should arrive in order of their timeeouts.  But just in case
     * there's some wacky threading issue going on, we do a search from
     * the end of 'ev' to find the right insertion point.
     */
    //虽然有相同超时时长，但超时时间却是 超时时长 + 调用event_add的时间。
    //所以是在不同的时间触发超时的。它们根据绝对超时时间，升序排在队列中。
    //一般来说，直接插入队尾即可。因为后插入的，绝对超时时间肯定大。
    //但由于线程抢占的原因，可能一个线程在evutil_timeradd(&now, &tmp, &ev->ev_timeout);
    //执行完，还没来得及插入，就被另外一个线程抢占了。而这个线程也是要插入一个
    //common-timeout的超时event。这样就会发生：超时时间小的反而后插入。
    //所以要从后面开始遍历队列，寻找一个合适的地方
    TAILQ_FOREACH_REVERSE(e, &ctl->events,
                          event_list, ev_timeout_pos.ev_next_with_common_timeout) {
        /* This timercmp is a little sneaky, since both ev and e have
         * magic values in tv_usec.  Fortunately, they ought to have
         * the _same_ magic values in tv_usec.  Let's assert for that.
         */
        EVUTIL_ASSERT(
                    is_same_common_timeout(&e->ev_timeout, &ev->ev_timeout));
        if (evutil_timercmp(&ev->ev_timeout, &e->ev_timeout, >=)) {
            //从队列后面插入，返回
            TAILQ_INSERT_AFTER(&ctl->events, e, ev,
                               ev_timeout_pos.ev_next_with_common_timeout);
            return;
        }
    }
    // 在队列头插入，只会发生在前面都没有寻找到的情况下
    TAILQ_INSERT_HEAD(&ctl->events, ev,
                      ev_timeout_pos.ev_next_with_common_timeout);
}

// 标明event在已注册事件链表中
static void
event_queue_insert_inserted(struct event_base *base, struct event *ev)
{
    EVENT_BASE_ASSERT_LOCKED(base);

    if (EVUTIL_FAILURE_CHECK(ev->ev_flags & EVLIST_INSERTED)) {
        event_errx(1, "%s: %p(fd "EV_SOCK_FMT") already inserted", __func__,
                   ev, EV_SOCK_ARG(ev->ev_fd));
        return;
    }

    INCR_EVENT_COUNT(base, ev->ev_flags);

    ev->ev_flags |= EVLIST_INSERTED;
}

// 将回调函数插入激活队列
static void
event_queue_insert_active(struct event_base *base, struct event_callback *evcb)
{
    EVENT_BASE_ASSERT_LOCKED(base);

    if (evcb->evcb_flags & EVLIST_ACTIVE) {
        /* Double insertion is possible for active events */
        return;
    }

    // 增加base中事件数量，并设置回调函数的执行状态为激活状态
    INCR_EVENT_COUNT(base, evcb->evcb_flags);
    evcb->evcb_flags |= EVLIST_ACTIVE;

    // 激活事件数量增加，并将激活事件回调函数插入所在优先级队列中
    base->event_count_active++;
    MAX_EVENT_COUNT(base->event_count_active_max, base->event_count_active);
    EVUTIL_ASSERT(evcb->evcb_pri < base->nactivequeues);
    TAILQ_INSERT_TAIL(&base->activequeues[evcb->evcb_pri],
            evcb, evcb_active_next);
}

static void
event_queue_insert_active_later(struct event_base *base, struct event_callback *evcb)
{
    EVENT_BASE_ASSERT_LOCKED(base);
    if (evcb->evcb_flags & (EVLIST_ACTIVE_LATER|EVLIST_ACTIVE)) {
        /* Double insertion is possible */
        return;
    }

    INCR_EVENT_COUNT(base, evcb->evcb_flags);
    evcb->evcb_flags |= EVLIST_ACTIVE_LATER;
    base->event_count_active++;
    MAX_EVENT_COUNT(base->event_count_active_max, base->event_count_active);
    EVUTIL_ASSERT(evcb->evcb_pri < base->nactivequeues);
    TAILQ_INSERT_TAIL(&base->active_later_queue, evcb, evcb_active_next);
}

// 决定超时事件是插入到最小堆还是超时common_timeout队列当中
static void
event_queue_insert_timeout(struct event_base *base, struct event *ev)
{
    EVENT_BASE_ASSERT_LOCKED(base);

    if (EVUTIL_FAILURE_CHECK(ev->ev_flags & EVLIST_TIMEOUT)) {
        event_errx(1, "%s: %p(fd "EV_SOCK_FMT") already on timeout", __func__,
                   ev, EV_SOCK_ARG(ev->ev_fd));
        return;
    }

    INCR_EVENT_COUNT(base, ev->ev_flags);

    ev->ev_flags |= EVLIST_TIMEOUT;

    // 决定是插入到最小堆还是超时common_timeout队列当中
    if (is_common_timeout(&ev->ev_timeout, base)) {
        // 根据时间向event_base获取对应的common_timeout_list
        struct common_timeout_list *ctl =
                get_common_timeout_list(base, &ev->ev_timeout);
        insert_common_timeout_inorder(ctl, ev);
    } else {
        min_heap_push_(&base->timeheap, ev);
    }
}

// 主要是将下一次激活事件队列中的事件都移动到激活队列中
static void
event_queue_make_later_events_active(struct event_base *base)
{
    struct event_callback *evcb;
    EVENT_BASE_ASSERT_LOCKED(base);

    // 判断下一次激活队列中是否还存在回调事件，如果存在，则将回调事件状态增加激活状态，
    // 然后将该回调事件插入对应优先级的激活队列中，并将推迟的事件总数＋1
    while ((evcb = TAILQ_FIRST(&base->active_later_queue))) {
        TAILQ_REMOVE(&base->active_later_queue, evcb, evcb_active_next);
        evcb->evcb_flags = (evcb->evcb_flags & ~EVLIST_ACTIVE_LATER) | EVLIST_ACTIVE;
        EVUTIL_ASSERT(evcb->evcb_pri < base->nactivequeues);
        TAILQ_INSERT_TAIL(&base->activequeues[evcb->evcb_pri], evcb, evcb_active_next);
        base->n_deferreds_queued += (evcb->evcb_closure == EV_CLOSURE_CB_SELF);
    }
}

/* Functions for debugging */

const char *
event_get_version(void)
{
    return (EVENT__VERSION);
}

ev_uint32_t
event_get_version_number(void)
{
    return (EVENT__NUMERIC_VERSION);
}

/*
 * No thread-safe interface needed - the information should be the same
 * for all threads.
 */

const char *
event_get_method(void)
{
    return (current_base->evsel->name);
}

// 由用户定义的全局内存定制的函数，初始为NULL
#ifndef EVENT__DISABLE_MM_REPLACEMENT
static void *(*mm_malloc_fn_)(size_t sz) = NULL;
static void *(*mm_realloc_fn_)(void *p, size_t sz) = NULL;
static void (*mm_free_fn_)(void *p) = NULL;

// 如果用户定制了内存分配函数(mm_malloc_fn_不为NULL)，
// 那么就直接调用用户定制的内存分配函数,否则使用C语言标准库提供的
void *
event_mm_malloc_(size_t sz)
{
    if (sz == 0)
        return NULL;

    if (mm_malloc_fn_)
        return mm_malloc_fn_(sz);
    else
        return malloc(sz);
}

void *
event_mm_calloc_(size_t count, size_t size)
{
    if (count == 0 || size == 0)
        return NULL;

    if (mm_malloc_fn_) {
        size_t sz = count * size;
        void *p = NULL;
        if (count > EV_SIZE_MAX / size)
            goto error;
        p = mm_malloc_fn_(sz);
        if (p)
            return memset(p, 0, sz);
    } else {
        void *p = calloc(count, size);
#ifdef _WIN32
        /* Windows calloc doesn't reliably set ENOMEM */
        if (p == NULL)
            goto error;
#endif
        return p;
    }

error:
    errno = ENOMEM;
    return NULL;
}

char *
event_mm_strdup_(const char *str)
{
    if (!str) {
        errno = EINVAL;
        return NULL;
    }

    if (mm_malloc_fn_) {
        size_t ln = strlen(str);
        void *p = NULL;
        if (ln == EV_SIZE_MAX)
            goto error;
        p = mm_malloc_fn_(ln+1);
        if (p)
            return memcpy(p, str, ln+1);
    } else
#ifdef _WIN32
        return _strdup(str);
#else
        return strdup(str);
#endif

error:
    errno = ENOMEM;
    return NULL;
}

void *
event_mm_realloc_(void *ptr, size_t sz)
{
    if (mm_realloc_fn_)
        return mm_realloc_fn_(ptr, sz);
    else
        return realloc(ptr, sz);
}

void
event_mm_free_(void *ptr)
{
    if (mm_free_fn_)
        mm_free_fn_(ptr);
    else
        free(ptr);
}

// 设定自己的内存管理相关函数
void
event_set_mem_functions(void *(*malloc_fn)(size_t sz),
                        void *(*realloc_fn)(void *ptr, size_t sz),
                        void (*free_fn)(void *ptr))
{
    mm_malloc_fn_ = malloc_fn;
    mm_realloc_fn_ = realloc_fn;
    mm_free_fn_ = free_fn;
}
#endif

#ifdef EVENT__HAVE_EVENTFD
static void
evthread_notify_drain_eventfd(evutil_socket_t fd, short what, void *arg)
{
    ev_uint64_t msg;
    ev_ssize_t r;
    struct event_base *base = arg;

    r = read(fd, (void*) &msg, sizeof(msg));
    if (r<0 && errno != EAGAIN) {
        event_sock_warn(fd, "Error reading from eventfd");
    }
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    base->is_notify_pending = 0;
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}
#endif

// 唤醒event后要执行的回调函数,
// 读取完管道里的所有数据，免得被多路IO复用函数检测到管道可读，而再次被唤醒
static void
evthread_notify_drain_default(evutil_socket_t fd, short what, void *arg)
{
    unsigned char buf[1024];
    struct event_base *base = arg;
    // 读完fd的所有数据，免得再次被唤醒
#ifdef _WIN32
    while (recv(fd, (char*)buf, sizeof(buf), 0) > 0)
        ;
#else
    while (read(fd, (char*)buf, sizeof(buf)) > 0)
        ;
#endif

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    //修改is_notify_pending,使得其不再是未决的了,也能让其他线程可以再次唤醒值
    base->is_notify_pending = 0;
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

int
evthread_make_base_notifiable(struct event_base *base)
{
    int r;
    if (!base)
        return -1;

    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    r = evthread_make_base_notifiable_nolock_(base);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return r;
}

// 从eventfd、pipe和socketpair中选择一种唤醒机制
// 首先创建一个文件描述符fd，然后用这个fd创建一个event，最后添加到event_base中
static int
evthread_make_base_notifiable_nolock_(struct event_base *base)
{
    void (*cb)(evutil_socket_t, short, void *);
    int (*notify)(struct event_base *);

    if (base->th_notify_fn != NULL) {
        /* The base is already notifiable: we're doing fine. */
        return 0;
    }

#if defined(EVENT__HAVE_WORKING_KQUEUE)
    if (base->evsel == &kqops && event_kq_add_notify_event_(base) == 0) {
        base->th_notify_fn = event_kq_notify_base_;
        /* No need to add an event here; the backend can wake
         * itself up just fine. */
        return 0;
    }
#endif
    // 创建eventfd或者pipefd，设置event回调函数和通知函数
#ifdef EVENT__HAVE_EVENTFD
    base->th_notify_fd[0] = evutil_eventfd_(0,
                                            EVUTIL_EFD_CLOEXEC|EVUTIL_EFD_NONBLOCK);
    if (base->th_notify_fd[0] >= 0) {
        base->th_notify_fd[1] = -1;
        notify = evthread_notify_base_eventfd;
        cb = evthread_notify_drain_eventfd;
    } else
#endif
        if (evutil_make_internal_pipe_(base->th_notify_fd) == 0) {
            notify = evthread_notify_base_default;
            cb = evthread_notify_drain_default;
        } else {
            return -1;
        }

    base->th_notify_fn = notify;

    /* prepare an event that we can use for wakeup */
    // 把th_notify事件结构体以添加到event_base中去关注
    event_assign(&base->th_notify, base, base->th_notify_fd[0],
            EV_READ|EV_PERSIST, cb, base);

    /* we need to mark this as internal event */
    // 标明是内部使用的,设置最高优先级
    base->th_notify.ev_flags |= EVLIST_INTERNAL;
    event_priority_set(&base->th_notify, 0);

    // 此函数真正实现将事件添加到event_base的等待列表中
    return event_add_nolock_(&base->th_notify, NULL, 0);
}

int
event_base_foreach_event_nolock_(struct event_base *base,
                                 event_base_foreach_event_cb fn, void *arg)
{
    int r, i;
    unsigned u;
    struct event *ev;

    /* Start out with all the EVLIST_INSERTED events. */
    if ((r = evmap_foreach_event_(base, fn, arg)))
        return r;

    /* Okay, now we deal with those events that have timeouts and are in
     * the min-heap. */
    for (u = 0; u < base->timeheap.n; ++u) {
        ev = base->timeheap.p[u];
        if (ev->ev_flags & EVLIST_INSERTED) {
            /* we already processed this one */
            continue;
        }
        if ((r = fn(base, ev, arg)))
            return r;
    }

    /* Now for the events in one of the timeout queues.
     * the min-heap. */
    for (i = 0; i < base->n_common_timeouts; ++i) {
        struct common_timeout_list *ctl =
                base->common_timeout_queues[i];
        TAILQ_FOREACH(ev, &ctl->events,
                      ev_timeout_pos.ev_next_with_common_timeout) {
            if (ev->ev_flags & EVLIST_INSERTED) {
                /* we already processed this one */
                continue;
            }
            if ((r = fn(base, ev, arg)))
                return r;
        }
    }

    /* Finally, we deal wit all the active events that we haven't touched
     * yet. */
    for (i = 0; i < base->nactivequeues; ++i) {
        struct event_callback *evcb;
        TAILQ_FOREACH(evcb, &base->activequeues[i], evcb_active_next) {
            if ((evcb->evcb_flags & (EVLIST_INIT|EVLIST_INSERTED|EVLIST_TIMEOUT)) != EVLIST_INIT) {
                /* This isn't an event (evlist_init clear), or
                 * we already processed it. (inserted or
                 * timeout set */
                continue;
            }
            ev = event_callback_to_event(evcb);
            if ((r = fn(base, ev, arg)))
                return r;
        }
    }

    return 0;
}

/* Helper for event_base_dump_events: called on each event in the event base;
 * dumps only the inserted events. */
static int
dump_inserted_event_fn(const struct event_base *base, const struct event *e, void *arg)
{
    FILE *output = arg;
    const char *gloss = (e->ev_events & EV_SIGNAL) ?
                "sig" : "fd ";

    if (! (e->ev_flags & (EVLIST_INSERTED|EVLIST_TIMEOUT)))
        return 0;

    fprintf(output, "  %p [%s "EV_SOCK_FMT"]%s%s%s%s%s%s",
            (void*)e, gloss, EV_SOCK_ARG(e->ev_fd),
            (e->ev_events&EV_READ)?" Read":"",
            (e->ev_events&EV_WRITE)?" Write":"",
            (e->ev_events&EV_CLOSED)?" EOF":"",
            (e->ev_events&EV_SIGNAL)?" Signal":"",
            (e->ev_events&EV_PERSIST)?" Persist":"",
            (e->ev_flags&EVLIST_INTERNAL)?" Internal":"");
    if (e->ev_flags & EVLIST_TIMEOUT) {
        struct timeval tv;
        tv.tv_sec = e->ev_timeout.tv_sec;
        tv.tv_usec = e->ev_timeout.tv_usec & MICROSECONDS_MASK;
        evutil_timeradd(&tv, &base->tv_clock_diff, &tv);
        fprintf(output, " Timeout=%ld.%06d",
                (long)tv.tv_sec, (int)(tv.tv_usec & MICROSECONDS_MASK));
    }
    fputc('\n', output);

    return 0;
}

/* Helper for event_base_dump_events: called on each event in the event base;
 * dumps only the active events. */
static int
dump_active_event_fn(const struct event_base *base, const struct event *e, void *arg)
{
    FILE *output = arg;
    const char *gloss = (e->ev_events & EV_SIGNAL) ?
                "sig" : "fd ";

    if (! (e->ev_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER)))
        return 0;

    fprintf(output, "  %p [%s "EV_SOCK_FMT", priority=%d]%s%s%s%s%s active%s%s\n",
            (void*)e, gloss, EV_SOCK_ARG(e->ev_fd), e->ev_pri,
            (e->ev_res&EV_READ)?" Read":"",
            (e->ev_res&EV_WRITE)?" Write":"",
            (e->ev_res&EV_CLOSED)?" EOF":"",
            (e->ev_res&EV_SIGNAL)?" Signal":"",
            (e->ev_res&EV_TIMEOUT)?" Timeout":"",
            (e->ev_flags&EVLIST_INTERNAL)?" [Internal]":"",
            (e->ev_flags&EVLIST_ACTIVE_LATER)?" [NextTime]":"");

    return 0;
}

int
event_base_foreach_event(struct event_base *base,
                         event_base_foreach_event_cb fn, void *arg)
{
    int r;
    if ((!fn) || (!base)) {
        return -1;
    }
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    r = event_base_foreach_event_nolock_(base, fn, arg);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
    return r;
}

// 把event_base 的事件及其状态的完整列表存到文件中
void
event_base_dump_events(struct event_base *base, FILE *output)
{
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    fprintf(output, "Inserted events:\n");
    event_base_foreach_event_nolock_(base, dump_inserted_event_fn, output);

    fprintf(output, "Active events:\n");
    event_base_foreach_event_nolock_(base, dump_active_event_fn, output);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

void
event_base_active_by_fd(struct event_base *base, evutil_socket_t fd, short events)
{
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    evmap_io_active_(base, fd, events & (EV_READ|EV_WRITE|EV_CLOSED));
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

void
event_base_active_by_signal(struct event_base *base, int sig)
{
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    evmap_signal_active_(base, sig, 1);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}


void
event_base_add_virtual_(struct event_base *base)
{
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    base->virtual_event_count++;
    MAX_EVENT_COUNT(base->virtual_event_count_max, base->virtual_event_count);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

void
event_base_del_virtual_(struct event_base *base)
{
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    EVUTIL_ASSERT(base->virtual_event_count > 0);
    base->virtual_event_count--;
    if (base->virtual_event_count == 0 && EVBASE_NEED_NOTIFY(base))
        evthread_notify_base(base);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

static void
event_free_debug_globals_locks(void)
{
#ifndef EVENT__DISABLE_THREAD_SUPPORT
#ifndef EVENT__DISABLE_DEBUG_MODE
    if (event_debug_map_lock_ != NULL) {
        EVTHREAD_FREE_LOCK(event_debug_map_lock_, 0);
        event_debug_map_lock_ = NULL;
        evthreadimpl_disable_lock_debugging_();
    }
#endif /* EVENT__DISABLE_DEBUG_MODE */
#endif /* EVENT__DISABLE_THREAD_SUPPORT */
    return;
}

static void
event_free_debug_globals(void)
{
    event_free_debug_globals_locks();
}

static void
event_free_evsig_globals(void)
{
    evsig_free_globals_();
}

static void
event_free_evutil_globals(void)
{
    evutil_free_globals_();
}

static void
event_free_globals(void)
{
    event_free_debug_globals();
    event_free_evsig_globals();
    event_free_evutil_globals();
}

void
libevent_global_shutdown(void)
{
    event_disable_debug_mode();
    event_free_globals();
}

#ifndef EVENT__DISABLE_THREAD_SUPPORT
int
event_global_setup_locks_(const int enable_locks)
{
#ifndef EVENT__DISABLE_DEBUG_MODE
    EVTHREAD_SETUP_GLOBAL_LOCK(event_debug_map_lock_, 0);
#endif
    if (evsig_global_setup_locks_(enable_locks) < 0)
        return -1;
    if (evutil_global_setup_locks_(enable_locks) < 0)
        return -1;
    if (evutil_secure_rng_global_setup_locks_(enable_locks) < 0)
        return -1;
    return 0;
}
#endif

void
event_base_assert_ok_(struct event_base *base)
{
    EVBASE_ACQUIRE_LOCK(base, th_base_lock);
    event_base_assert_ok_nolock_(base);
    EVBASE_RELEASE_LOCK(base, th_base_lock);
}

void
event_base_assert_ok_nolock_(struct event_base *base)
{
    int i;
    int count;

    /* First do checks on the per-fd and per-signal lists */
    evmap_check_integrity_(base);

    /* Check the heap property */
    for (i = 1; i < (int)base->timeheap.n; ++i) {
        int parent = (i - 1) / 2;
        struct event *ev, *p_ev;
        ev = base->timeheap.p[i];
        p_ev = base->timeheap.p[parent];
        EVUTIL_ASSERT(ev->ev_flags & EVLIST_TIMEOUT);
        EVUTIL_ASSERT(evutil_timercmp(&p_ev->ev_timeout, &ev->ev_timeout, <=));
        EVUTIL_ASSERT(ev->ev_timeout_pos.min_heap_idx == i);
    }

    /* Check that the common timeouts are fine */
    for (i = 0; i < base->n_common_timeouts; ++i) {
        struct common_timeout_list *ctl = base->common_timeout_queues[i];
        struct event *last=NULL, *ev;

        EVUTIL_ASSERT_TAILQ_OK(&ctl->events, event, ev_timeout_pos.ev_next_with_common_timeout);

        TAILQ_FOREACH(ev, &ctl->events, ev_timeout_pos.ev_next_with_common_timeout) {
            if (last)
                EVUTIL_ASSERT(evutil_timercmp(&last->ev_timeout, &ev->ev_timeout, <=));
            EVUTIL_ASSERT(ev->ev_flags & EVLIST_TIMEOUT);
            EVUTIL_ASSERT(is_common_timeout(&ev->ev_timeout,base));
            EVUTIL_ASSERT(COMMON_TIMEOUT_IDX(&ev->ev_timeout) == i);
            last = ev;
        }
    }

    /* Check the active queues. */
    count = 0;
    for (i = 0; i < base->nactivequeues; ++i) {
        struct event_callback *evcb;
        EVUTIL_ASSERT_TAILQ_OK(&base->activequeues[i], event_callback, evcb_active_next);
        TAILQ_FOREACH(evcb, &base->activequeues[i], evcb_active_next) {
            EVUTIL_ASSERT((evcb->evcb_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER)) == EVLIST_ACTIVE);
            EVUTIL_ASSERT(evcb->evcb_pri == i);
            ++count;
        }
    }

    {
        struct event_callback *evcb;
        TAILQ_FOREACH(evcb, &base->active_later_queue, evcb_active_next) {
            EVUTIL_ASSERT((evcb->evcb_flags & (EVLIST_ACTIVE|EVLIST_ACTIVE_LATER)) == EVLIST_ACTIVE_LATER);
            ++count;
        }
    }
    EVUTIL_ASSERT(count == base->event_count_active);
}
