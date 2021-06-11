#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "array.h"
#include "mem.h"


Array Array_new(int length, int size)
{
	Array array;
	
	NEW(array);
	if (length > 0)
		ArrayRep_init(array, length, size,CALLOC(length, size));
	else
		ArrayRep_init(array, length, size, NULL);
	
	return array;
}

void ArrayRep_init(Array array, int length, int size, void *ary) 
{
	assert(array);
	assert(ary && length>0 || length==0 && ary==NULL);
	assert(size > 0);
	
	array->length = length;
	array->size   = size;
	if (length > 0)
		array->array = ary;
	else
		array->array = NULL;
}

void Array_free(Array *array)
{
	assert(array && *array);
	
	FREE((*array)->array);
	FREE(*array);
}

void *Array_get(Array array, int i) 
{
	assert(array);
	assert(i >= 0 && i < array->length);
	
	return array->array + i*array->size;
}

void *Array_put(Array array, int i, void *elem) 
{
	assert(array);
	assert(i >= 0 && i < array->length);
	assert(elem);
	memcpy(array->array + i*array->size, elem, array->size);
	return elem;
}

int Array_length(Array array) 
{
	assert(array);
	return array->length;
}

int Array_size(Array array) 
{
	assert(array);
	return array->size;
}

void Array_resize(Array array, int length) 
{
	assert(array);
	assert(length >= 0);
	
	if (length == 0)
		FREE(array->array);
	else if (array->length == 0)
		array->array = ALLOC(length*array->size);
	else
		RESIZE(array->array, length*array->size);
	
	array->length = length;
}

Array Array_copy(Array array, int length) 
{
	Array copy;
	
	assert(array);
	assert(length >= 0);
	
	copy = Array_new(length, array->size);
	if (copy->length >= array->length && array->length > 0)
		memcpy(copy->array, array->array, array->length);
	else if (array->length > copy->length && copy->length > 0)
		memcpy(copy->array, array->array, copy->length);
	return copy;
}

Array Array_reshape  (Array array, int length)
{
	
}
