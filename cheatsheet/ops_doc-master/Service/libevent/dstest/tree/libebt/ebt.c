#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <assert.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <pthread.h>
#include <sched.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/epoll.h>
#include <sys/queue.h>
#include <sys/tree.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/******************************************************************/
/* error functions                                                */
/******************************************************************/
#define ERR_MAXLINE 2048

static void err_doit (int, const char *, va_list);

static void err_sys_ (const char *fmt, ...) {
    va_list ap;

    va_start (ap, fmt);
    err_doit (1, fmt, ap);
    va_end (ap);

    exit (1);
}

static void err_msg_ (const char *fmt, ...) {
    va_list ap;

    va_start (ap, fmt);
    err_doit (0, fmt, ap);
    va_end (ap);

    return;
}

/**
  * print message and return to caller
  * 
  */
static void err_doit (int errnoflag, const char *fmt, va_list ap) {
    int errno_save, n;
    char buf[ERR_MAXLINE + 1];
    errno_save = errno;

#ifdef HAVE_VSNPRINTF
    vsnprintf (buf, ERR_MAXLINE, fmt, ap);
#else
    vsprintf (buf, fmt, ap);
#endif

    n = strlen (buf);
    if (errnoflag)
        snprintf (buf + n, ERR_MAXLINE - n, ": %s", strerror (errno_save));

    strcat (buf, "\n");
    fflush (stdout);
    fputs (buf, stderr);
    fflush (stderr);

    return;
}

#define __QUOTE(x) # x
#define  _QUOTE(x) __QUOTE(x)

#define err_msg(fmt, ...) do {                                       \
    time_t t = time(NULL);                                           \
    struct tm *dm = localtime(&t);                                   \
    err_msg_("[%02d:%02d:%02d] %s:[" _QUOTE(__LINE__) "]\t    %-26s:"\
        fmt,                                                         \
        dm->tm_hour,                                                 \
        dm->tm_min,                                                  \
        dm->tm_sec,                                                  \
        __FILE__,                                                    \
        __func__,                                                    \
        ## __VA_ARGS__);                                             \
} while(0)

#define err_print(fmt, func, ...) do { \
    /* TODO:*/                         \
} while(0)

#ifdef DEBUG
#define err_debug(fmt, ...) err_msg(fmt, ## __VA_ARGS__)
#else
#define err_debug(fmt, ...)
#endif
#define err_exit(fmt, ...)  do {  \
    err_msg(fmt, ##__VA_ARGS__);  \
    exit(1);                      \
} while(0)

/******************************************************************/
/* Vec                                                            */
/******************************************************************/
static void vec_expand (char **data, int *length, int *capacity, int memsz) {
    if (*length + 1 > *capacity) {
        *capacity = (*capacity == 0) ? 1 : (*capacity << 1);

        *data = realloc (*data, (size_t) (*capacity * memsz));
    }
}

static void vec_splice (char **data, int *length, int *capacity, int memsz, int start, int count) {
    (void) capacity;
    memmove (*data + start * memsz, *data + (start + count) * memsz, (*length - start - count) * memsz);
}

#define Vec(T) \
    struct { T *data; int length, capacity;}

#define vec_unpack(v) \
    (char**)&(v)->data, &(v)->length, &(v)->capacity, sizeof(*(v)->data)

#define vec_init(v) \
    memset((v), 0, sizeof(*(v)))

#define vec_deinit(v) \
    free((v)->data)

#define vec_clear(v) \
    ((v)->length = 0)

#define vec_push(v, val) \
    (vec_expand(vec_unpack(v)), \
    (v)->data[(v)->length++] = (val) )

#define vec_pop(v) \
    (assert((v)->length > 0), \
    (v)->data[-- (v)->length])

#define vec_get(v, pos) \
    (assert(pos < (v)->length), \
    (v)->data[pos])

#define vec_splice(v, start, count)\
    (vec_splice(vec_unpack(v), start, count), \
    (v)->length -= (count))

/******************************************************************/
/* cqueue                                                         */
/******************************************************************/
enum q_flag {
    QF_LOCK = 1u << 1,
    QF_NOTIFY = 1u << 2,
    QF_SHM = 1u << 3,
};

struct cq_item {
    int length;
    char data[0];
};

struct cqueue {
    int head;                   /* queue head */
    int tail;                   /* queue tail */
    int capacity;               /* the queue capacity */
    char head_tag;              /* tag whether elem already in head */
    char tail_tag;              /* tag whether elem already in tail */
    int num;                    /* current total elements */
    int flags;                  /* queue flags supported */
    int max_elemsize;           /* max element size */
    void *mem;                  /* memory block */
    pthread_mutex_t lock;
    pthread_mutexattr_t attr;
    int pipes[2];
};

#define CQ_MINMEMORY_CAPACITY       (1024 * 64) //最小内存分配
#define cqueue_empty(q)             (q->num == 0)
#define cqueue_full(q)              ((q->head == q->tail) && ( q->tail_tag != q->head_tag))

static void set_nonblock (int fd, int nonblock) {
    int opts, ret;

    do {
        opts = fcntl (fd, F_GETFL);
    }
    while (opts < 0 && errno == EINTR);

    if (opts < 0)
        err_exit ("fcntl(%d, F_GETFL) failed.", fd);

    if (nonblock)
        opts = opts | O_NONBLOCK;
    else
        opts = opts | ~O_NONBLOCK;

    do {
        ret = fcntl (fd, F_SETFL, opts);
    }
    while (ret < 0 && errno == EINTR);

    if (ret < 0)
        err_exit ("fcntl(%d, F_SETFL, opts) failed.", fd);
}

struct cqueue *cqueue_new (int capacity, int max_elemsize, enum q_flag flags) {
    assert (capacity > CQ_MINMEMORY_CAPACITY + max_elemsize);

    void *mem;
    int ret = 0;

    /* use share memory */
    if (flags & QF_SHM) {
        int shmfd = -1;
        int shmflag = MAP_SHARED;

#ifdef MAP_ANONYMOUS
        shmflag |= MAP_ANONYMOUS;
#else
        char *mapfile = "/dev/zero";
        if ((shmfd = open (mapfile, O_RDWR)) < 0)
            return NULL;
#endif

        mem = mmap (NULL, capacity, PROT_READ | PROT_WRITE, shmflag, shmfd, 0);

#ifdef MAP_FAILED
        if (mem == MAP_FAILED)
#else
        if (!mem)
#endif
        {
            err_msg ("mmap failed, error for %s", strerror (errno));
            return NULL;
        }
    } else {
        mem = malloc (capacity);

        if (mem == NULL) {
            err_msg ("malloc fail!");
            return NULL;
        }
    }

    struct cqueue *cq = mem;
    mem += sizeof (struct cqueue);
    memset (cq, 0, sizeof (struct cqueue));

    cq->mem = mem;
    cq->capacity = capacity;
    cq->max_elemsize = max_elemsize;
    cq->flags = flags;

    if (flags & QF_LOCK) {
        pthread_mutexattr_init (&cq->attr);
        pthread_mutexattr_setpshared (&cq->attr, PTHREAD_PROCESS_SHARED);

        ret = pthread_mutex_init (&cq->lock, &cq->attr);

        if (ret < 0) {
            if (flags & QF_SHM)
                munmap (mem, capacity);
            else
                free (mem);

            err_msg ("mutext init failed!");

            return NULL;
        }
    }

    if (flags & QF_NOTIFY) {
        ret = pipe (cq->pipes);
        if (ret < 0) {
            err_msg ("pipe create fail. error: %s[%d]", strerror (errno), errno);
        } else {
            set_nonblock (cq->pipes[0], 1);
            set_nonblock (cq->pipes[1], 1);
        }
    }

    return cq;
}

int cqueue_shift (struct cqueue *cq, void *item, int item_size) {
    /* if cqueue was empty */
    if (cqueue_empty (cq)) {
        /* important! avoid thread to get lock again */
        sched_yield ();
        return -1;
    }

    struct cq_item *unit = cq->mem + cq->head;
    assert (item_size >= unit->length);

    memcpy (item, unit->data, unit->length);
    cq->head += (unit->length + sizeof (unit->length));

    if (cq->head >= cq->capacity) {
        cq->head = 0;
        cq->head_tag = 1 - cq->head_tag;
    }

    cq->num--;

    return unit->length;
}

