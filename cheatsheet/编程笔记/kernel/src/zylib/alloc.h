/*
 * =====================================================================================
 *
 *       Filename:  alloc.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  01.03.10 22:09
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef		ZY_ALLOC_H
#define		ZY_ALLOC_H

/*-----------------------------------------------------------------------------
 *  alloc.c includes alloc.h, so no "extern"
 *-----------------------------------------------------------------------------*/
#ifndef		ZY_ALLOC_IMPLEMENTATION
#define		EXTERN			extern
#else
#define		EXTERN		
#endif

/*-----------------------------------------------------------------------------
 *  #define ALLOC_SIZE before
 *  #include <zy/alloc.h>
 *-----------------------------------------------------------------------------*/
#ifndef		ALLOC_SIZE
#define		ALLOC_SIZE		2048
#endif

/*-----------------------------------------------------------------------------
 *  allocation node
 *-----------------------------------------------------------------------------*/
struct alloc_n {
	struct alloc_n *free;                                /* next free node */
	struct alloc_n *link;                   /* next one with same hash-key */
	const void *addr;                                     /* malloc'd addr */
	long size;                                            /* malloc'd size */
	const char *file;                                       /* err file */
	int line;                                               /* err line */
};
typedef struct alloc_n alloc_n;

EXTERN void *alloc_calloc(long, long, const char *, int);
EXTERN void *alloc_realloc(void *, long, const char *, int);
EXTERN void *alloc_malloc(long, const char *, int);
EXTERN void alloc_free(void *, const char *, int);
EXTERN void alloc_failure();

/*-----------------------------------------------------------------------------
 *  make them like calloc/realloc/malloc/free in std lib
 *-----------------------------------------------------------------------------*/
#define         CALLOC(cnt, size)                               \
alloc_calloc(cnt, size, __FILE__, __LINE__)
#define         REALLOC(addr, size)                             \
alloc_realloc(addr, size, __FILE__, __LINE__)
#define		MALLOC(size)                                    \
alloc_malloc(size, __FILE__, __LINE__)
#define         FREE(addr)                                      \
alloc_free(addr, __FILE__, __LINE__)
#define         FAILURE()                                       \
alloc_failure()

#endif
