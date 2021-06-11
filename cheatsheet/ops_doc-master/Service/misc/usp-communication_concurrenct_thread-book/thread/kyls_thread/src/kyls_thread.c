#include <kyls_thread.h>
#include <setjmp.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <stdbool.h>
#include <stdint.h>
#include <signal.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/epoll.h>
#include <sys/time.h>
#include <assert.h>

#define KYLS_SK_SIZE (1024 * 1024)

typedef struct {
    jmp_buf jb;
} mctx_t;

// scheduled reason
#define SR_TIMEUP  0x1
#define SR_IOEVENT  0x2
#define SR_NORMAL  0x4

// thread status
#define TS_RUNNING 0x10
#define TS_SCHEDULING 0x1
/*
#define TS_SLEEPING 0x2
#define TS_WAITING 0x4
#define TS_IDLING 0x8
*/

typedef struct kyls_thread_t {
    int tid;
    int blk_fd;
    mctx_t ctx;
    struct timeval time_wakeup;
    uint32_t sched_reason;
    uint32_t status;

    void (*sk_addr) (void *);
    void *proc_arg;
    void *proc_addr;
    size_t sk_size;
    struct kyls_thread_t *next;
    struct kyls_thread_t *run_next;
} kyls_thread_t;

static kyls_thread_t *kyls_tobe_sched;
static kyls_thread_t *kyls_sleeping_head;
static kyls_thread_t *kyls_current;
static kyls_thread_t *kyls_freelist;
static kyls_thread_t *kyls_pending_new;
//static kyls_thread_t *kyls_pending_free;
static int kyls_thread_num = 0;

static mctx_t sched_ctx;

static struct {
    int epollfd;
} kyls_ev;

static int global_tid_idx = 0;

static mctx_t *mctx_creat;
static mctx_t mctx_caller;
static sig_atomic_t mctx_called;
static void (*mctx_creat_func) (void *);
static void *mctx_creat_arg;
static sigset_t mctx_creat_sigs;

#define  mctx_save(mctx) \
    setjmp((mctx)->jb)

#define mctx_restore(mctx) \
    longjmp((mctx)->jb, 1)

#define mctx_switch(mctx_old, mctx_new) \
    if (setjmp((mctx_old)->jb) == 0) \
        longjmp((mctx_new)->jb, 1)

int time_diff_ms (struct timeval *base);
void mctx_create (mctx_t * mctx, void (*sf_addr) (void *), void *sf_arg, void *sk_addr, size_t sk_size);
void mctx_create_trampoline (int sig);
void mctx_create_boot (void);

kyls_thread_t *kyls_t_add_running (kyls_thread_t * t, kyls_thread_t * head, uint32_t reason);
void kyls_t_switch_to (kyls_thread_t * t);
void kyls_t_free (kyls_thread_t * t);
void kyls_t_yield_no_sched ();
int kyls_ev_add_fd (int fd, uint32_t events);
int kyls_ev_del_fd (int fd);

int time_diff_ms (struct timeval *base) {
    struct timeval tvnow;
    gettimeofday (&tvnow, NULL);
    long diff = (tvnow.tv_sec - base->tv_sec) * 1000000 + tvnow.tv_usec - base->tv_usec;
    return diff / 1000;
}