int cqueue_unshift (struct cqueue *cq, void *item, int item_size) {
    assert (item_size < cq->max_elemsize);

    /* when cqueue was empty! */
    if (cqueue_full (cq)) {
        sched_yield ();
        return -1;
    }

    struct cq_item *unit;
    int msize;

    msize = sizeof (unit->length) + item_size;

    if (cq->tail < cq->head) {
        if ((cq->head - cq->tail) < msize)
            return -1;

        unit = cq->mem + cq->tail;
        cq->tail += msize;
    } else {
        unit = cq->mem + cq->tail;
        cq->tail += msize;
        if (cq->tail >= cq->capacity) {
            cq->tail = 0;
            cq->tail_tag = 1 - cq->tail_tag;
        }
    }
    cq->num++;
    unit->length = item_size;
    memcpy (unit->data, item, item_size);

    return 0;
}

int cqueue_pop (struct cqueue *cq, void *item, int item_size) {
    assert (cq->flags & QF_LOCK);

    int ret = 0;

    pthread_mutex_lock (&cq->lock);
    ret = cqueue_shift (cq, item, item_size);
    pthread_mutex_unlock (&cq->lock);

    return ret;
}

int cqueue_push (struct cqueue *cq, void *item, int item_size) {
    assert (cq->flags & QF_LOCK);

    int ret = 0;

    pthread_mutex_lock (&cq->lock);
    ret = cqueue_unshift (cq, item, item_size);
    pthread_mutex_unlock (&cq->lock);

    return ret;
}

int cqueue_wait (struct cqueue *cq) {
    uint64_t data;
    return read (cq->pipes[0], &data, sizeof (data));
}

int cqueue_notify (struct cqueue *cq) {
    uint64_t data = 1;
    return write (cq->pipes[1], &data, sizeof (data));
}

void cqueue_free (struct cqueue *cq) {
    if (cq->flags & QF_LOCK)
        pthread_mutex_destroy (&cq->lock);

    if (cq->flags & QF_NOTIFY) {
        close (cq->pipes[0]);
        close (cq->pipes[1]);
    }

    if (cq->flags & QF_SHM)
        munmap (cq, cq->capacity);
    else
        free (cq);
}

/******************************************************************/
/* thread pool                                                    */
/******************************************************************/
#define atom_add(a, b) __sync_fetch_and_add(a, b)
#define atom_sub(a, b) __sync_fetch_and_sub(a, b)
struct thread_pool;
typedef volatile uint32_t _u32_t;

enum thread_stats {
    T_IDEL,
    T_WAITING,
    T_RUNNIG,
};

struct thread_param {
    void *data;
    int id;
};

struct thread_entity {
    union {
        void *ptr;
        uint32_t u32;
        uint64_t u64;
    } data;

    int id;
    pthread_t thread_id;
    enum thread_stats stats;

    struct cqueue *cq;
    int notify_send_fd;
    int notify_recv_fd;
    struct thread_pool *pool;
};

struct thread_pool {
    struct thread_entity *threads;
    struct thread_param *params;
    struct cqueue *cq;
    int num_threads;
    int shutdown;
    _u32_t num_tasks;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
};

static void thread_setup (struct thread_entity *me) {
    me->cq = cqueue_new (1024 * 256, 1024, 0);
    if (me->cq == NULL) {
        err_exit ("can't allocate memory for cq queue!");
    }
}

static void thread_cleanup (struct thread_entity *me) {
    cqueue_free (me->cq);
    close (me->notify_send_fd);
    close (me->notify_recv_fd);
}

/**
 * 初始化线程池
 */
int thread_pool_init (struct thread_pool *pool, int num_threads) {
    assert (num_threads > 0);
    int i;
    memset (pool, 0, sizeof (struct thread_pool));

    pool->threads = calloc (num_threads, sizeof (struct thread_entity));

    if (!pool->threads)
        err_exit ("can't allocate thread descriptors!");

    pool->params = calloc (num_threads, sizeof (struct thread_param));

    if (pool->params == NULL)
        err_exit ("can't allocate thread params!");

    for (i = 0; i < num_threads; i++) {
        int fds[2];

        if (pipe (fds))
            err_exit ("can't create notify pipe!");

        pool->threads[i].id = i;
        pool->threads[i].notify_recv_fd = fds[0];
        pool->threads[i].notify_send_fd = fds[1];

        thread_setup (&pool->threads[i]);
    }

    pool->cq = cqueue_new (1024 * 256, 512, 0);

    if (pool->cq == NULL)
        err_exit ("can't create cq queue!");

    pthread_mutex_init (&pool->mutex, NULL);
    pthread_cond_init (&pool->cond, NULL);

    pool->num_threads = num_threads;
    pool->shutdown = 1;

    return 0;
}

static void *thread_route (void *arg) {
    pthread_t thread_id = pthread_self ();
    struct thread_param *param = (struct thread_param *) arg;
    struct thread_pool *pool = param->data;
    int ret = 0;

    while (1) {
        pthread_mutex_lock (&pool->mutex);

        if (pool->shutdown) {
            pthread_mutex_unlock (&pool->mutex);
            pthread_exit (NULL);
        }

        if (pool->num_tasks == 0)
            pthread_cond_wait (&pool->cond, &pool->mutex);

        // ret = cqueue_shift(pool->cq, &tm_bz, sizeof (struct item_bz));

        pthread_mutex_unlock (&pool->mutex);

        if (ret >= 0) {
            _u32_t *num_tasks = &pool->num_tasks;
            atom_sub (num_tasks, 1);

            //TODO: 这里调用工作函数
            //pool->task();
        }
    }

    pthread_exit (NULL);
    return NULL;
}

void thread_pool_run (struct thread_pool *pool, void *(*func) (void *)) {
    pthread_attr_t attr;
    int i, ret;

    pthread_attr_init (&attr);

    for (i = 0; i < pool->num_threads; i++) {
        pool->params[i].id = i;
        pool->params[i].data = pool;
        ret = pthread_create (&((pool->threads[i]).thread_id), &attr, func, &pool->params[i]);

        if (ret < 0) {
            err_exit ("can't create thread, error for %s!", strerror (errno));
        }
    }

    pool->shutdown = 0;
}

int thread_pool_free (struct thread_pool *pool) {
    if (pool->shutdown)
        return -1;

    pthread_cond_broadcast (&pool->cond);

    int i;
    for (i = 0; i < pool->num_threads; i++) {
        pthread_join ((pool->threads[i]).thread_id, NULL);
        thread_cleanup (&pool->threads[i]);
    }

    cqueue_free (pool->cq);
    free (pool->threads);
    free (pool->params);
    pthread_mutex_destroy (&pool->mutex);
    pthread_cond_destroy (&pool->cond);

    return 0;
}

/**
 * 线程以竞争的方式抢占任务
 */
int thread_pool_dispatchq (struct thread_pool *pool, void *task, int task_len) {
    int i, ret;
    pthread_mutex_lock (&pool->mutex);

    //尝试1000次, 将任务打进队列
    for (i = 0; i < 1000; i++) {
        ret = cqueue_unshift (pool->cq, task, task_len);

        if (ret < 0) {
            usleep (i);
            continue;
        } else
            break;
    }

    pthread_mutex_unlock (&pool->mutex);

    if (ret < 0)
        return -1;

    _u32_t *num_tasks = &pool->num_tasks;
    atom_add (num_tasks, 1);

    return pthread_cond_signal (&pool->cond);
}

/******************************************************************/
/* Reactor                                                        */
/******************************************************************/
typedef void e_cb_t (short events, void *arg);
struct eb_t;
struct eb_o;

enum e_opt {
    E_ONCE = 0x01,              /* 一次性事件, 当事件dipsatch到队列后,  激活后立该从eb_t移除, 并标记为ONCE */
    E_FREE = 0x02               /* 事件已经从eb_t实例被移除, 将其标记为E_FREE, 以便释放其存储空间 */
};

enum {
    E_QUEUE = 0x80              //标记是否已经在dispatchq队列
};

enum e_kide {
    E_READ = 0x01,              /* IO读 */
    E_WRITE = 0x02,             /* IO写 */
    E_TIMER = 0x04,             /* 定时器 */
    E_SIGNAL = 0x08,            /* 信号 */
    E_CHILD = 0x10,             /* 进程 */
    E_FLAG = 0x20               /* 用户自定义 */
};

struct ev {
    enum e_kide kide;           /* 事件类型 */
    enum e_opt opt;             /* 事件的标记 */
    e_cb_t *cb;                 /* 事件回调函数 */
    struct eb_t *ebt;           /* 指向eb_t结构体的实例 */
    void *arg;                  /* 事件参数 */

     TAILQ_ENTRY (ev) dispatchq;    /* TAILQ_ENTRY */
};

