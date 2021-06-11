#ifndef __PRYQUE_H_1234__
#define __PRYQUE_H_1234__

typedef struct {
	void** queue;
	size_t inserted;
	size_t size;
} PriorityQueue_t, *PriorityQueue_p;

typedef int (*PQCompFunction)(void*, void*);

PriorityQueue_p priority_queue_create(size_t size);
void min_heap_insert(PriorityQueue_p pq, void* element);
void sift_down(void** array, int root, int end, PQCompFunction compare);
void min_heapify(void** array, size_t inserted, PQCompFunction compare);
void* heap_extract_min(PriorityQueue_p pq, PQCompFunction compare);
void priority_queue_destroy(PriorityQueue_p pq);

#endif
