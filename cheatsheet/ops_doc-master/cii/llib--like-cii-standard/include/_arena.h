#ifndef ARENA_INCLUDED
#define ARENA_INCLUDED

#include "utils.h"  /* for begin_decl */
#include "config.h" /* for maxalign */
#include "except.h" /* for except_t */

BEGIN_DECLS

#define T Arena_T
typedef struct T *T;

extern const Except_T Arena_NewFailed;
extern const Except_T Arena_Failed;

extern T     Arena_new      (void);
extern void  Arena_config   (unsigned int chunks, size_t size);
extern void  Arena_dispose  (T* ap);
extern void *Arena_alloc    (T arena, size_t nbytes, const char *file, int line);
extern void *Arena_calloc   (T arena, size_t count, size_t nbytes, const char *file, int line);
extern void *Arena_realloc  (T arena, void *ptr, size_t nbytes, const char *file, int line);
extern void  Arena_free     (T arena);
extern void  Arena_print_stats();
extern void  Arena_remove_free_blocks();

#undef T

END_DECLS
#endif
