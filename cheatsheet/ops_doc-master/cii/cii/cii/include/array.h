#ifndef ARRAY_INCLUDE
#define ARRAY_INCLUDE

#define T array_t

typedef struct T *T;


extern T        array_new(ssize_t length, ssize_t size);
extern void     array_free(T *array);

extern ssize_t  array_length(T array);
extern ssize_t  array_size(T array);

extern void    *array_get(T array, ssize_t position);
extern void    *array_put(T array, ssize_t position, void *element);

extern void     array_resize(T array, ssize_t length);
extern T        array_copy(T array, ssize_t length);

#undef T
#endif /*ARRAY_INCLUDE*/
