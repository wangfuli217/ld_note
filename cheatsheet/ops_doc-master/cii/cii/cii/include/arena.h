#ifndef ARENA_INCLUDE
#define ARENA_INCLUDE

#include"except.h"

#define T arena_t

typedef struct T *T;

extern const except_t ArenaNewFailedException;
extern const except_t ArenaFailedException;

T       arena_new       (void);
void    arena_dispose   (T *ap);

void   *arena_alloc     (T arena, 
                            ssize_t len,
                            const char *file,
                            const char *func,
                            int line);

void   *arena_calloc    (T arena,
                           ssize_t count,
                           ssize_t len,
                           const char *file,
                           const char *func,
                           int line);

void    arena_free      (T arena);

#define ARENA_ALLOC(a,len) arena_alloc((a), (len),\
                            __FILE__, __func__, __LINE__)

#define ARENA_CALLOC(a,count,len) arena_calloc((a), (count), (len),\
                                __FILE__, __func__, __LINE__)

#undef T

#endif /*ARENA_INCLUDE*/
