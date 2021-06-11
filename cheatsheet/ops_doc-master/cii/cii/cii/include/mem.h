#ifndef MEM_INCLUDE
#define MEM_INCLUDE
#include<stdlib.h>
#include"except.h"

extern const except_t MemFailedException;

void *mem_alloc(ssize_t len, 
                const char *file,
                const char *func,
                int line);

void *mem_calloc(ssize_t count,
                ssize_t len,
                const char *file,
                const char *func,
                int line);

void *mem_resize(ssize_t len,
                void *ptr,
                const char *file,
                const char *func,
                int line);

void mem_free(void *ptr,
                const char *file,
                const char *func,
                int line);

void mem_leak(void (*apply)(const void *ptr,
                            ssize_t size,
                            const char *file,
                            const char *func,
                            int line,
                            void *cl),
                void *cl);

#define ALLOC(len)\
        mem_alloc((len), __FILE__, __func__, __LINE__)

#define CALLOC(count, len) \
	mem_calloc((count), (len), __FILE__, __func__, __LINE__)

#define  NEW(p) ((p) = ALLOC((ssize_t)sizeof(*(p))))
#define NEW0(p) ((p) = CALLOC(1, (ssize_t)sizeof(*(p))))
#define NEWARRAY(p, count) ((p) = CALLOC((ssize_t)(count), (ssize_t)sizeof(*(p))))

#define FREE(ptr) ((void)(mem_free((ptr), __FILE__, __func__, __LINE__), (ptr) = 0))

#define RESIZE(ptr, len) 	((ptr) = mem_resize((len), \
	(ptr), __FILE__, __func__, __LINE__))

#endif /*MEM_INCLUDE*/

