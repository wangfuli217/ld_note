#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/queue.h>
#include <sys/tree.h>
#include <sys/time.h>
#include <time.h>
#include "log.h"
#include "event.h"
#include "event_internal.h"

//only epoll
extern const struct eventop epollops;

// 没有采用I/O策略, 直接硬编码为epoll接口
const struct eventop *eventops[] = {
    &epollops,
    NULL
};

/**
 * 全局变量, 保存当前的反应堆
 */
struct event_base *current_base = NULL;

/* prototypes */
static void event_queue_insert (struct event_base *, struct event *, int);
static void event_queue_remove (struct event_base *, struct event *, int);
static int event_haveevents (struct event_base *);

static void event_process_active (struct event_base *);

static int timeout_next (struct event_base *, struct timeval *);
static void timeout_process (struct event_base *);

static int compare (struct event *a, struct event *b) {
    if (timercmp (&(a->ev_timeout), &(b->ev_timeout), <))
        return (-1);
    else if (timercmp (&(a->ev_timeout), &(b->ev_timeout), >))
        return (1);
    if (a < b)
        return (-1);
    else if (a > b)
        return (1);
    return (0);
}

RB_PROTOTYPE (event_tree, event, ev_timeout_node, compare);

RB_GENERATE (event_tree, event, ev_timeout_node, compare);

/**
 * 
 * 初始化一个全局的 event_base
 * 
 * \return void*
 * 
 */
void *event_init (void) {
    int i;
    LOG_DEBUG ("event_init");

    if ((current_base = calloc (1, sizeof (struct event_base))) == NULL)
        LOG_ERROR ("calloc fail");

    gettimeofday (&current_base->event_tv, NULL);

    RB_INIT (&current_base->timetree);
    TAILQ_INIT (&current_base->eventqueue);

    current_base->evbase = NULL;
    for (i = 0; eventops[i] && !current_base->evbase; i++) {
        current_base->evsel = eventops[i];

        current_base->evbase = current_base->evsel->init ();
    }

    if (current_base->evbase == NULL)
        LOG_ERROR ("no event mechanism available");

    //初始化默认优先级队列个数为1
    event_base_priority_init (current_base, 1);

    return (current_base);
}

/**
 * 
 * 初始反应堆的优先队列
 * 
 * \param  base        反应堆
 * 
 * \param  npriorities 个数
 * 
 * \return int
 */
int event_base_priority_init (struct event_base *base, int npriorities) {
    int i;
    LOG_DEBUG ("event base priority init: %d", npriorities);

    if (base->event_count_active)
        return (-1);

    if (base->nactivequeues && npriorities != base->nactivequeues) {
        for (i = 0; i < base->nactivequeues; ++i) {
            free (base->activequeues[i]);
        }
        free (base->activequeues);
    }
    //初始化优先队列
    base->nactivequeues = npriorities;
    base->activequeues = (struct event_list **) calloc (npriorities, npriorities * sizeof (struct event_list *));

    if (base->activequeues == NULL)
        LOG_ERROR ("allocated activequeues fail, out of memory.");

    //初始化每个优先队列头结点
    for (i = 0; i < base->nactivequeues; ++i) {
        base->activequeues[i] = malloc (sizeof (struct event_list));
        if (base->activequeues[i] == NULL)
            LOG_ERROR ("allocated activequeues[%d] fail, out of memory.", i);
        TAILQ_INIT (base->activequeues[i]);
    }

    return (0);
}

/**
 *
 * 事件初始化
 * 
 * \param ev 待初始化的event对象
 * 
 * \param fd event绑定的<句柄>, 对于信号事件, 就是关注的信号
 * 
 * \param events 在该fd上关注的事件类型, 比如EV_READ, EV_WRITE .etc
 * 
 * \param cb 事件发生时的回调函数
 * 
 * \param arg 传递给cb函数指针参数
 *
 * \return void
 * 
 */
