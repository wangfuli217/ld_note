#ifndef _ARENA_H_
#define _ARENA_H_

#include "except.h"

//ÄÚ´æ³ØÃèÊö·û 
struct Arena_T
{
	struct Arena_T *prev; 
	char 		   *avail;
	char 		   *limit;
};

extern const Except_T Arena_Failed;

extern struct Arena_T* Arena_new    (void);
extern void   Arena_dispose(struct Arena_T **ap);

extern void*  Arena_alloc (struct Arena_T *arena, long nbytes,
					  	  	 const char *file, int line);	
extern void*  Arena_calloc(struct Arena_T * arena, long count,long nbytes,
						  	 const char *file, int line);	
extern void   Arena_free  (struct Arena_T * arena);

#endif


