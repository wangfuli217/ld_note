/*
 * =====================================================================================
 *
 *       Filename:  stack.h
 *
 *    Description:  define struct stack_n, stack_t
 *
 *    		    while use stack
 *    		    #define STACK_TYPE before
 *    		    #include <zy/stack.h>
 *
 *        Version:  1.0
 *        Created:  27.02.10 17:07
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		ZY_STACK_H
#define		ZY_STACK_H

/*-----------------------------------------------------------------------------
 *  stack.c includes stack.h, so no "extern"
 *-----------------------------------------------------------------------------*/
#ifndef		ZY_STACK_IMPLEMENTATION
#define		EXTERN			extern
#else
#define		EXTERN		
#endif

/*-----------------------------------------------------------------------------
 *  define STACK_TYPE before include stack.h
 *-----------------------------------------------------------------------------*/
#ifndef		STACK_TYPE
#define		STACK_TYPE		int
#endif

/*-----------------------------------------------------------------------------
 *  nodes in stack
 *-----------------------------------------------------------------------------*/
struct stack_n {
	STACK_TYPE x;
	struct stack_n *link;
};
typedef struct stack_n stack_n;

/*-----------------------------------------------------------------------------
 *  stack, including a counter, and a pointer points to a serial of nodes
 *-----------------------------------------------------------------------------*/
struct stack_t {
	int cnt;
	stack_n *head;
};
typedef struct stack_t stack_t;

/*-----------------------------------------------------------------------------
 *  see from the retvals, we have STACK_TYPE "stack_t"
 *-----------------------------------------------------------------------------*/
EXTERN int stack_empty(stack_t *);
EXTERN stack_t *stack_create();
EXTERN void stack_push(stack_t *, STACK_TYPE);
EXTERN STACK_TYPE stack_pop(stack_t *);
EXTERN void stack_free(stack_t *);

#endif