void event_set (struct event *ev, int fd, short events, void (*callback) (int, short, void *), void *arg) {
    ev->ev_base = current_base;

    ev->ev_fd = fd;
    ev->ev_events = events;
    ev->ev_callback = callback;
    ev->ev_flags = EVLIST_INIT;
    ev->ev_arg = arg;
    ev->ev_res = 0;

    //event 默认优先级
    ev->ev_pri = current_base->nactivequeues / 2;
}

/**
 * 
 * 设置event从属的event_base
 * 
 * \param  base base反应堆
 * 
 * \param  ev   事件对象
 * 
 * \return int
 */
int event_base_set (struct event_base *base, struct event *ev) {
    //只有EVLIST_INIT的事件才可以分配不同的反应堆
    if (ev->ev_flags != EVLIST_INIT)
        return (-1);

    ev->ev_base = base;
    ev->ev_pri = base->nactivequeues / 2;

    return (0);
}

/*
 *
 * 注册事件
 *
 * \param ev 要注册的事件
 * 
 * \param tv 超时时间
 * 
 * \return int
 * 
 */
int event_add (struct event *ev, struct timeval *tv) {
    struct event_base *base = ev->ev_base;  //要注册到的反应堆
    const struct eventop *evsel = base->evsel;
    void *evbase = base->evbase;    //base使用的系统I/O策略

    LOG_DEBUG ("event add: event: %p, %s %s %s call %p", ev, ev->ev_events & EVENT_READ ? "READ" : "", ev->ev_events & EVENT_WRITE ? "WRITE" : "", tv ? "TIMEOUT" : "", ev->ev_callback);

    assert (!(ev->ev_flags & ~EVLIST_ALL));

    //timeout事件
    if (tv != NULL) {
        struct timeval now;

        //&EVLIST_TIMEOUT表时event已经在定时器堆中了, 删除旧的
        if (ev->ev_flags & EVLIST_TIMEOUT)
            event_queue_remove (base, ev, EVLIST_TIMEOUT);

        gettimeofday (&now, NULL);
        timeradd (&now, tv, &ev->ev_timeout);   //将现在时间now和定时时间tv相加

        LOG_DEBUG ("event_add: timeout in %d seconds, call %p", (int) tv->tv_sec, ev->ev_callback);

        event_queue_insert (base, ev, EVLIST_TIMEOUT);
    }
    //如事件ev不在事件队列或者就绪队列, 则注册事件
    if ((ev->ev_events & (EVENT_READ | EVENT_WRITE)) && !(ev->ev_flags & (EVLIST_INSERTED | EVLIST_ACTIVE))) {
        //插入到事件队列并注册到base的例程(这里顺序应该倒过来)
        event_queue_insert (base, ev, EVLIST_INSERTED);
        return (evsel->add (evbase, ev));
    }

    return (0);
}

/**
 * 
 * 事件循环 (非线程安全)
 * 
 * @return  int
 */
