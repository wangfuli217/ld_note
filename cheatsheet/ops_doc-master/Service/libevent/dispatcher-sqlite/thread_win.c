#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "atomic.h"
#include "thread_win.h"
#include "debug.h"
#include "lfq.h"

#define MAX_THR_NUM 32
#define MAX_IDLE_LIFE 1 * 60 * 1000

static unsigned int __stdcall thread_pool_process (PVOID param) {
    thread_t *thread = (thread_t *) param;
    lfq_t *myq = (lfq_t *) thread->queue;

    void *data = NULL;
    DWORD dw;
    while (thread->parent->status) {
      out:
        if ((data = lfq_deq (myq)) == NULL) {
            AT_CAS (thread->stat, BUSY, IDLE);
            ResetEvent (thread->event);

            dw = WaitForSingleObject (thread->event, MAX_IDLE_LIFE);
            switch (dw) {
            case WAIT_FAILED:
                ph_debug ("Invalid ?");
                break;
            }
            AT_CAS (thread->stat, IDLE, BUSY);
            goto out;
        }

        if (thread->parent->task != NULL) {
            thread->parent->task (data);
        }
    }

    return 0;
}

void thread_pool_envinit () {
}

thread_pool *thread_pool_new (size_t size) {
    if (size > MAX_THR_NUM) {
        ph_debug ("out of MAX_THR_NUM !!!");
        return NULL;
    }
    thread_pool *pool;
    int i;

    pool = malloc (sizeof (*pool));
    if (pool == NULL) {
        ph_debug ("malloc pool error!");
        return NULL;
    }
    memset (pool, 0, sizeof (*pool));

    thread_t *threads;
    threads = malloc (size * sizeof (*threads));
    if (threads == NULL) {
        ph_debug ("malloc threads error!");
        return NULL;
    }

    for (i = 0; i < size; i++) {
        lfq_t *lfq = malloc (sizeof (*lfq));
        if (lfq == NULL) {
            ph_debug ("malloc lfq error!");
            return NULL;
        }
        lfq_init (lfq);

        threads[i].queue = lfq;
        threads[i].stat = IDLE;
        threads[i].event = CreateEvent (NULL, TRUE, FALSE, NULL);
    }

    pool->pool_sz = size;
    pool->threads = threads;
    pool->counter = 0;
    pool->status = 1;

    return pool;
}

void thread_pool_start (thread_pool * pool) {
    assert (pool != NULL);
    int i;
    for (i = 0; i < pool->pool_sz; i++) {
        pool->threads[i].parent = pool;
        pool->threads[i].thd = (HANDLE) _beginthreadex (0, 0, thread_pool_process, &(pool->threads[i]), 0, 0);
    }
}

void thread_pool_dispatch (thread_pool * pool, void *data) {
    int n, i = 0;
    thread_t *thread;

    for (i = 0; i < pool->pool_sz; i++) {
        n = i;
        if (AT_CAS (pool->threads[i].stat, IDLE, IDLE)) {
            goto done;
        }
    }

    //average mode
    n = pool->counter;
    if (n >= pool->pool_sz) {
        pool->counter = 0;
        n = 0;
    }
    pool->counter++;

  done:
    thread = &(pool->threads[n]);

    if (lfq_enq ((lfq_t *) (thread->queue), data) > -1) {
        if (AT_CAS (thread->stat, IDLE, IDLE)) {
            SetEvent (thread->event);
        }
    }
}

void thread_pool_end (thread_pool * pool) {
    assert (pool != NULL);
    int i = 0;
    DWORD dw;
    while (1) {
        dw = WaitForSingleObject (pool->threads[i].thd, 1000);
        switch (dw) {
        case WAIT_OBJECT_0:
            CloseHandle (pool->threads[i].thd);
            i++;
            if (i >= pool->pool_sz) {
                goto clean;
            }
            break;
        case WAIT_FAILED:
            break;
        case WAIT_TIMEOUT:
            ph_debug ("Time out?");
            break;
        }
    }

  clean:
    for (i = 0; i < pool->pool_sz; i++) {
        lfq_deinit (pool->threads[i].queue);
        free (pool->threads[i].queue);
    }

    free (pool->threads);
    free (pool);
}
