#ifndef _MIN_EVENT_H_
#define _MIN_EVENT_H_

#ifdef __cplusplus
extern "C" {
#endif

/* 事件类型的定义*/
#define EVENT_READ		0x01    //io事件 read
#define EVENT_WRITE		0x02    //io事件 write
#define EVENT_TIMEOUT	0x04    //超时事件
#define EVENT_SIGNAL	0x08    //信号事件
#define EVENT_PERSIST	0x10    //辅助选项, 表示是一个永久事件

/* 事件状态的定义 */
#define EVLIST_INIT		0x01    //event已被初始化
#define EVLIST_INSERTED	0x02    //event在已注册事件队列中
#define EVLIST_TIMEOUT	0x04    //event在time堆中
#define EVLIST_SIGNAL	0x08    //用于信号事件, 在信号事件队列 (暂时不用)
#define EVLIST_ACTIVE	0x10    //event在就绪队列中

#define EVLIST_ALL		0x1F

/* Fix so that ppl dont have to run with <sys/queue.h> */
#ifndef TAILQ_ENTRY
#define _EVENT_DEFINED_TQENTRY
#define TAILQ_ENTRY(type)						\
struct {								\
	struct type *tqe_next;	/* next element */			\
	struct type **tqe_prev;	/* address of previous next element */	\
}
#endif                          /* !TAILQ_ENTRY */
#ifndef RB_ENTRY
#define _EVENT_DEFINED_RBENTRY
#define RB_ENTRY(type)							\
struct {								\
	struct type *rbe_left;		/* left element */		\
	struct type *rbe_right;		/* right element */		\
	struct type *rbe_parent;	/* parent element */		\
	int rbe_color;			/* node color */		\
}
#endif                          /* !RB_ENTRY */

    struct event_base;
    struct event {
    /**
	 * ev_next, ev_active_next都是双向链表节点.它们是libevent对不同的事件类型和
	 * 不同时期,对事件的管理的字段
	 */
        TAILQ_ENTRY (event) ev_next;
        TAILQ_ENTRY (event) ev_active_next;

        RB_ENTRY (event) ev_timeout_node;

        struct event_base *ev_base;

        int ev_fd;              //对于io事件,是绑定的文件描述符;对于signal事件, 是绑定的信号
        short ev_events;        //Event类型

        void (*ev_callback) (int, short, void *arg);    //事件处理回调函数

        struct timeval ev_timeout;

        int ev_flags;           //Event当前的状态
        int ev_res;             //记录当前激活事件的类型
        int ev_pri;             //优先级
        void *ev_arg;           //任意类型的数据
    };

    struct eventop {
        const char *name;
        void *(*init) (void);
        int (*add) (void *, struct event *);
        int (*del) (void *, struct event *);
        int (*recalc) (struct event_base *, void *, int);
        int (*dispatch) (struct event_base *, void *, struct timeval *);
    };

    void *event_init (void);
    void event_set (struct event *, int, short, void (*)(int, short, void *), void *);
    int event_base_set (struct event_base *, struct event *);
    int event_add (struct event *, struct timeval *);
    int event_del (struct event *);
    void event_active (struct event *, int);
    int event_dispatch (void);

    int event_base_priority_init (struct event_base *, int);

#ifdef __cplusplus
}
#endif
#endif
