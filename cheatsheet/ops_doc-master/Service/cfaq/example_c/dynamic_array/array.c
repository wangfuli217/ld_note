#include "array.h"

static inline int
_d_array_shink(d_array_t* array, size_t n)
{
    char* p = realloc(array->elts, array->size * array->nalloc * n);

    if (p) {
        array->elts = p;
        array->nalloc = array->nalloc * n;

        return 0;
    } else {
        return 1;
    }
}

d_array_t*
d_array_create(size_t size, size_t n)
{
    size_t nsize = 0;

    if (n == 0) {
        nsize = size * 10;
    } else {
        nsize = size * n;
    }

    d_array_t* a = malloc(sizeof(d_array_t));

    if (a == NULL) {
        return NULL;
    }

    a->elts = malloc(nsize);
    memset(a->elts, 0, nsize);
    a->size = size;
    a->nelts = 0;
    a->nalloc = n;

    return a;
}

void*
d_array_push(d_array_t* array, size_t n)
{
    if ( n + array->nelts > array->nalloc ) {
        if (_d_array_shink(array, 2 * n)) { /* 扩充两倍容量 */
            return NULL;
        }
    }

    array->nelts += n;

    return (char*)array->elts + (array->nelts - n)* array->size;
}

void
d_array_clean(d_array_t* array)
{
    if (array->elts) {
        memset(array->elts, 0, array->nelts);
    }
}

void
d_array_destroy(d_array_t* array)
{
    if (array) {
        free(array->elts);
        free(array);
    }
}


