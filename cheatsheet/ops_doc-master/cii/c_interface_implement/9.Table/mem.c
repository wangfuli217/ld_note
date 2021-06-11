#include <stdlib.h>
#include <stddef.h>
#include <assert.h>
#include "except.h"
#include "mem.h"

const Except_T Mem_Failed = { "Allocation Failed" };

//malloc
void *Mem_alloc(long nbytes, const char *file, int line)
{
	void *ptr;
	assert(nbytes > 0);
	ptr = malloc(nbytes);
	if (ptr == NULL)
	{
		THROW(Mem_Failed);
	}
	return ptr;
}

//calloc
void *Mem_calloc(long count, long nbytes, const char *file, int line) 
{
	void *ptr;
	
	//对于传入为负的进行核查 
	assert(count > 0);
	assert(nbytes > 0);
	
	ptr = calloc(count, nbytes);
	if (ptr == NULL)
	{
		THROW(Mem_Failed);
	}
	return ptr;
}

//free
void Mem_free(void *ptr, const char *file, int line) {
	if (ptr)
		free(ptr);
}

//realloc
void *Mem_resize(void *ptr, long nbytes, const char *file, int line) 
{
	assert(ptr);
	assert(nbytes > 0);
	
	ptr = realloc(ptr, nbytes);
	if (ptr == NULL)
	{
		THROW(Mem_Failed);
	}
	return ptr;
}

