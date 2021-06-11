#ifndef _MEM_INCLUDED
#define _MEM_INCLUDED

#include "except.h"

BEGIN_DECLS

//extern const Except_T Mem_Failed;

extern void *_Mem_alloc (size_t nbytes, const char *file, int line);
extern void *_Mem_calloc(size_t count, size_t nbytes, const char *file, int line);
extern void _Mem_free(void *ptr, const char *file, int line);
extern void *_Mem_realloc(void *ptr, size_t nbytes, const char *file, int line);
extern void _Mem_print_stats();

END_DECLS

#endif
