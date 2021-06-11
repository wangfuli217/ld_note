#ifndef __LFQ_H__
#define __LFQ_H__

#include <stdint.h>

typedef struct lfq_cas_node_s lfq_cas_node_t;
typedef void *(*lfq_malloc_fn) (size_t);
typedef void (*lfq_free_fn) (void *);

typedef struct {
    lfq_cas_node_t *head, *tail;
    volatile size_t size;
    lfq_malloc_fn _malloc;
    lfq_free_fn _free;
} lfq_t;

int lfq_init (lfq_t * lfq);
int lfq_init_mf (lfq_t * lfq, lfq_malloc_fn _malloc, lfq_free_fn _free);
int lfq_enq (lfq_t * lfq, void *value);
void *lfq_deq (lfq_t * lfq);
size_t lfq_size (lfq_t * lfq);
void lfq_deinit (lfq_t * lfq);
void lfq_sleep (unsigned int milisec);

#endif