int event_dispatch (void) {
    LOG_DEBUG ("begin dispatch.");

    //base默认为保存的当前反应堆
    struct event_base *base = current_base;
    const struct eventop *evsel = base->evsel;
    void *evbase = base->evbase;

    struct timeval tv;
    int res, done;

    done = 0;
    while (!done) {             //事件循环

        //随着注册的事件数量越来越多, 动态调整反应堆的大小
        if (evsel->recalc (base, evbase, 0) == -1)
            return -1;

        //对于timeout事件, 这里还要做一步处理(因为学习用的, 这里省了)

        /* 
         * 校正系统时间,如果系统使用的是非MONOTONIC时间, 用户可能会向后调整了系统时间  
         * 在timeout_correct函数里, 比较last wait time和当前时间，如果当前时间< last wait time  
         * 表明时间有问题，这是需要更新timetree中所有定时事件的超时时间。 
         *
         *  timeout_correct(base, &tv);
         */

        // 根据timetree中事件的最小超时间, 计算出系统I/O demultiplexer的最大等待时间
        if (!base->event_count_active)
            //这里我在timeout_next函数里硬编码为 {5, 0} 5秒
            timeout_next (base, &tv);
        else
            // 将tv清空
            // 依然有未处理的就绪时间, 就让I/O demultiplexer立即返回, 不必等待
            timerclear (&tv);

        // 当前没有注册事件, 就退出事件循环
        if (!event_haveevents (base))
            return (1);

        // 调用系统I/O demultiplexer等待就绪I/O events, 可能是epoll_wait,或者select等；  
        // 在evsel->dispatch()中, 会把就绪signal event, I/O event插入到激活链表中
        res = evsel->dispatch (base, evbase, &tv);

        if (res == -1)
            return (-1);

        //检查timetree中的定时事件, 将就就绪的timer事件从timetree中删除, 并插入到激活链表中
        timeout_process (base);

        // 调用event_process_active()处理激活链表中的就绪event, 调用其回调函数执行事件处理
        // 该函数会寻找最高优先级(priority值越小优先级越高)的激活事件链表
        // 然后处理链表中的所有就绪事件  
        // 因此低优先级的就绪事件可能得不到及时处理
        if (base->event_count_active)
            event_process_active (base);
    }

    LOG_DEBUG ("terminate dispatch.");

    return 0;
}

/**
 * 
 * 将事件插入事件队列
 * 
 * \param base  反应堆
 * 
 * \param ev    事件
 * 
 * \param queue 事件状态
 *
 * \return void
 */
static void event_queue_insert (struct event_base *base, struct event *ev, int queue) {
    //处理重复插入
    if (ev->ev_flags & queue) {
        //已在就绪队列,返回
        if (queue & EVLIST_ACTIVE)
            return;

        LOG_ERROR ("%p(fd %d) already on queue %x", ev, ev->ev_fd, queue);
    }
    base->event_count++;
    ev->ev_flags |= queue;      //记录此时event在队列的状态

    switch (queue) {
    case EVLIST_TIMEOUT:{      //超时处理
            struct event *tmp = RB_INSERT (event_tree, &base->timetree, ev);
            assert (tmp == NULL);
            break;
        }

    case EVLIST_INSERTED:      //io或signal事件, 加入事件队列
        TAILQ_INSERT_TAIL (&base->eventqueue, ev, ev_next);
        break;

    case EVLIST_ACTIVE:        //就绪事件, 加入到就绪队列
        base->event_count_active++;
        TAILQ_INSERT_TAIL (base->activequeues[ev->ev_pri], ev, ev_active_next);
        break;

    default:
        LOG_ERROR ("unkown queue.");
    }
}

/**
 * 
 * 将事件从队列中移除
 * 
 * \param base  反应堆
 * 
 * \param ev    事件
 * 
 * \param queue 指定的队列
 *
 * \param void
 */
static void event_queue_remove (struct event_base *base, struct event *ev, int queue) {
    if (!(ev->ev_flags & queue))
        LOG_ERROR ("%p(fd,%d) not on queue %x", ev, ev->ev_fd, queue);

    base->event_count--;
    ev->ev_flags &= ~queue;

    switch (queue) {
    case EVLIST_TIMEOUT:
        RB_REMOVE (event_tree, &base->timetree, ev);
        break;

    case EVLIST_INSERTED:
        TAILQ_REMOVE (&base->eventqueue, ev, ev_next);
        break;

    case EVLIST_ACTIVE:
        base->event_count_active--;
        TAILQ_REMOVE (base->activequeues[ev->ev_pri], ev, ev_active_next);
        break;

    default:
        LOG_ERROR ("unkown queue.");
    }
}

/**
 * 
 * 删除事件
 * 		
 * \param  ev 事件
 * 
 * \return int
 */