void mctx_create (mctx_t * mctx, void (*sf_addr) (void *), void *sf_arg, void *sk_addr, size_t sk_size) {
    struct sigaction sa, osa;
    struct sigaltstack ss, oss;
    sigset_t sigs, osigs;

    /* step 1 */
    sigemptyset (&sigs);
    sigaddset (&sigs, SIGUSR1);
    sigprocmask (SIG_BLOCK, &sigs, &osigs);

    /* step 2 */
    memset ((void *) &sa, 0, sizeof (sa));
    sa.sa_handler = mctx_create_trampoline;
    sa.sa_flags = SA_ONSTACK;
    sigemptyset (&sa.sa_mask);
    sigaction (SIGUSR1, &sa, &osa);

    /* step 3 */
    ss.ss_sp = sk_addr;
    ss.ss_size = sk_size;
    ss.ss_flags = 0;
    sigaltstack (&ss, &oss);

    /* step 4 */
    mctx_creat = mctx;
    mctx_creat_func = sf_addr;
    mctx_creat_arg = sf_arg;
    mctx_creat_sigs = osigs;
    mctx_called = false;
    kill (getpid (), SIGUSR1);
    sigfillset (&sigs);
    sigdelset (&sigs, SIGUSR1);
    while (!mctx_called)
        sigsuspend (&sigs);

    /* step 6 */
    sigaltstack (NULL, &ss);
    ss.ss_flags = SS_DISABLE;
    sigaltstack (&ss, NULL);
    if (!(oss.ss_flags & SS_DISABLE))
        sigaltstack (&oss, NULL);
    sigaction (SIGUSR1, &osa, NULL);
    sigprocmask (SIG_SETMASK, &osigs, NULL);

    /* step 7 & step 8 */
    mctx_switch (&mctx_caller, mctx);

    /* step 14 */
    return;
}

void mctx_create_trampoline (int sig) {
    /* step 5 */
    if (mctx_save (mctx_creat) == 0) {
        mctx_called = true;
        return;
    }

    /* step 9 */
    mctx_create_boot ();
}

void mctx_create_boot (void) {
    void (*mctx_start_func) (void *);
    void *mctx_start_arg;

    /* step 10 */
    sigprocmask (SIG_SETMASK, &mctx_creat_sigs, NULL);

    /* step 11 */
    mctx_start_func = mctx_creat_func;
    mctx_start_arg = mctx_creat_arg;

    /* step 12 & step 13 */
    mctx_switch (mctx_creat, &mctx_caller);

    /* thread starts */
    mctx_start_func (mctx_start_arg);

    /* thread returned */
    kyls_thread_num--;
    kyls_t_free (kyls_current);
    kyls_t_yield_no_sched ();
}

void kyls_t_free (kyls_thread_t * t) {
    // do not free now since it is still running on the stack
    // just put the thread context into free list
    t->next = kyls_freelist;
    kyls_freelist = t;
}

void kyls_switch_to (kyls_thread_t * t) {
    kyls_current = t;
    t->status = TS_RUNNING;
    mctx_switch (&sched_ctx, &kyls_current->ctx);

    // went back to main scheduler
    t->status = 0;
}

void kyls_thread_yield () {
    // add current task to the end of running queue
    kyls_current->sched_reason = 0;
    kyls_tobe_sched = kyls_t_add_running (kyls_current, kyls_tobe_sched, SR_NORMAL);

    // save context switch to scheduler
    mctx_switch (&kyls_current->ctx, &sched_ctx);
}

void kyls_t_yield_no_sched () {
    // save context switch to scheduler
    kyls_current->sched_reason = 0;
    mctx_switch (&kyls_current->ctx, &sched_ctx);
}

