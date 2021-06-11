/*
 * =====================================================================================
 *
 *       Filename:  atom.h
 *
 *    Description:  #define ATOM_SIZE before #include <zy/atom.h>
 *
 *        Version:  1.0
 *        Created:  28.02.10 16:33
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */


#ifndef		ZY_ATOM_H
#define		ZY_ATOM_H


/*-----------------------------------------------------------------------------
 *  stack.c includes stack.h, so no "extern"
 *-----------------------------------------------------------------------------*/
#ifndef		ZY_ATOM_IMPLEMENTATION
#define		EXTERN		extern
#else
#define		EXTERN		
#endif

/*-----------------------------------------------------------------------------
 *  #define ATOM_SIZE before
 *  #include <zy/atom.h>
 *-----------------------------------------------------------------------------*/
#ifndef		ATOM_SIZE
#define		ATOM_SIZE	2048
#endif


/*-----------------------------------------------------------------------------
 *  node
 *  length zero array
 *-----------------------------------------------------------------------------*/
struct atom_n {
	int len;                                                /* string length */
        struct atom_n * link;                                   /* next one */
	char str[0];                                            /* GCC extension */
};
typedef struct atom_n atom_n;


/*-----------------------------------------------------------------------------
 *  table
 *-----------------------------------------------------------------------------*/
struct atom_t {
	size_t size;                                               /* how many nodes */
	atom_n * head;
};
typedef struct atom_t atom_t;


/*-----------------------------------------------------------------------------
 *  atom wrapper, i.e. interfaces
 *-----------------------------------------------------------------------------*/
EXTERN const char *atom_search_string(atom_t *, const char *);
EXTERN const char *atom_add_string(atom_t *, const char *);
EXTERN const char *atom_search_num(atom_t *, long);
EXTERN const char *atom_add_num(atom_t *, long);

EXTERN atom_t *atom_create(void);
EXTERN void atom_free(atom_t *);

#endif