/* for io event */
struct ev_io {
    struct ev event;
    int fd;
};

/* for timer event */
struct ev_timer {
    struct ev event;
    struct timeval tv, remain;
     RB_ENTRY (ev_timer) timer_node;
};

/* signal event */
struct ev_signal {
    struct ev event;
    int signal;
};

/* for process */
struct ev_child {
    struct ev event;
    pid_t child;
};

/* for user-self event */
struct ev_flag {
    struct ev event;
    int flag;
     TAILQ_ENTRY (ev_flag) flags;
};

/**
 * 反应堆基类
 */
struct eb_t {
    const struct eb_o *ebo;     /* 操作eb_t实例的对象 */
    enum e_kide kides;          /* 所允许的支持事件类型 */
    unsigned int num;           /* 注册到eb_t实例的事件总数 */
    unsigned int numtimers;     /* 当前定时器的总数 */
    unsigned int maxtimers;     /* 最大定时器数 */
    struct timeval timerdebt;   /* 用于定时器相减 */
    int broken;                 /* 中断调用 */

     TAILQ_HEAD (, ev) dispatchq;   /* 事件就绪队列 */
     TAILQ_HEAD (, ev_flag) flags;  /* 自定义事件队列 */
     RB_HEAD (timer_tree, ev_timer) timers; /* 定时器队列 */
};

/**
 * ebt oprerations 反应堆的实例操作元
 */
struct eb_o {
    const char *name;
    enum e_kide kides;
    size_t ebtsz;               /* 从eb_t派生的结构体的大小 */

    int (*construct) (struct eb_t *);
    int (*destruct) (struct eb_t *);
    int (*init) (struct eb_t *);
    int (*loop) (struct eb_t *, const struct timeval *);
    int (*attach) (struct eb_t *, struct ev *);
    int (*detach) (struct eb_t *, struct ev *);
    int (*free) (struct eb_t *);
};

static int compare (struct ev_timer *a, struct ev_timer *b) {
    if (timercmp (&a->remain, &b->remain, <))
        return -1;
    else if (timercmp (&a->remain, &b->remain, >))
        return 1;

    if (a < b)
        return -1;
    else if (a > b)
        return 1;

    return 0;
}

RB_PROTOTYPE (timer_tree, ev_timer, timer_node, compare);
RB_GENERATE (timer_tree, ev_timer, timer_node, compare);

/******************************************************************/
/* epoll functions                                                */
/******************************************************************/
#define EP_SIZE 32000

#ifdef HAVE_SETFD
#define FD_CLOSEONEXEC(x) do {      \
    if (fcntl(x, F_SETFD, 1) == -1) \
        err_exit("fcntl error!");   \
} while(0)
#else
#define FD_CLOSEONEXEC(x)
#endif

struct ebt_epoll {
    struct eb_t ebt;

    struct epoll_event *epevents;
    struct ev_io **readev;
    struct ev_io **writev;
    int epfd;
    int epsz;
    int nfds;
};

static int epoll_init (struct eb_t *);
static int epoll_loop (struct eb_t *, const struct timeval *);
static int epoll_attach (struct eb_t *, struct ev *);
static int epoll_detach (struct eb_t *, struct ev *);
static int epoll_free (struct eb_t *);

static int eventq_in (struct ev *);

const struct eb_o ebo_epoll = {
    .name = "epoll",
    .kides = E_READ | E_WRITE | E_TIMER,
    .ebtsz = sizeof (struct ebt_epoll),
    .init = epoll_init,
    .loop = epoll_loop,
    .attach = epoll_attach,
    .detach = epoll_detach,
    .free = epoll_free
};

/**
 * epoll初始化
 * 
 * \param  ebt struct eb_t*
 * \return     int
 * 
 */
static int epoll_init (struct eb_t *ebt) {
    int epfd;
    struct epoll_event *epevents;
    struct ebt_epoll *epo = (struct ebt_epoll *) ebt;

    epfd = epoll_create (EP_SIZE);
    if (epfd < 0) {
        err_msg ("epoll_create failed!");
        return -1;
    }

    FD_CLOSEONEXEC (epfd);

    epevents = calloc (EP_SIZE, sizeof (struct epoll_event));
    if (epevents == NULL) {
        err_msg ("malloc failed!");
        return -1;
    }

    epo->epfd = epfd;
    epo->epevents = epevents;
    epo->epsz = EP_SIZE;

    epo->readev = calloc (EP_SIZE, sizeof (struct ev *));
    if (epo->readev == NULL)
        return -1;

    epo->writev = calloc (EP_SIZE, sizeof (struct ev *));

    /* print ebt infomations */
    err_debug ("ebt_epoll: [epfd=%d] [epevents=%p] [epsz=%d] [nfds=%d] [readev=%p] [writev=%p]", epo->epfd, epo->epevents, epo->epsz, epo->nfds, epo->readev, epo->writev);
    return 0;
}

/**
 * ebt事件循环
 * 
 * \param  ebt struct eb_t *
 * \param  tv  struct timeval *
 * \return     int
 * 
 */
static int epoll_loop (struct eb_t *ebt, const struct timeval *tv) {
    struct ebt_epoll *epo = (struct ebt_epoll *) ebt;
    int cnt;
    int timeout;

    if (tv != NULL)
        timeout = tv->tv_sec * 1000 + (tv->tv_usec + 999) / 1000;
    else
        timeout = 0;

    cnt = epoll_wait (epo->epfd, epo->epevents, epo->epsz, timeout);

    if (cnt < 0)
        return errno == EINTR ? 0 : -1;

    epo->nfds = cnt;

    int i;
    for (i = 0; i < cnt; ++i) {
        struct epoll_event *ev = epo->epevents + i;

        int fd = (uint32_t) ev->data.u64;

        //这里有一个问题,当按下ctrl+c终止连接时, got的值总是: got = E_WRITE | E_READ
        int got = (ev->events & (EPOLLOUT | EPOLLERR | EPOLLHUP) ? E_WRITE : 0)
            | (ev->events & (EPOLLIN | EPOLLERR | EPOLLHUP) ? E_READ : 0);

        if (got & E_READ)
            eventq_in ((struct ev *) epo->readev[fd]);

        if (got & E_WRITE)
            eventq_in ((struct ev *) epo->writev[fd]);
    }

    return 0;
}

static int _resize (struct ebt_epoll *epo, int max) {
    if (max > epo->epsz) {
        struct ev_io **readev, **writev;
        int newsz = epo->epsz;

        newsz <<= 1;

        readev = realloc (epo->readev, newsz * sizeof (struct ev *));
        if (readev == NULL)
            return -1;

        writev = realloc (epo->writev, newsz * sizeof (struct ev *));
        if (writev == NULL) {
            free (readev);
            return -1;
        }

        epo->readev = readev;
        epo->writev = writev;

        memset (readev + epo->epsz, 0, (newsz - epo->epsz) * sizeof (struct ev *));
        memset (writev + epo->epsz, 0, (newsz - epo->epsz) * sizeof (struct ev *));

        epo->epsz = newsz;

        return 0;
    }

    return -1;
}

static int epoll_attach (struct eb_t *ebt, struct ev *e) {
    struct epoll_event ev;
    struct ebt_epoll *epo = (struct ebt_epoll *) ebt;
    struct ev_io *evf = (struct ev_io *) e;

    /* check for duplicate attachments */
    if (epo->readev[evf->fd] != NULL && (epo->readev[evf->fd]->event.kide & e->kide)) {
        errno = EBUSY;
        return -1;
    }
    if (epo->writev[evf->fd] != NULL && (epo->writev[evf->fd]->event.kide & e->kide)) {
        errno = EBUSY;
        return -1;
    }

    /* make room for this event ? */
    if ((unsigned int) evf->fd >= epo->epsz && _resize (epo, evf->fd))
        return -1;

    int op = EPOLL_CTL_ADD;
    int events = 0;

    events = (evf->event.kide & E_READ ? EPOLLIN | EPOLLET : 0) | (evf->event.kide & E_WRITE ? EPOLLOUT : 0);

    if (epo->readev[evf->fd] != NULL) {
        events |= EPOLLIN;
        op = EPOLL_CTL_MOD;
    }
    if (epo->writev[evf->fd] != NULL) {
        events |= EPOLLOUT;
        op = EPOLL_CTL_MOD;
    }

    ev.data.u64 = evf->fd;
    ev.events = events;

    if (epoll_ctl (epo->epfd, op, evf->fd, &ev) == -1) {
        err_msg ("epoll_ctl error: [errno=%d] [errstr=%s]", errno, strerror (errno));
        return -1;
    }
    //debug info
    err_debug ("ev: [ev=%p] [fd=%d] [op=%s] [events=%s] [kide=%s] [cb=%p]",
               e,
               evf->fd,
               op == EPOLL_CTL_ADD ? "EPOLL_CTL_ADD" : "EPOLL_CTL_MOD",
               ev.events ^ (EPOLLIN | EPOLLOUT) ?
               (ev.events & EPOLLOUT ? "EPOLLOUT" :
                (ev.events & EPOLLIN) ? "EPOLLIN" : "") : "EPOLLIN|EPOLLOUT",
               e->kide ^ (E_READ | E_WRITE) ? (e->kide & E_WRITE ? "E_WRITE" : (e->kide & E_READ) ? "E_READ" : "") : "E_READ|E_WRITE", e->cb);

    if (evf->event.kide & E_READ)
        epo->readev[evf->fd] = evf;

    if (evf->event.kide & E_WRITE)
        epo->writev[evf->fd] = evf;

    return 0;
}

