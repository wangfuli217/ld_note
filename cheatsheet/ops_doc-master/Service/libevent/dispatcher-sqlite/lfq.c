#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "lfq.h"
#include "atomic.h"
#include "debug.h"

#if defined __GNUC__
#include <sys/time.h>
#define _sleep(milisec) usleep((milisec) * 1000)
#else
#include <time.h>
#define _sleep(milisec) Sleep(milisec)
#endif

struct lfq_cas_node_s {
    void *value;
    struct lfq_cas_node_s *next;
};

static inline void *_lfq_malloc (size_t sz) {
    return malloc (sz);
}

static inline void _lfq_free (void *p) {
    free (p);
}

int lfq_init (lfq_t * lfq) {
    return lfq_init_mf (lfq, _lfq_malloc, _lfq_free);
}

int lfq_init_mf (lfq_t * lfq, lfq_malloc_fn _malloc, lfq_free_fn _free) {
    assert (lfq != NULL);
    memset (lfq, 0, sizeof (*lfq));

    lfq->_malloc = _malloc;
    lfq->_free = _free;

    lfq_cas_node_t *node = _malloc (sizeof (*node));
    if (node == NULL) {
        ph_debug ("fatal error: malloc lfq_cas_node_t!");
        return -1;
    }

    node->value = NULL;
    node->next = NULL;

    lfq->head = lfq->tail = node;
    lfq->size = 0;

    return 0;
}

int lfq_enq (lfq_t * lfq, void *value) {
    lfq_cas_node_t *tail, *node;

    node = (lfq_cas_node_t *) lfq->_malloc (sizeof (*node));
    if (node == NULL) {
        ph_debug ("fatal error: malloc lfq_cas_node_t!");
        return -1;
    }

    node->value = value;
    node->next = NULL;

    for (;;) {
        MEMORY_BARRIER;
        tail = lfq->tail;
        if (AT_CAS (tail->next, NULL, node)) {
            if (AT_CAS (lfq->tail, tail, node)) {
                goto done;
            }
        }
    }
    //never be here
    return -1;
  done:
    AT_AAF (lfq->size, 1);
    return 0;
}

void *lfq_deq (lfq_t * lfq) {
    lfq_cas_node_t *head, *next;
    void *val;

    for (;;) {
        head = lfq->head;
        if (AT_CAS (lfq->head, head, head)) {
            next = head->next;
            if (AT_CAS (lfq->tail, head, head)) {
                if (next == NULL) {
                    val = NULL;
                    goto done;
                }
            } else {
                if (next) {
                    val = next->value;
                    if (AT_CAS (lfq->head, head, next)) {
                        break;
                    }
                } else {
                    val = NULL;
                    goto done;
                }
            }
        }
    }

    MEMORY_BARRIER;
    AT_FAS (lfq->size, 1);

  done:
    return val;
}

size_t lfq_size (lfq_t * lfq) {
    return AT_AAF (lfq->size, 0);
}

void lfq_deinit (lfq_t * lfq) {
    void *p;
    while ((p = lfq_deq (lfq))) {
        lfq->_free (p);
    }
    lfq->size = 0;
}

void lfq_sleep (unsigned int milisec) {
    _sleep (milisec);
}
