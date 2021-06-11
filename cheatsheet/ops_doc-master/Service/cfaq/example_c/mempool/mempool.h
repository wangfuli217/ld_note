/*
Copyright (C) 2012 kulminaator

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef __MEMPOOL_H_
#define __MEMPOOL_H_

#include <stdlib.h>
#include <assert.h>

typedef struct mempool_allocation_s mempool_allocation;

struct mempool_allocation_s {
	void *pointer;
	mempool_allocation *next;
};
// typedef struct mempool_allocation_s mempool_allocation;

struct mempool_s {
	mempool_allocation *first_allocation;
};

typedef struct mempool_s mempool;

extern mempool* mempool_create();
extern void* mempool_malloc(mempool *pool, size_t size);
extern void* mempool_calloc(mempool *pool, size_t nmemb, size_t size);
extern void* mempool_realloc(mempool *pool, void *ptr, size_t size);
extern void mempool_free(mempool *pool,void *ptr);
extern void mempool_clean(mempool *pool);

#endif