static int epoll_detach (struct eb_t *ebt, struct ev *e) {
    struct epoll_event ev;
    struct ebt_epoll *epo = (struct ebt_epoll *) ebt;
    struct ev_io *evf = (struct ev_io *) e;

    int events = (e->kide & E_READ ? EPOLLIN : 0) | (e->kide & E_WRITE ? EPOLLOUT : 0);
    int op = EPOLL_CTL_DEL;
    int rd = 1;
    int wd = 1;

    if (events ^ (EPOLLIN | EPOLLOUT)) {
        if ((events & EPOLLIN) && epo->writev[evf->fd] != NULL) {
            wd = 0;
            events = EPOLLOUT;
            op = EPOLL_CTL_MOD;
        } else if ((events & EPOLLOUT) && epo->readev[evf->fd] != NULL) {
            rd = 0;
            events = EPOLLIN | EPOLLET;
            op = EPOLL_CTL_MOD;
        }
    }

    ev.events = events;
    ev.data.u64 = evf->fd;

    if (epoll_ctl (epo->epfd, op, evf->fd, &ev) < 0) {
        err_msg ("epoll_ctl error: [errno=%d] [errstr=%s]", errno, strerror (errno));
        return -1;
    }
    //debug info
    err_debug ("ev: [ev=%p] [fd=%d] [op=%s] [events=%s]",
               e,
               evf->fd,
               op == EPOLL_CTL_DEL ? "EPOLL_CTL_DEL" : "EPOLL_CTL_MOD",
               ev.events ^ (EPOLLIN | EPOLLOUT) ? (ev.events & EPOLLOUT ? "EPOLLOUT" : (ev.events & EPOLLIN) ? "EPOLLIN" : "") : "EPOLLIN|EPOLLOUT");

    if (rd)
        epo->readev[evf->fd] = NULL;
    if (wd)
        epo->writev[evf->fd] = NULL;

    return 0;
}

static int epoll_free (struct eb_t *ebt) {
    struct ebt_epoll *epo = (struct ebt_epoll *) ebt;

    free (epo->readev);
    free (epo->writev);
    free (epo->epevents);
    close (epo->epfd);

    return 0;
}

/******************************************************************/
/* event functions                                                */
/******************************************************************/
static void ev_init (struct ev *e, enum e_kide kide, e_cb_t * cb, void *arg) {
    e->kide = kide;
    e->cb = cb;
    e->arg = arg;
}

void ev_opt (struct ev *e, enum e_opt opt) {
    assert (e != NULL);
    e->opt |= opt;
}

struct ev *ev_read (int fd, e_cb_t * cb, void *arg) {
    struct ev_io *event;
    event = calloc (1, sizeof (*event));

    if (!event) {
        err_msg ("calloc failed!");
        return NULL;
    }

    ev_init ((struct ev *) event, E_READ, cb, arg);
    event->fd = fd;

    return (struct ev *) event;
}

struct ev *ev_write (int fd, e_cb_t * cb, void *arg) {
    struct ev_io *event;
    event = calloc (1, sizeof (*event));

    if (!event) {
        err_msg ("calloc failed!");
        return NULL;
    }

    ev_init ((struct ev *) event, E_WRITE, cb, arg);
    event->fd = fd;

    return (struct ev *) event;
}

struct ev *ev_timer (const struct timeval *tv, e_cb_t * cb, void *arg) {
    struct ev_timer *event;
    event = calloc (1, sizeof (*event));

    if (!event) {
        err_msg ("calloc failed!");
        return NULL;
    }

    ev_init ((struct ev *) event, E_TIMER, cb, arg);
    event->tv = *tv;

    return (struct ev *) event;
}

struct ev *ev_signal (int sig, e_cb_t * cb, void *arg) {
    struct ev_signal *event;
    event = calloc (1, sizeof (*event));

    if (!event) {
        err_msg ("calloc failed!");
        return NULL;
    }

    ev_init ((struct ev *) event, E_SIGNAL, cb, arg);
    event->signal = sig;

    return (struct ev *) event;
}

struct ev *ev_child (pid_t pid, e_cb_t * cb, void *arg) {
    struct ev_child *event;
    event = calloc (1, sizeof (*event));

    if (!event) {
        err_msg ("calloc failed!");
        return NULL;
    }

    ev_init ((struct ev *) event, E_CHILD, cb, arg);
    event->child = pid;

    return (struct ev *) event;
}

struct ev *ev_flag (int flag, e_cb_t * cb, void *arg) {
    struct ev_flag *event;
    event = calloc (1, sizeof (*event));

    if (!event) {
        err_msg ("calloc failed!");
        return NULL;
    }
    ev_init ((struct ev *) event, E_FLAG, cb, arg);
    event->flag = flag;

    return (struct ev *) event;
}

void ev_free (struct ev *e) {
    free (e);
}

/******************************************************************/
/* timer functions                                                */
/******************************************************************/
static int timer_insert (struct eb_t *ebt, struct ev_timer *evt) {
    if (evt->event.kide & E_TIMER) {
        RB_INSERT (timer_tree, &ebt->timers, evt);
        ebt->numtimers++;
        return 0;
    }
    return -1;
}

static int timer_remove (struct eb_t *ebt, struct ev_timer *evt) {
    if (evt->event.kide & E_TIMER) {
        RB_REMOVE (timer_tree, &ebt->timers, evt);
        ebt->numtimers--;
        return 0;
    }
    return -1;
}

static int timer_reset (struct ev_timer *evt) {
    if (!(evt->event.kide & E_TIMER))
        return -1;

    if (timer_remove (evt->event.ebt, evt) < 0)
        return -1;

    struct timeval zero = { 0, 0 };

    timeradd (&evt->remain, &evt->tv, &evt->remain);
    if (timercmp (&evt->remain, &zero, <) < 0)
        evt->remain = zero;

    if (timer_insert (evt->event.ebt, evt) < 0)
        return -1;

    return 0;
}

static int timer_attach (struct eb_t *ebt, struct ev_timer *evt) {
    struct ev_timer *ev_t;
    if (ebt->timerdebt.tv_sec != 0 || ebt->timerdebt.tv_usec != 0) {
        RB_FOREACH (ev_t, timer_tree, &ebt->timers) {
            timersub (&ev_t->remain, &ebt->timerdebt, &ev_t->remain);
        }

        timerclear (&ebt->timerdebt);
    }
    //刚加入队列时, 定时器剩余时间等于定时时间
    evt->remain = evt->tv;
    return timer_insert (ebt, evt);
}

static int timer_detach (struct eb_t *ebt, struct ev_timer *evt) {
    if (!(evt->event.kide & E_TIMER))
        return -1;

    if (timer_remove (ebt, evt) < 0)
        return -1;

    if (ebt->numtimers == 0)
        timerclear (&ebt->timerdebt);

    return 0;
}

