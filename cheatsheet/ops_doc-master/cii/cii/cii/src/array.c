#include<stdlib.h>
#include<string.h>
#include"assert.h"
#include"mem.h"
#include"arith.h"
#include"array.h"
#include"arrayrep.h"

#define T array_t

T
array_new(ssize_t length, ssize_t size)
{
    T array;

    NEW(array);

    if(length > 0)
        arrayrep_init(array, length, size,
                CALLOC(length, size));
    else
        arrayrep_init(array, length, size,
                NULL);

    return array;
}


void
arrayrep_init(T array,
                ssize_t length,
                ssize_t size,
                void *ary)
{
    assert(array);
    assert((ary && length > 0)||
            (0 == length && NULL == ary));
    assert(size > 0);

    array->length = length;
    array->size = size;
    if(length > 0)
        array->array = ary;
    else
        array->array = NULL;
}


void
array_free(T *array)
{
    assert(array && *array);
    FREE((*array)->array);
    FREE(*array);
}


ssize_t
array_length(T array)
{
    assert(array);
    return array->length;
}


ssize_t
array_size(T array)
{
    assert(array);
    return array->size;
}

void *
array_get(T array, ssize_t position)
{
    assert(array);
    assert(position >= 0 && position < array->length);

    return array->array + position * array->size;
}

void *
array_put(T array, ssize_t position, void *element)
{
    assert(array);
    assert(position >= 0 && position < array->length);
    assert(element);
    memcpy(array->array + position * array->size, 
            element,
            array->size);
    return element;
}


void
array_resize(T array, ssize_t length)
{
    assert(array);
    assert(length >= 0);

    if(0 == length)
        FREE(array->array);
    else if(0 == array->length)
        array->array = ALLOC(length * array->size);
    else
        RESIZE(array->array, length * array->size);

    array->length = length;
}


T
array_copy(T array, ssize_t length)
{
    T copy;
    int min_length;

    assert(array);
    assert(length >= 0);

    copy = array_new(length, array->size);

    min_length = arith_min(array->length, copy->length);

    if(min_length > 0)
        memcpy(copy->array, array->array,
                min_length * array->size);

    return copy;
}
