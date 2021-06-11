#ifndef ARRAYREP_INCLUDE
#define ARRAYREP_INCLUDE


#define T array_t

struct T{
    ssize_t length;
    ssize_t size;
    char *array;
};

extern void arrayrep_init(T array,
                            ssize_t length,
                            ssize_t size,
                            void *ary);

#undef T

#endif /*ARRAYREP_INCLUDE*/