int event_del (struct event *ev) {
    struct event_base *base = ev->ev_base;
    const struct eventop *evsel = base->evsel;
    void *evbase = base->evbase;

    LOG_DEBUG ("event del: %p, callback %p", ev, ev->ev_callback);

    assert (!(ev->ev_flags & ~EVLIST_ALL));

    //从对应的链表删除
    if (ev->ev_flags & EVLIST_TIMEOUT)
        event_queue_remove (base, ev, EVLIST_TIMEOUT);

    if (ev->ev_flags & EVLIST_ACTIVE)
        event_queue_remove (base, ev, EVLIST_ACTIVE);

    if (ev->ev_flags & EVLIST_INSERTED) {
        event_queue_remove (base, ev, EVLIST_INSERTED);
        return evsel->del (evbase, ev);
    }

    return (0);
}

/**
 * 
 * 激活事件
 * 
 * \param ev  事件
 * 
 * \param res 状态
 *
 * \param void
 */
void event_active (struct event *ev, int res) {
    LOG_DEBUG ("event active: ev=%p", ev);

    if (ev->ev_flags & EVLIST_ACTIVE) {
        ev->ev_res |= res;
        return;
    }

    ev->ev_res = res;
    event_queue_insert (ev->ev_base, ev, EVLIST_ACTIVE);
}

/**
 * 
 * 查找最小的超时时间
 * 
 * \param  base 反应堆
 * 
 * \param  tv   tv
 * 
 * \return int
 */
int timeout_next (struct event_base *base, struct timeval *tv) {
    struct timeval dflt = { 5, 0 }; // make it 5s
    struct timeval now;
    struct event *ev;

    if ((ev = RB_MIN (event_tree, &base->timetree)) == NULL) {
        *tv = dflt;
        return (0);
    }

    if (gettimeofday (&now, NULL) == -1)
        return (-1);

    if (timercmp (&ev->ev_timeout, &now, <=)) {
        timerclear (tv);
        return (0);
    }

    timersub (&ev->ev_timeout, &now, tv);

    assert (tv->tv_sec >= 0);
    assert (tv->tv_usec >= 0);

    LOG_DEBUG ("timeout_next: in %d seconds", (int) tv->tv_sec);

    return (0);
}

/**
 * 
 * 处理定时事件
 * 
 * \param base 反应堆
 *
 * \param void
 */
void timeout_process (struct event_base *base) {
    struct timeval now;
    struct event *ev, *next;

    gettimeofday (&now, NULL);

    for (ev = RB_MIN (event_tree, &base->timetree); ev; ev = next) {
        if (timercmp (&ev->ev_timeout, &now, >))
            break;

        next = RB_NEXT (event_tree, &base->timetree, ev);

        event_queue_remove (base, ev, EVLIST_TIMEOUT);

        event_del (ev);

        LOG_DEBUG ("timeout process call %p", ev->ev_callback);
        event_active (ev, EVENT_TIMEOUT);
    }
}

/**
 * 
 * 处理激活队列的事件
 * 
 * \param base 反应堆
 *
 * \param void
 */
void event_process_active (struct event_base *base) {
    struct event *ev;
    struct event_list *activeq = NULL;
    int i;

    if (!base->event_count_active)
        return;

    //struct event 的ev_pri值越小, 优先级越高
    for (i = 0; i < base->nactivequeues; ++i) {
        if (TAILQ_FIRST (base->activequeues[i]) != NULL) {
            activeq = base->activequeues[i];
            break;
        }
    }

    for (ev = TAILQ_FIRST (activeq); ev; ev = TAILQ_FIRST (activeq)) {
        event_queue_remove (base, ev, EVLIST_ACTIVE);

        (*ev->ev_callback) ((int) ev->ev_fd, ev->ev_res, ev->ev_arg);
    }
}

/**
 * 
 * 检测是否有应绪事件
 * 
 * \param  base 反应堆
 * 
 * \return int
 */
int event_haveevents (struct event_base *base) {
    return (base->event_count > 0);
}
