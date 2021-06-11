#ifndef __HEAP_H__
#define __HEAP_H__

#include <errno.h>
#include <stdlib.h>

typedef struct heap_node_s {
        long int index;
        void *data;
} heap_node_t;

typedef struct heap_s {
        heap_node_t **heap;                               
        long int size;                                             
        long int last_index;                                                   
        int (*compar)(const void *, const void *);
} heap_t;

#define LEFT(i) 2*(i+1)-1
#define RIGHT(i) 2*(i+1)
#define PARENT(i) (i+1)/2-1

int 
heap_init(heap_t *heap, long int size, int (*compar)(const void *, const void *));

int 
heap_insert(heap_t *heap, heap_node_t *node);

int 
heap_delete(heap_t *heap, heap_node_t *node);

heap_node_t* 
heap_top(heap_t *heap);

int 
heap_destroy(heap_t *heap);

#endif