static int wait_for_events (struct eb_t *ebt, const struct timeval *start, struct timeval *end) {
    struct ev_timer *timer = NULL;
    struct ev_flag *evf;
    struct timeval tv;

    /* 如果存在用户自定义事件, 也放到dispatchq队列 */
    TAILQ_FOREACH (evf, &ebt->flags, flags) {
        eventq_in ((struct ev *) evf);
    }

    //确保队列中所有事件都dispatch完毕
    if (!TAILQ_EMPTY (&ebt->dispatchq))
        return 0;

    /* 定时器处理 */
    if (ebt->numtimers != 0) {
        static const struct timeval zero = { 0, 0 };

        timer = RB_MIN (timer_tree, &ebt->timers);
        timersub (&timer->remain, &ebt->timerdebt, &tv);

        /* 反应堆dispatch */
        if (timercmp (&tv, &zero, >=) && ebt->ebo->loop (ebt, &tv) < 0)
            return -1;
    } else {
        if (ebt->ebo->loop (ebt, NULL) < 0)
            return -1;
    }

    gettimeofday (end, NULL);

    if (timer == NULL)
        return 0;
    timersub (end, start, &tv);
    timeradd (&ebt->timerdebt, &tv, &ebt->timerdebt);
    if (timercmp (&ebt->timerdebt, &timer->remain, <))
        return 0;

    /* 更新所有定时器 */
    RB_FOREACH (timer, timer_tree, &ebt->timers) {
        timersub (&timer->remain, &ebt->timerdebt, &timer->remain);

        if (timer->remain.tv_sec < 0 || (timer->remain.tv_sec == 0 && timer->remain.tv_usec <= 0)) {
            eventq_in ((struct ev *) timer);
        }
    }

    timerclear (&ebt->timerdebt);

    return 0;
}

/**
 * 
 * 触发队列中的就绪事件
 * 
 * @param ebt struct eb_t*
 * 
 */
static void dispatch_queue (struct eb_t *ebt) {
    struct ev *e;

    if (!TAILQ_EMPTY (&ebt->dispatchq)) {
        enum e_opt opt;
        int num;
        for (e = TAILQ_FIRST (&ebt->dispatchq); e; e = TAILQ_FIRST (&ebt->dispatchq)) {
            /* 从队列移除 */
            TAILQ_REMOVE (&ebt->dispatchq, e, dispatchq);
            e->opt &= ~E_QUEUE; //这里有一点问题, 如果flag事件不是E_ONCE类型的话, 会无限激活, 无限加入dispatchq队列

            switch (e->kide) {
            case E_READ:
            case E_WRITE:
                num = ((struct ev_io *) e)->fd;
                break;

            default:
                num = -1;
                break;
            }

            /* 如果是一次性的事件? 立刻移除 */
            opt = e->opt;
            e->opt &= ~E_FREE;  //这里移除FREE标记, 先将事件从队列踢出, 但不会即释放其空间, 不然无法回调cb函数(但是会导致后面不能free)
            if (e->opt & E_ONCE)
                ev_detach (e, ebt);

            /* 调用事件处理函数 */
            if (e != NULL)
                e->cb (num, e->arg);

            /* 如果事件处理函数中, 删除了该事件? */
            if (e->ebt == NULL)
                return;

            /* 如果事件从队列被删除了, 要释放其内存空间? */
            if (opt & (E_ONCE | E_FREE))
                ev_free (e);
            else if (e->kide == E_TIMER)
                //定时器被触发开后, 重新设置并投递定时器队列
                timer_reset ((struct ev_timer *) e);
        }
    }
}

/******************************************************************/
/* event queue function                                           */
/******************************************************************/

/**
 * 注册事件e到ebt例程
 * 
 * \param  e   struct ev*
 * \param  ebt struct eb_t*
 * \return     int
 * 
 */
int ev_attach (struct ev *e, struct eb_t *ebt) {
    if (!(e->kide & ebt->kides)) {
        errno = ENOTSUP;
        return -1;
    }

    if (e->ebt != NULL) {
        errno = EBUSY;
        return -1;
    }

    switch (e->kide) {
    case E_TIMER:
        if (timer_attach (ebt, (struct ev_timer *) e) < 0)
            return -1;
        break;

    case E_FLAG:
        TAILQ_INSERT_TAIL (&ebt->flags, (struct ev_flag *) e, flags);
        break;

    default:
        if (ebt->ebo->attach (ebt, e) < 0)
            return -1;
        break;
    }
    ebt->num++;
    e->ebt = ebt;

    return 0;
}

int ev_detach (struct ev *e, struct eb_t *ebt) {
    if (e->ebt == NULL) {
        errno = EINVAL;
        return -1;
    }

    switch (e->kide) {
    case E_TIMER:
        if (timer_detach (ebt, (struct ev_timer *) e) < 0)
            return -1;
        break;

    case E_FLAG:
        {
            TAILQ_REMOVE (&ebt->flags, (struct ev_flag *) e, flags);
            break;
        }

    default:
        if (ebt->ebo->detach (ebt, e) < 0)
            return -1;
        break;
    }

    if (e->opt & E_QUEUE) {
        TAILQ_REMOVE (&ebt->dispatchq, e, dispatchq);
        e->opt &= ~E_QUEUE;
    }

    ebt->num--;
    e->ebt = NULL;

    if (e->opt & E_FREE)
        ev_free (e);

    return 0;
}

/**
 * 将事件e加入到dispatchq队列
 * 
 * \param e struct ev*
 * 
 */
static int eventq_in (struct ev *e) {
    if (!e || e->opt & E_QUEUE)
        return -1;

    TAILQ_INSERT_TAIL (&e->ebt->dispatchq, e, dispatchq);
    e->opt |= E_QUEUE;

    return 0;
}

/******************************************************************/
/* ebt functions                                                  */
/******************************************************************/
struct eb_t *ebt_new (enum e_kide kides) {
    static const struct eb_o *ebo_map[] = {
        &ebo_epoll,
        NULL
    };
    struct eb_t *ebt;
    const struct eb_o **ebo;

    /* 寻找对应支持事件的操作实例 */
    for (ebo = ebo_map; *ebo; ebo++) {
        if ((((*ebo)->kides | E_TIMER | E_FLAG) & kides) != kides)
            continue;

        ebt = malloc ((*ebo)->ebtsz);
        if (ebt == NULL)
            return NULL;

        memset (ebt, 0, (*ebo)->ebtsz);
        ebt->kides = kides;
        ebt->ebo = *ebo;

        //初始化事件队列
        TAILQ_INIT (&ebt->flags);
        TAILQ_INIT (&ebt->dispatchq);
        RB_INIT (&ebt->timers);

        /* 初始化ebt派生结构 */
        if (ebt->ebo->init (ebt) < 0) {
            free (ebt);
            continue;
        }

        return ebt;
    }
    errno = ENOTSUP;

    return NULL;
}

int ebt_loop (struct eb_t *ebt) {
    struct timeval tv[2];
    int i, ret;

    ebt->broken = 0;

    /* 如果loop存在construct, 先运行 */
    if (ebt->ebo->construct != NULL && ebt->ebo->construct (ebt) < 0)
        return -1;

    i = 0;
    gettimeofday (tv + i, NULL);

    while (ebt->num > 0 && !ebt->broken) {
        /* 等待事件发生 */
        ret = wait_for_events (ebt, tv + i, tv + (!i));
        if (ret < 0)
            break;

        /* 激活队列中的就绪事件 */
        dispatch_queue (ebt);

        i = !i;
    }

    /* ebt循环结束后, 析构 */
    if (ebt->ebo->destruct != NULL && ebt->ebo->destruct (ebt) < 0)
        return -1;

    return ret;
}

void ebt_break (struct eb_t *ebt) {
    ebt->broken = 1;
}

void ebt_free (struct eb_t *ebt) {
    ebt->ebo->free (ebt);
    free (ebt);
}

/******************************************************************/
/* network                                                        */
/******************************************************************/
enum r_type {
    E_START = 0,
    E_CONNECT = 1,
    E_RECEIVE = 2,
    E_TIMEOUT = 3,
    E_CLOSE = 4,
    E_SHUTDOWN = 5,
    E_ERROR = 6
};

enum s_type {
    E_CLOSED = 0,
    E_CLOSING = 1,
    E_CONNECTING = 2,
    E_CONNECTED = 3,
    E_RECEIVING = 4,
    E_RECEIVED = 5,
    E_STARTED = 6,
    E_STARTING = 7,
    E_SHUTDOWNED = 8
};

#define E_MAX_ETYPE       32
#define E_BACK_LOG        512
#define E_TIMEOUT_SEC     0
#define E_TIMEOUT_USEC    3000000
#define E_NUM_REACTORS    4
#define E_NUM_FACTORIES   2
#define E_MASTER_REACTOR  E_NUM_REACTORS
#define E_TCP_PACKAGE_LEN 8129
#define E_BUFFER_SIZE     512

struct buf_Trunk {
    int fd;
    char *data;
    uint16_t len;
};

struct EventData {
    int fd;                     //文件描述符
    int type;                   //事件类型(srv)
    uint16_t len;               //实际从fd读取到的长度
    uint16_t from_reactor_id;   //所属反应堆
    char buf[E_TCP_PACKAGE_LEN];    //缓存从fd读取的数据
    char *udata;                //带外
};

