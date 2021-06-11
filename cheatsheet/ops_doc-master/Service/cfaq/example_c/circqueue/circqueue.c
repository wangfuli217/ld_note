#include "circqueue.h"

#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>

#define index(r, n) (n - r->queues) // 指针的加减按照指向类型的相隔元素个数 //(((uintptr_t)n - (uintptr_t)(r->queues)) / (sizeof *n))
#define nnode(r, n) do { 							\
	unsigned int ti, hi;							\
	ti = hi = 0;									\
	ti = r->tail == NULL ? 0 : index(r, r->tail);	\
	hi = r->head == NULL ? 0 : index(r, r->head); 	\
	if (ti - hi == 0) {								\
		n = r->tail == NULL ? r->queues : r->tail + 1;\
	} else if ((ti - hi) > 0) {						\
		n = r->queues + ((ti + 1) % r->nums); 		\
	} else if ((ti - hi) < 0 && (hi - ti) > 1) { 	\
		n = r->queues + ti + 1;						\
	} else {										\
		n = NULL;									\
	}												\
} while(0)


static inline unsigned int
__queue_size(queue_root_t* r)
{
	unsigned int hi, ti, sz;
	
	hi = ti = sz = 0;
	
	if (r) {
		if (r->queues) {
			if (r->head == NULL && r->tail == NULL) {
				sz = 0;
			} else {
				hi = index(r, r->head);
				ti = index(r, r->tail);
				
				sz = ti >= hi ? ti - hi + 1 : r->nums - hi + ti + 1;				
			}
		}
	}
	
	return sz;
}

int
queue_init(queue_root_t* r, unsigned int nums)
{
	r->queues = (queue_node_t*)malloc(sizeof(queue_node_t) * nums);
	
	if (r->queues) {
		r->nums = nums;
		r->tail = NULL;
		r->head = NULL;
		
		return r->nums;
	}
	
	return 0; // malloc faild;
}

int
queue_push(queue_root_t* r, void* d)
{
	queue_node_t 	*n;
	int 			result;
	
	result = -1;
	n = NULL;
	
	if (r) {
		if (r->queues) {
			nnode(r, n);
			
			printf("n: %p\n", n);
			
			printf("index: %d\n", index(r, n));
		
			if (n) {
				n->data = d;
				printf("data: %p\n", n->data);
				
				if (r->head == NULL) r->head = r->queues + index(r, n);
				
				r->tail = r->queues + index(r, n);
				
				result = 0;
			}
		}
	}
	
	return result;
}

queue_node_t* 
queue_pop(queue_root_t* r)
{
	queue_node_t* n;
	
	n = NULL;
	
	if (r) {
		if (r->queues) {
			if (r->head == NULL) {
				n = NULL;
			} else if (r->head == r->tail) {
				n = r->head;
				
				r->head = r->tail = NULL;
			} else if (r->head < r->tail) {
				n = r->head++;
			} else if (r->head > r->tail) {
				n = r->head;
				
				r->head += (index(r, r->head) + 1) % r->nums;
			}
		}
	}
	
	return n;
}

unsigned int
queue_count(queue_root_t* r)
{
	return __queue_size(r);
}

