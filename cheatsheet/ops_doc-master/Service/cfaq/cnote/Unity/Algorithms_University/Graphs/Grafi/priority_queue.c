#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "priority_queue.h"

#define PARENT(i) ((i)-1)/2
#define LEFT_CHILD(i) (2*(i))+1

void swap(void** e1, void** e2) {
  void* tmp = *e1;
  *e1 = *e2;
  *e2 = tmp;
}

//create an empty priority queue
PriorityQueue_p priority_queue_create(size_t size) {
	PriorityQueue_p newpq = (PriorityQueue_p) malloc(sizeof(PriorityQueue_t));
	newpq->queue = (void**) malloc(sizeof(void*)*size);
	newpq->inserted = 0;
	newpq->size = size;
	return newpq;
}

// free memory of priority queue
void priority_queue_destroy(PriorityQueue_p pq) {
	if (pq) {
    free(pq->queue);
    free(pq);
  }
}

//insert an element in the queue
void min_heap_insert(PriorityQueue_p pq, void* element) {
	if (pq->inserted == pq->size) {
		size_t newsize = pq->size*2;
		void** newqueue= (void**) malloc(sizeof(void*)*newsize);
		memcpy(newqueue, pq->queue, sizeof(void*) * pq->inserted);
		free(pq->queue);
		pq->queue = newqueue;
		pq->size = newsize;
	}
	pq->queue[pq->inserted] = element;
	pq->inserted++;
}

//move the minor of the children toward the root of the heap
void sift_down(void** array, int root, int end, PQCompFunction compare) {
  int child = LEFT_CHILD(root),
      swp = root;

  while(child <= end) {

    if (compare(array[swp], array[child]) > 0)
      swp = child;

    if (child+1 <= end && compare(array[swp], array[child+1]) > 0)
      swp = child + 1;

    if (swp != root) {
      swap(&array[root], &array[swp]);
      root = swp;
    } else
      break;

    child = LEFT_CHILD(root);
  }

}

//heapify the queue
void min_heapify(void** array, size_t inserted, PQCompFunction compare) {
  if (inserted > 1){
    for (int i = PARENT((int)inserted - 1); i >= 0; i--)
      sift_down(array, i, inserted - 1, compare);
  }
}

//extract the minimum
void* heap_extract_min(PriorityQueue_p pq, PQCompFunction compare) {
	if (pq->inserted > 0){
    min_heapify(pq->queue, pq->inserted, compare);
    void* min = pq->queue[0];
    pq->queue[0] = pq->queue[pq->inserted-1];
    pq->inserted--;
    return min;
  } else
		return NULL;
}