struct sa {
    socklen_t len;
    union {
        struct sockaddr sa;
        struct sockaddr_in sin;
    } u;
#ifdef WITH_IPV6
    struct sockaddr_in6 sin6;
#endif
};

struct reactor {
    struct eb_t *base;
    struct factory *factory;
    void *ptr;
    int reactor_id;
    int status;
};

struct child_reactor {
    struct reactor reactor;
     Vec (struct buf_Trunk) buf;
};

struct master_reactor {
    struct reactor reactor;
    pthread_t thread_id;
};

struct factory {
    int factory_id;
    int status;
    int max_request;

    void *ptr;
    int (*task) (struct EventData *);
};

struct settings {
    uint16_t backlog;
    uint8_t daemonize;
    uint8_t num_reactors;
    uint8_t num_factories;

    int sock_cli_bufsize;       //client的socket缓存设置
    int sock_srv_bufsize;       //server的socket缓存设置

    int max_conn;
    int max_request;
    int timeout_sec;
    int timeout_usec;
};

typedef int (*e_handle_t) (struct EventData *);

struct ebt_srv {
    struct settings settings;   //应用服务配置
    struct master_reactor mreactor; //主反应堆
    struct thread_pool reactor_pool;    //子反应堆线程池
    struct thread_pool factory_pool;    //任务调度线程池
    struct sa sa;               //服务器句柄
    int pipe[2];                //通信管道
    int sfd;                    //服务器套接字
    int status;                 //服务器状态
    e_handle_t handles[E_MAX_ETYPE];    //注册到服务对象的回调 
};

#define ebt_srv_get_thread(srv, w, n)   (srv->w.threads[n])
#define ebt_srv_get_param(srv, w, n)    (srv->w.params[n])
#define ebt_srv_get_reactor(srv, n)     (struct reactor *) (ebt_srv_get_thread(srv, reactor_pool, n).data.ptr)
#define ebt_srv_get_factory(srv, n)     (struct factory *) (ebt_srv_get_thread(srv, factory_pool, n).data.ptr)

static int nWrite (int fd, char *buf, int len) {
    int nwrite = 0;
    int total_len = 0;

    while (total_len != len) {
        nwrite = write (fd, buf, len - total_len);
        if (nwrite == -1)
            return total_len;

        if (nwrite == -1) {
            if (errno == EINTR)
                continue;
            else if (errno == EAGAIN) {
                sleep (1);
                continue;
            } else
                return -1;
        }
        total_len += nwrite;
        buf += nwrite;
    }

    return total_len;
}

static int nRead (int fd, char *buf, int len) {
    int n = 0, nread;

    while (1) {
        nread = read (fd, buf + n, len - n);
        if (nread < 0) {
            if (errno == EINTR)
                continue;
            break;
        } else if (nread == 0) {
            return 0;
        } else {
            n += nread;

            if (n == len)
                break;

            continue;
        }
    }
    return n;
}

static void ebt_srv_settings_init (struct settings *settings) {
    settings->backlog = E_BACK_LOG;
    settings->daemonize = 0;
    settings->num_reactors = E_NUM_REACTORS;
    settings->num_factories = E_NUM_FACTORIES;

    settings->timeout_sec = E_TIMEOUT_SEC;
    settings->timeout_usec = E_TIMEOUT_USEC;
}

static int ebt_srv_reactors_init (struct ebt_srv *srv) {
    int i;
    int size = srv->settings.num_reactors;
    struct child_reactor *reactors;

    reactors = calloc (size, sizeof (struct child_reactor));

    if (!reactors)
        err_exit ("can't allocate memory for reactor pool!");

    //初始化线程池, 并为线程分配反应堆
    thread_pool_init (&srv->reactor_pool, size);

    for (i = 0; i < size; i++) {
        reactors[i].reactor.reactor_id = i;
        reactors[i].reactor.ptr = srv;

        srv->reactor_pool.threads[i].data.ptr = &reactors[i];
    }

    return 0;
}

static int ebt_srv_factories_init (struct ebt_srv *srv) {
    int i;
    int size = srv->settings.num_factories;
    struct factory *factories;

    factories = calloc (size, sizeof *factories);

    if (!factories)
        err_exit ("can't allocate memory for factory  pool!");

    thread_pool_init (&srv->factory_pool, size);

    //为线程分配任务调度器实例
    for (i = 0; i < size; i++) {
        factories[i].factory_id = i;
        factories[i].ptr = srv;

        srv->factory_pool.threads[i].data.ptr = &factories[i];
    }

    return 0;
}
static void ebt_srv_event_nofitify (short num, struct ebt_srv *srv) {
    int r;
    int fd = num;
    char buf[512];

    r = read (fd, buf, sizeof (buf));

    err_msg ("read: buf=%s | r=%d", buf, r);
}

static void ebt_srv_event_close (short num, struct ebt_srv *srv) {
    struct EventData edata;
    struct reactor *reactor;
    struct ev_io *evr, *evw;
    int r;

    r = nRead (srv->pipe[0], (char *) &edata, sizeof (edata));

    if (r < 0)
        return;

    reactor = ebt_srv_get_reactor (srv, edata.from_reactor_id);
    evr = ((struct ebt_epoll *) (reactor->base))->readev[edata.fd];
    evw = ((struct ebt_epoll *) (reactor->base))->writev[edata.fd];

    //回调close
    if (srv->handles[E_CLOSE])
        srv->handles[E_CLOSE] (&edata);

    if (evr) {
        ev_opt ((struct ev *) evr, E_FREE);
        ev_detach ((struct ev *) evr, reactor->base);
    }

    if (evw) {
        ev_opt ((struct ev *) evw, E_FREE);
        ev_detach ((struct ev *) evw, reactor->base);
    }

    close (edata.fd);
}

static void ebt_srv_close (struct ebt_srv *srv, struct EventData *edata) {
    if (edata->from_reactor_id > srv->settings.num_reactors) {
        err_msg ("fromID > num_reactors");
        return;
    }

    int r;
    struct EventData ed;
    memcpy (&ed, edata, sizeof (struct EventData));
    r = nWrite (srv->pipe[1], (char *) &ed, sizeof (ed));

    if (r < 0)
        err_msg ("childThread write to pip fail, r=%d | errno=%d | errstr=%s", r, errno, strerror (errno));
}

static void *ebt_srv_poll_routine (void *arg) {
    int n;
    struct thread_param *param;
    struct thread_entity *thread;
    struct thread_pool *reactor_pool;
    struct reactor *reactor;
    struct ebt_srv *srv;
    struct ev *ev;

    param = (struct thread_param *) arg;
    n = param->id;
    reactor_pool = param->data;
    thread = &reactor_pool->threads[n];
    reactor = (struct reactor *) (thread->data.ptr);
    srv = reactor->ptr;
    reactor->base = ebt_new (E_READ | E_WRITE);

    err_msg ("child reactor thread starting: threadId=%d | reactorId=%d |reactorEPFD=%d", thread->thread_id, reactor->reactor_id, ((struct ebt_epoll *) (reactor->base))->epfd);

    ev = ev_read (thread->notify_recv_fd, (void (*)(short, void *)) ebt_srv_event_nofitify, srv);

    ev_attach (ev, reactor->base);
    ebt_loop (reactor->base);
    ebt_free (reactor->base);

    return NULL;
}

static int ebt_srv_poll_start (struct ebt_srv *srv) {
    int i;
    int size = srv->settings.num_reactors;

    for (i = 0; i < size; i++) {
        //TODO:
    }

    thread_pool_run (&srv->reactor_pool, ebt_srv_poll_routine);

    return 0;
}