void kyls_thread_sched () {
    static const int MAX_EVENTS = 10;
    kyls_current = NULL;

    // keep run until no thread living and no pending new thread
    while (kyls_pending_new || kyls_thread_num) {
        struct epoll_event events[MAX_EVENTS];
        int nfds = epoll_wait (kyls_ev.epollfd, events, MAX_EVENTS, 5);
        int i;

        kyls_thread_t *to_be_run = kyls_tobe_sched;
        kyls_tobe_sched = NULL;

        // put triggered event's associated thread into running pool to be scheduled
        for (i = 0; i < nfds; i++) {
            kyls_thread_t *t = (kyls_thread_t *) (events[i].data.ptr);
            //printf("thread %d fd[%d] event:%u\n", t->tid, t->blk_fd, events[i].events);
            // clear timer if event triggered
            t->time_wakeup.tv_sec = 0;
            to_be_run = kyls_t_add_running (t, to_be_run, SR_IOEVENT);
        }

        kyls_thread_t *cur;

        // check pending new threads, create context for them
        for (cur = kyls_pending_new; cur != NULL;) {
            kyls_thread_t *t = cur;
            cur = cur->next;
            // create running context for this thread
            mctx_create (&t->ctx, t->proc_addr, t->proc_arg, t->sk_addr, t->sk_size);
            // make it will be scheduled
            to_be_run = kyls_t_add_running (t, to_be_run, SR_NORMAL);
        }
        kyls_pending_new = NULL;

        // check sleeping threads with timer set
        // if it expired, remove it from linked list
        kyls_thread_t dummy;
        cur = &dummy;
        cur->next = kyls_sleeping_head;
        for (; cur->next;) {
            kyls_thread_t *t = cur->next;
            if (t->time_wakeup.tv_sec == 0) {
                // timer cancelled otherwhere
                cur->next = t->next;
                t->next = NULL;
            } else if (time_diff_ms (&t->time_wakeup) >= 0) {
                cur->next = t->next;
                t->time_wakeup.tv_sec = 0;
                t->next = NULL;
                to_be_run = kyls_t_add_running (t, to_be_run, SR_TIMEUP);
            } else {
                cur = cur->next;
            }
        }
        kyls_sleeping_head = dummy.next;

        for (cur = to_be_run; cur != NULL;) {
            // pick up threads need to be scheduled that has no timer or timer expired
            kyls_thread_t *t = cur;
            cur = cur->run_next;
            kyls_switch_to (t);

            // may be not necessary
            kyls_current = NULL;
        }
    }
}

kyls_thread_t *kyls_t_add_running (kyls_thread_t * t, kyls_thread_t * head, uint32_t reason) {
    t->sched_reason |= reason;
    if (t->status & TS_SCHEDULING)
        return head;

    /* add to running list, the tail */
    t->run_next = head;
    t->status = TS_SCHEDULING;
    return t;
}

struct kyls_thread_t *kyls_thread_create (void (*proc_addr) (void *), void *proc_arg) {
    kyls_thread_t *t;

    // currently the stack size is fixed
    // fetch from free list if possible
    if (kyls_freelist) {
        t = kyls_freelist;
        kyls_freelist = kyls_freelist->next;
    } else {
        // no freed, create a new one.
        t = (kyls_thread_t *) malloc (sizeof (*t));
        t->sk_size = KYLS_SK_SIZE;
        t->sk_addr = malloc (t->sk_size);

        // tid will also be reused, like file descriptor
        t->tid = global_tid_idx++;
    }

    t->run_next = NULL;
    t->time_wakeup.tv_sec = 0;
    t->time_wakeup.tv_usec = 0;
    t->blk_fd = -1;
    t->status = 0;
    t->sched_reason = 0;
    t->proc_addr = proc_addr;
    t->proc_arg = proc_arg;

    // actual context thread creation is only done in schedular. 
    t->next = kyls_pending_new;
    kyls_pending_new = t;
    kyls_thread_num++;
    return t;
}

int kyls_thread_kill (struct kyls_thread_t *t) {

}

void kyls_thread_destroy () {
    // deallocate everyone in free list
    while (kyls_freelist) {
        kyls_thread_t *t = kyls_freelist->next;
        free (kyls_freelist->sk_addr);
        free (kyls_freelist);
        kyls_freelist = t;
    }

    kyls_tobe_sched = NULL;
    kyls_sleeping_head = NULL;
    kyls_current = NULL;
    kyls_freelist = NULL;
}

int kyls_thread_init () {
    kyls_tobe_sched = NULL;
    kyls_sleeping_head = NULL;
    kyls_current = NULL;
    kyls_freelist = NULL;
    kyls_pending_new = NULL;
    //kyls_pending_free = NULL;
    kyls_thread_num = 0;

    kyls_ev.epollfd = epoll_create (1);
    if (kyls_ev.epollfd < 0)
        return -1;
    return 0;
}

int kyls_thread_self () {
    if (kyls_current)
        return kyls_current->tid;
    else
        return -1;
}

int kyls_ev_add_fd (int fd, uint32_t events) {
    struct epoll_event event;
    event.events = events;
    event.data.ptr = (void *) kyls_current;
    return epoll_ctl (kyls_ev.epollfd, EPOLL_CTL_ADD, fd, &event);
}

