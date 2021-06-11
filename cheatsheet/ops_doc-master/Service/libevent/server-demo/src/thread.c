#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "conn.h"

/* An item in the connection queue. */
typedef struct conn_queue_item CQ_ITEM;
struct conn_queue_item {
    int sfd;
    enum conn_states init_state;
    int event_flags;
    int read_buffer_size;
    /* enum network_transport     transport; */
    conn *c;
    CQ_ITEM *next;
};

/* A connection queue. */
typedef struct conn_queue CQ;
struct conn_queue {
    CQ_ITEM *head;
    CQ_ITEM *tail;
    pthread_mutex_t lock;
};

static WORKER_THREAD *threads;

/*
 * Number of worker threads that have finished setting themselves up.
 */
static int init_count = 0;
static pthread_mutex_t init_lock;
static pthread_cond_t init_cond;

static void cq_init (CQ * cq) {
    pthread_mutex_init (&cq->lock, NULL);
    cq->head = NULL;
    cq->tail = NULL;
}

static CQ_ITEM *cq_pop (CQ * cq) {
    CQ_ITEM *item;

    pthread_mutex_lock (&cq->lock);
    item = cq->head;
    if (item != NULL) {
        cq->head = item->next;
        if (cq->head == NULL)
            cq->tail = NULL;
    }
    pthread_mutex_unlock (&cq->lock);

    return item;
}

static void cq_push (CQ * cq, CQ_ITEM * item) {
    item->next = NULL;

    pthread_mutex_lock (&cq->lock);
    if (cq->tail == NULL)
        cq->head = item;
    else
        cq->tail->next = item;
    cq->tail = item;
    pthread_mutex_unlock (&cq->lock);
}

static CQ_ITEM *cqi_new (void) {
    CQ_ITEM *item = NULL;
    item = malloc (sizeof (CQ_ITEM));
    return item;
}

static void cqi_free (CQ_ITEM * item) {
    if (item)
        free (item);
}

static int last_thread = -1;
void dispatch_conn_new (int sfd, enum conn_states init_state, int event_flags) {
    int tid;
    char buf[1];
    CQ_ITEM *item = cqi_new ();
    if (!item) {
        close (sfd);
        fprintf (stderr, "Failed to allocate memory for connection object\n");
        return;
    }
    tid = (last_thread + 1) % settings.num_threads;
    WORKER_THREAD *thread = threads + tid;
    last_thread = tid;

    item->sfd = sfd;
    item->init_state = init_state;
    item->event_flags = event_flags;

    cq_push (thread->conn_queue, item);

    buf[0] = 'c';
    if (write (thread->notify_send_fd, buf, 1) != 1) {
        perror ("Writing to thread notify pipe");
    }
}

static void thread_worker_process (int fd, short which, void *arg) {
    WORKER_THREAD *me = arg;
    CQ_ITEM *item;
    char buf[1];

    if (read (fd, buf, 1) != 1) {
        fprintf (stderr, "Can't read from libevent pipe\n");
        return;
    }

    switch (buf[0]) {
    case 'c':
        item = cq_pop (me->conn_queue);

        if (item != NULL) {
            conn *c = conn_new (item->sfd, item->init_state, item->event_flags,
                                me->base);
            if (c == NULL) {
                close (item->sfd);
            } else {
                c->thread = me;
            }
        } else {
            cqi_free (item);
        }
        break;
    }
}

static void setup_thread (WORKER_THREAD * me) {
    me->base = event_init ();
    if (!me->base) {
        fprintf (stderr, "Can't allocate event base\n");
        exit (1);
    }

    event_set (&me->notify_event, me->notify_recv_fd, EV_READ | EV_PERSIST, thread_worker_process, me);
    event_base_set (me->base, &me->notify_event);

    me->conn_queue = malloc (sizeof (struct conn_queue));
    if (me->conn_queue == NULL) {
        perror ("Failed to allocate memory for connection queue");
        exit (1);
    }

    cq_init (me->conn_queue);

    if (event_add (&me->notify_event, 0) == -1) {
        fprintf (stderr, "Can't monitor libevent notify pipe\n");
        exit (1);
    }
}

static void register_thread_initialized () {
    pthread_mutex_lock (&init_lock);
    init_count++;
    pthread_cond_signal (&init_cond);
    pthread_mutex_unlock (&init_lock);
}

static void *worker_libevent (void *arg) {
    WORKER_THREAD *me = arg;

    register_thread_initialized ();

    event_base_loop (me->base, 0);
    return NULL;
}

static void create_worker (void *(*func) (void *), void *arg) {
    pthread_attr_t attr;
    int ret;

    pthread_attr_init (&attr);

    if ((ret = pthread_create (&((WORKER_THREAD *) arg)->thread_id, &attr, func, arg)) != 0) {
        fprintf (stderr, "Can't create thread: %s\n", strerror (ret));
        exit (1);
    }
}

static void wait_for_thread_registration (int nthreads) {
    while (init_count < nthreads) {
        pthread_cond_wait (&init_cond, &init_lock);
    }
}

void thread_init (int nthreads) {
    int i;
    pthread_mutex_init (&init_lock, NULL);
    pthread_cond_init (&init_cond, NULL);

    threads = calloc (nthreads, sizeof (WORKER_THREAD));
    if (!threads) {
        perror ("Can't allocate thread descriptors");
        exit (1);
    }

    for (i = 0; i < nthreads; i++) {
        int fds[2];
        if (pipe (fds)) {
            perror ("Can't create notify pipe");
            exit (1);
        }
        threads[i].notify_recv_fd = fds[0];
        threads[i].notify_send_fd = fds[1];
        setup_thread (&threads[i]);
    }

    for (i = 0; i < nthreads; i++) {
        create_worker (worker_libevent, &threads[i]);
    }

    pthread_mutex_lock (&init_lock);
    wait_for_thread_registration (nthreads);
    pthread_mutex_unlock (&init_lock);

}