static void ebt_srv_poll_event_process (short num, struct reactor *reactor) {
    int fd = num;
    int n, pos, ret, err = 0;
    struct factory *factory;
    struct EventData edata;
    struct ebt_srv *srv;
    struct buf_Trunk *trunk;
    char buf[E_TCP_PACKAGE_LEN] = { 0 };

    srv = (struct ebt_srv *) (reactor->ptr);

  READ:
    n = nRead (fd, buf, sizeof (buf));

    if (errno == EAGAIN)
        err = EAGAIN;

    if (n == 0) {
        edata.fd = fd;
        edata.len = sizeof (fd);
        edata.from_reactor_id = reactor->reactor_id;
        ebt_srv_close (srv, &edata);
    } else if (n > 0) {
        trunk = (struct buf_Trunk *) malloc (E_BUFFER_SIZE);    //for test
        if (!trunk) {
            err_msg ("allocate memory fail");
            return;
        }

        memset (trunk, 0, sizeof (struct buf_Trunk));

        trunk->fd = fd;
        trunk->len = n;
        trunk->data = (char *) trunk + sizeof (struct buf_Trunk);

        //拷贝数据
        memcpy (trunk->data, buf, E_BUFFER_SIZE - sizeof (struct buf_Trunk));

        //使用fd取模来散列分配
        int pos = fd % srv->settings.num_factories;

        if (cqueue_unshift (srv->factory_pool.threads[pos].cq, trunk, E_BUFFER_SIZE) < 0) {
            err_msg ("unshift buf fail: pos=%d", pos);
            return;
        } else {
            //推入队列成功后, 阻塞在发送通知信息
            uint64_t flag = 1;
            ret = write (srv->factory_pool.threads[pos].notify_send_fd, &flag, sizeof (flag));

            if (ret < 0)
                err_msg ("notify fail!");
        }

        //释放临时数据
        free (trunk);

        //EPOLL的ET模式, 缓冲区还有数据未读完
        if (err == EAGAIN)
            goto READ;
    } else {
        err_debug ("abort");
    }
}

static void *ebt_srv_factory_routine (void *arg) {
    int n, ret;
    uint64_t flag;
    struct thread_param *param;
    struct thread_entity *thread;
    struct thread_pool *factory_pool;
    struct factory *factory;
    struct EventData edata;
    struct buf_Trunk *trunk;
    struct ebt_srv *srv;

    param = (struct thread_param *) arg;
    n = param->id;
    factory_pool = param->data;
    thread = &factory_pool->threads[n];
    factory = (struct factory *) (thread->data.ptr);
    trunk = (struct buf_Trunk *) malloc (E_BUFFER_SIZE);
    srv = factory->ptr;

    while (srv->status) {
        if (cqueue_shift (thread->cq, trunk, E_BUFFER_SIZE) > 0) {
            edata.fd = trunk->fd;
            edata.type = E_RECEIVED;
            edata.len = trunk->len;
            memset (edata.buf, 0, sizeof (edata.buf));
            memcpy (edata.buf, trunk->data, trunk->len);

            if (factory->task)
                factory->task (&edata);
            else
                err_msg ("no such handler!");
        } else {
            ret = read (thread->notify_recv_fd, &flag, sizeof (flag));
            if (ret < 0)
                err_msg ("recv fail!");
        }
    }

    return NULL;
}

static int ebt_srv_factory_start (struct ebt_srv *srv) {
    int i;
    int size = srv->settings.num_factories;
    struct factory *factory;

    for (i = 0; i < srv->settings.num_factories; i++) {
        //TODO:
        factory = ebt_srv_get_factory (srv, i);
        factory->task = srv->handles[E_RECEIVE];
    }

    thread_pool_run (&srv->factory_pool, ebt_srv_factory_routine);

    return 0;
}

static void ebt_srv_factory_event_process (short num, struct ebt_srv *srv) {

}

static void ebt_srv_accept (short sfd, struct ebt_srv *srv) {
    int r, n, new_fd;
    struct ev *ev;
    struct sa sa;
    struct EventData edata;
    struct reactor *reactor;

    new_fd = accept (sfd, &sa.u.sa, &sa.len);

    if (new_fd == -1) {
        err_msg ("accept error, error: %s", strerror (errno));
    } else {
        set_nonblock (new_fd, 1);
        srv->sa = sa;

        //取模散列
        n = new_fd % srv->settings.num_reactors;
        reactor = ebt_srv_get_reactor (srv, n);

        //将new_fd添加到子反应堆
        ev = ev_read (new_fd, (void (*)(short, void *)) ebt_srv_poll_event_process, reactor);
        r = ev_attach (ev, reactor->base);

        if (r < 0)
            err_msg ("masterThread dispatched event fail [cli_fd=%d] [reactor_id=%d]!", new_fd, reactor->reactor_id);

        edata.fd = new_fd;
        edata.type = E_CONNECTED;
        edata.len = sizeof (new_fd);
        edata.from_reactor_id = reactor->reactor_id;

        //回调connent方法
        srv->handles[E_CONNECT] (&edata);
    }
}

/**
 * 创建一个srv实例
 */
int ebt_srv_create (struct ebt_srv *srv) {
    int r = 0;

    memset (srv, 0, sizeof *srv);
    //初始化配置信息
    ebt_srv_settings_init (&srv->settings);

    if (pipe (srv->pipe) < 0) {
        err_msg ("can't create pipe!");
        return -1;
    }
    set_nonblock (srv->pipe[0], 1);
    set_nonblock (srv->pipe[1], 1);

    //初始化反应堆线程池和任务调度线程池
    r = ebt_srv_reactors_init (srv);
    if (r < 0) {
        err_msg ("can't create child reactor thread pool!");
        return -1;
    }

    r = ebt_srv_factories_init (srv);
    if (r < 0) {
        err_msg ("can't create factory thread pool!");
        return -1;
    }

    return 0;
}

int ebt_srv_listen (struct ebt_srv *srv, short port) {
    int sfd, on = 1, af;
    struct sa sa;

#ifdef WITH_IPV6
    af = PF_INET6;
#else
    af = PF_INET;
#endif

    if (((sfd) = socket (af, SOCK_STREAM, 6)) == -1)
        err_exit ("create socket fail: %s", strerror (errno));

    set_nonblock (sfd, 1);
    setsockopt (sfd, SOL_SOCKET, SO_REUSEADDR, (char *) &on, sizeof (on));

#ifdef WITH_IPV6
    sa.u.sin6.sin6_family = af;
    sa.u.sin6.sin6_port = htons (port);
    sa.u.sin6.sin6_addr = in6addr_any;
    sa.len = sizeof (sa.u.sin6);
#else
    sa.u.sin.sin_family = af;
    sa.u.sin.sin_port = htons (port);
    sa.u.sin.sin_addr.s_addr = INADDR_ANY;
    sa.len = sizeof (sa.u.sin);
#endif

    if (bind (sfd, &sa.u.sa, sa.len) < 0)
        err_exit ("bind: [af=%d] [port=%d] [err=%s]", af, port, strerror (errno));

    if (listen (sfd, 16) < 0)
        err_exit ("listen: [af=%d] [port=%d] [err=%s]", af, port, strerror (errno));

    err_msg ("server listening on port:%d", port);

    srv->sfd = sfd;

    return 0;
}

/**
 * 启动一个srv实例
 */
int ebt_srv_start (struct ebt_srv *srv) {
    struct EventData edata;
    struct timeval tv;
    struct eb_t *mbase;
    struct ev *ev[2];
    int r = 0;

    //作为守护进程
    if (srv->settings.daemonize > 0) {
        if (daemon (0, 0) < 0)
            return -1;
    }

    srv->status = 1;

    r = ebt_srv_poll_start (srv);

    if (r < 0)
        err_exit ("reactor threads start polling fail.");

    r = ebt_srv_factory_start (srv);

    if (r < 0)
        err_exit ("factory threads start working fail.");

    mbase = ebt_new (E_READ | E_WRITE);

    if (!mbase)
        err_exit ("can't create master reactor for master thread.");

    srv->mreactor.reactor.base = mbase;
    srv->mreactor.reactor.reactor_id = E_MASTER_REACTOR;    //标记为主master反应堆
    srv->mreactor.thread_id = pthread_self ();

    if (srv->sfd <= 0)
        return -1;

    ev[0] = ev_read (srv->sfd, (void (*)(short, void *)) ebt_srv_accept, srv);
    ev[1] = ev_read (srv->pipe[0], (void (*)(short, void *)) ebt_srv_event_close, srv);

    ev_attach (ev[0], mbase);
    ev_attach (ev[1], mbase);

    edata.fd = srv->sfd;
    edata.from_reactor_id = E_MASTER_REACTOR;
    edata.type = E_STARTED;

    if (srv->handles[E_START]) {
        srv->handles[E_START] (&edata);
    }

    ebt_loop (mbase);

    if (srv->handles[E_SHUTDOWN]) {
        edata.type = E_SHUTDOWNED;
        srv->handles[E_SHUTDOWN] (&edata);
    }

    return 0;
}

int ebt_srv_on (struct ebt_srv *srv, enum r_type type, e_handle_t cb) {
    if (!cb || type >= E_MAX_ETYPE)
        return -1;
    else
        srv->handles[type] = cb;

    return 0;
}