int kyls_ev_del_fd (int fd) {
    return epoll_ctl (kyls_ev.epollfd, EPOLL_CTL_DEL, fd, NULL);
}

int kyls_socket (int domain, int type, int protocol) {
    int ret = socket (domain, type, protocol);
    if (ret < 0)
        return ret;
    fcntl (ret, F_SETFL, fcntl (ret, F_GETFL, 0) | O_NONBLOCK);
    return ret;
}

void kyls_sleep_ms (unsigned int milliseconds) {
    if (!kyls_current)
        return;

    if (milliseconds) {
        gettimeofday (&kyls_current->time_wakeup, NULL);
        kyls_current->time_wakeup.tv_usec += (milliseconds % 1000) * 1000;
        kyls_current->time_wakeup.tv_sec += (milliseconds / 1000) + kyls_current->time_wakeup.tv_usec / 1000000;
        kyls_current->time_wakeup.tv_usec %= 1000000;

        kyls_current->next = kyls_sleeping_head;
        kyls_sleeping_head = kyls_current;
        kyls_t_yield_no_sched ();
    } else {
        kyls_thread_yield ();
    }

}

int kyls_accept (int fd, struct sockaddr *address, socklen_t * address_len, int timeout_ms) {
    for (;;) {
        // the socket buffer may has waiting connections
        int ret = accept (fd, address, address_len);
        if (ret >= 0 || (errno != EAGAIN && errno != EWOULDBLOCK)
            || (kyls_current->sched_reason & SR_TIMEUP)) {
            // got a connection or a REAL error
            kyls_ev_del_fd (fd);
            if (ret >= 0) {
                fcntl (ret, F_SETFL, fcntl (ret, F_GETFL, 0) | O_NONBLOCK);
                //printf("accept new fd %d \n", ret);
            } else {
                //printf("accept -1 %s\n", strerror(errno));
            }
            kyls_current->sched_reason = 0;
            return ret;
        }

        if (kyls_ev_add_fd (fd, EPOLLIN))
            return -1;

        kyls_current->blk_fd = fd;
        if (timeout_ms)
            kyls_sleep_ms (timeout_ms);
        else
            kyls_t_yield_no_sched ();
    }
    // impossible to reach
}

ssize_t kyls_read (int fd, void *buf, size_t n, int timeout_ms) {
    for (;;) {
        // the socket buffer may has waiting data to read
        ssize_t ret = read (fd, buf, n);
        if (ret >= 0 || (errno != EAGAIN && errno != EWOULDBLOCK)
            || (kyls_current->sched_reason & SR_TIMEUP)) {
            // got data or a REAL error
            kyls_ev_del_fd (fd);
            /*
             * if (ret >= 0)
             * printf("read %d\n", ret);
             * else
             * printf("read -1 %s\n", strerror(errno));
             */
            kyls_current->sched_reason = 0;
            return ret;
        }

        if (kyls_ev_add_fd (fd, EPOLLIN))
            return -1;

        kyls_current->blk_fd = fd;
        if (timeout_ms)
            kyls_sleep_ms (timeout_ms);
        else
            kyls_t_yield_no_sched ();
    }
    // impossible to reach
}

ssize_t kyls_write (int fd, void *buf, size_t n, int timeout_ms) {
    for (;;) {
        // the socket buffer may has waiting data to read
        ssize_t ret = write (fd, buf, n);
        if (ret > 0 || (errno != EAGAIN && errno != EWOULDBLOCK)
            || (kyls_current->sched_reason & SR_TIMEUP)) {
            // got data or a REAL error
            kyls_ev_del_fd (fd);
            /*
             * if (ret >= 0)
             * printf("write %d\n", ret);
             * else
             * printf("write -1 %s\n", strerror(errno));
             */
            kyls_current->sched_reason = 0;
            return ret;
        }

        if (kyls_ev_add_fd (fd, EPOLLOUT))
            return -1;

        kyls_current->blk_fd = fd;
        if (timeout_ms)
            kyls_sleep_ms (timeout_ms);
        else
            kyls_t_yield_no_sched ();
    }
    // impossible to reach
}
