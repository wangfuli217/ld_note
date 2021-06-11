#include "mempool.h"

// see mempool.h for the license on this code

// simple helper lib to make it easier to maintain local memory

mempool* mempool_create() 
{
	mempool *_mp = NULL;
	_mp = malloc(sizeof(mempool));
	_mp->first_allocation = (mempool_allocation *) NULL;
	
	return _mp;
}

void
fit_as_last(mempool *pool, mempool_allocation *new_allocation) 
{
	if (pool->first_allocation == NULL) {
		pool->first_allocation = new_allocation;
	} else {
		mempool_allocation *current = pool->first_allocation;
		while (current->next != NULL) {
			current = current->next;
		}
		current->next = new_allocation;
	}
}

void* 
mempool_malloc(mempool *pool, size_t size) 
{
	void *allocated = malloc(size);

	if (allocated == NULL) {
		// memory allocation failed
		return allocated;
	}

	mempool_allocation *new_allocation = malloc(sizeof(mempool_allocation));
	if (new_allocation == NULL) {
		//failed to allocate the holder for allocation ? :D
		free(allocated);
		return NULL;
	}
	new_allocation->next    = NULL;
	new_allocation->pointer = allocated;

	fit_as_last(pool, new_allocation);
	return allocated;
}

void* 
mempool_calloc(mempool *pool, size_t nmemb, size_t size) 
{
	void *allocated = calloc(nmemb, size);

	if (allocated == NULL) {
		// memory allocation failed
		return allocated;
	}

	mempool_allocation *new_allocation = malloc(sizeof(mempool_allocation));
	if (new_allocation == NULL) {
		//failed to allocate the holder for allocation ? :D
		free(allocated);
		return NULL;
	}
	new_allocation->next    = NULL;
	new_allocation->pointer = allocated;

	fit_as_last(pool, new_allocation);
	return allocated;
}

void* 
mempool_realloc(mempool *pool, void *ptr, size_t size) 
{
	void *reallocated = realloc(ptr, size);
	if (reallocated == NULL) {
		// fail grande :)
		return reallocated;
	}
	// reallocate succeeded, replace the pointer in our stack
	mempool_allocation *current = pool->first_allocation;
	while (current != NULL) {
		if (current->pointer == ptr) {
			current->pointer = reallocated;
			break;
		}
		current = current->next;
	}
	// if current is null then the initial ptr never belonged to our stack, no idea how to continue, will panic
	assert(current != NULL && "we were given a pointer that was not initially a part of this pool");
	return reallocated;
}

void 
mempool_free(mempool *pool,void *ptr)
{
	// run through the pool, find where this ptr is, cut it out from there
	if (pool->first_allocation->pointer == ptr) {
		pool->first_allocation = pool->first_allocation->next;
		return;
	}

	// it is not the first
	mempool_allocation *current = pool->first_allocation->next;
	mempool_allocation *tmp = pool->first_allocation;
	while (current != NULL) {
		if (current->pointer == ptr) {
			// found you :)
			// lets link the previous to the next
			tmp->next = current->next;
			// now get rid of the current
			free(current->pointer);
			free(current);
			return;	
		}
		tmp = current;
		current = current->next;
	}
}

void
mempool_clean(mempool *pool) 
{
	mempool_allocation *current = pool->first_allocation;
	mempool_allocation *tmp;
	while (current != NULL) {
		tmp = current->next;
		free(current->pointer);
		free(current);
		current = tmp;
	}
	pool->first_allocation = NULL;
}