void ebt_srv_free (struct ebt_srv *srv) {

}

//////////////////////TEST//////////////////
#include <sys/stat.h>
void printEbtsrv (struct ebt_srv *srv) {
    int i;
    printf ("\r\n");

    err_msg ("############ server informations ##############");
    err_msg ("-----------------------------------------------");
    err_msg ("settings.backlog = %d", srv->settings.backlog);
    err_msg ("settings.daemonize = %d", srv->settings.daemonize);
    err_msg ("settings.num_reactors = %d", srv->settings.num_reactors);
    err_msg ("settings.num_factories = %d", srv->settings.num_factories);
    err_msg ("settings.sock_srv_bufsize = %d", srv->settings.max_conn);
    err_msg ("settings.max_request =  %d", srv->settings.max_request);
    err_msg ("settings.timeout_sec = %d", srv->settings.timeout_sec);
    err_msg ("settings.timeout_usec = %d", srv->settings.timeout_usec);
    err_msg (" ");
    err_msg ("mreactor.reactor.base = %p", srv->mreactor.reactor.base);
    err_msg ("-----------------------------------------------");
    printf ("\r\n");

    printf ("\r\n");
    err_msg ("############ factory informations ##############");
    err_msg ("-----------------------------------------------");

    err_msg ("reactor thread info: [%p]threads[adr=%p] params[adr=%p]", &srv->reactor_pool, srv->reactor_pool.threads, srv->reactor_pool.params);
    struct thread_entity *thread;
    struct thread_param *param;
    for (i = 0; i < srv->reactor_pool.num_threads; i++) {
        thread = &ebt_srv_get_thread (srv, reactor_pool, i);
        param = &ebt_srv_get_param (srv, reactor_pool, i);
        err_msg ("thread info:[adr=%p] [adr=%p] [pos=%d] [id=%d] [paramdata=%p]", thread, param, i, thread->id, param->data);
    }

    err_msg ("-----------------------------------------------");
    printf ("\n");

}

void fifo_read (short fd, void *arg) {
    int len;
    char buf[255] = { 0 };

    err_debug ("%s called", __func__);

    len = read (fd, buf, sizeof (buf) - 1);
    err_msg ("read [errno=%d] [errstr=%s]", errno, strerror (errno));

    if (len == -1) {
        err_debug ("read!");
        return;
    } else if (len == 0) {
        err_debug ("connection closed");
        return;
    }
    buf[len] = '\0';
    err_debug ("read:%s", buf);
}

void flag_cb (short flag, void *arg) {
    err_debug ("%s called", __func__);
    err_msg ("%x | %p", flag, arg);
}

int create_fifo (const char *file) {
    struct stat st;

    if (lstat (file, &st) == 0) {
        if ((st.st_mode & S_IFMT) == S_IFREG)
            err_exit ("lstat");
    }
    unlink (file);

    if (mkfifo (file, 0600) == -1)
        err_exit ("mkfifo");

    int fd;
    fd = open (file, O_RDWR | O_NONBLOCK, 0);

    if (fd == -1)
        err_exit ("open");

    err_debug ("fifo fd:[%d]", fd);

    return fd;
}

int main (int argc, char *argv[]) {
    int on_connect (struct EventData *);
    int on_receive (struct EventData *);
    int on_close (struct EventData *);
    int on_shutdown (struct EventData *);
    void printEbt (struct eb_t *);

    struct ebt_srv srv;
    ebt_srv_create (&srv);

    printEbtsrv (&srv);

    ebt_srv_on (&srv, E_CONNECT, on_connect);
    ebt_srv_on (&srv, E_RECEIVE, on_receive);
    ebt_srv_on (&srv, E_CLOSE, on_close);
    ebt_srv_on (&srv, E_SHUTDOWN, on_shutdown);

    ebt_srv_listen (&srv, 8080);
    ebt_srv_start (&srv);

#if 0
    //test ebt
    struct eb_t *ebt = ebt_new (E_READ | E_WRITE | E_TIMER | E_FLAG);
    int fd = create_fifo ("ev.fifo");
    struct ev *ev = ev_read (fd, fifo_read, ev);
    struct ev *evf = ev_flag (0x0fff, flag_cb, evf);

    ev_attach (ev, ebt);
    ev_opt (evf, E_ONCE);
    ev_attach (evf, ebt);

    printEbt (ebt);

    ebt_loop (ebt);
    ebt_free (ebt);
#endif

#if 0
    Vec (int) array;
    vec_init (&array);
    vec_push (&array, 34);
    vec_push (&array, 12);
    vec_push (&array, 'c');

    err_msg ("inum = %d", vec_pop (&array));
    err_msg ("inum = %d", vec_pop (&array));
    err_msg ("inum = %d", vec_pop (&array));
    err_msg ("inum = %d", vec_pop (&array));

    vec_deinit (&array);

    Vec (struct buf_Trunk) trunk;
    vec_init (&trunk);

    int i;
    for (i = 0; i < 10; i++) {
        struct buf_Trunk bt = { i, "hello world!", i + 2 };
        vec_push (&trunk, bt);
    }

    err_msg ("trunk info: length=%d", trunk.length);

    for (i = 0; i < trunk.length; i++) {
        struct buf_Trunk b = vec_get (&trunk, i);

        err_msg ("trunk info: fd=%d | data=%s | len=%d", b.fd, b.data, b.len);
    }

    vec_deinit (&trunk);
#endif

    return 0;
}

int on_connect (struct EventData *data) {
    err_msg ("new client connected: fd=%d | reactor_id=%d | data=%s", data->fd, data->from_reactor_id, "hello");
    return 0;
}
int on_receive (struct EventData *data) {
    err_msg ("recv client Data: fd=%d | len=%d | buf=%s", data->fd, data->len, data->buf);

    write (data->fd, data->buf, data->len);

    return 0;
}
int on_close (struct EventData *data) {
    err_msg ("client [fd=%d] [reactorId=%d] disconnected", data->fd, data->from_reactor_id);
    return 0;
}
int on_shutdown (struct EventData *data) {
    return 0;
}

void printEbt (struct eb_t *ebt) {
    printf ("\n\n\n");

    struct ebt_epoll *epo = (struct ebt_epoll *) ebt;
    err_msg ("ebt -> epo info: [epo=%p] [ebo=%p] [kides=%x] [timer_tree=%p] [dispatchq=%p] [flags=%p]", epo, ebt->ebo, ebt->kides, &ebt->timers, &ebt->dispatchq, &ebt->flags);

    //print dispatchq
    if (TAILQ_EMPTY (&ebt->dispatchq))
        err_msg ("dispatchq: it's empty!");
    else {
        struct ev *e;
        TAILQ_FOREACH (e, &ebt->dispatchq, dispatchq) {
            err_msg ("dispatchq item: [adr=%p] [kide=%x] [opt=%x]", e, e->kide, e->opt);
        }
    }

    //print readev
    int i, numq = 0;
    struct ev_io *evi;
    for (i = 0; i < epo->epsz; i++) {
        if (epo->readev[i] != NULL) {
            evi = (struct ev_io *) epo->readev[i];
            err_msg ("readev item: [adr=%p] [fd=%d] [pos=%d]", evi, evi->fd, i);
        }
    }
    //print writev
    for (i = 0; i < epo->epsz; i++) {
        if (epo->writev[i] != NULL) {
            evi = (struct ev_io *) epo->writev[i];
            err_msg ("writev item: [ard=%p] [fd=%d] [pos=%d]", evi, evi->fd, i);
        }
    }

    //print timer tree info
    if (RB_EMPTY (&ebt->timers))
        err_msg ("timer tree: it's empty!");
    else {
        struct ev_timer *evt;
        RB_FOREACH (evt, timer_tree, &ebt->timers) {
            err_msg ("timer tree item: [adr=%p] [remain.tv_sec=%d] [remain.tv_usec=%d]", evt, evt->remain.tv_sec, evt->remain.tv_usec);
        }
    }

    //print flags queue info
    if (TAILQ_EMPTY (&ebt->flags))
        err_msg ("flagsq: it's empty!");
    else {
        struct ev_flag *e;
        TAILQ_FOREACH (e, &ebt->flags, flags) {
            err_msg ("flagsq item: [adr=%p] [flag=%d]", e, e->flag);
        }
    }

    err_msg ("ebt total ev nums: [num=%d]", ebt->num);
    err_msg ("ebt total timer nums: [numtimers=%d]", ebt->numtimers);
    err_msg ("ebt total dispatchq nums: [nums=%d]", numq);

    printf ("\n\n\n");
}
