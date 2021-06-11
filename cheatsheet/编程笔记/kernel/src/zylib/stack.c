/*
 * =====================================================================================
 *
 *       Filename:  stack.c
 *
 *    Description:  stack manipulation - is_empty; create; free; push; pop
 *    		    #define STACK_TYPE before #include <zy/stack.h>
 *
 *        Version:  1.0
 *        Created:  27.02.10
 *       Revision:  
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@163.com
 *        Company:  
 *
 * =====================================================================================
 */

/*-----------------------------------------------------------------------------
 *  make EXTERN be empty
 *-----------------------------------------------------------------------------*/

#include	<assert.h>
#include	<stdlib.h>
#include	<stdio.h>

#define		ZY_STACK_IMPLEMENTATION
#include	<zy/stack.h>


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  stack_empty
 *  Description:  whether the stack is empty
 * =====================================================================================
 */
int stack_empty(stack_t * st_p)
{
	assert(st_p);
	return st_p->cnt == 0;                                  /* if empty, return 1 */
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  stack_create
 *  Description:  make a new one, return the start addr
 * =====================================================================================
 */
stack_t *stack_create()
{
	stack_t * stk = (stack_t *) calloc(1, sizeof(stack_t));
	if (!stk) {
		fprintf(stderr, "Calloc Stack Failure!\n");
		exit(EXIT_FAILURE);
	}
	return stk;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  stack_push
 *  Description:  
 * =====================================================================================
 */
void stack_push(stack_t * st_p, STACK_TYPE x)             
{                                                              
	assert(st_p);                                           
								
	stack_n *tmp = (stack_n *) calloc(1, sizeof(stack_n));           
	if (!tmp) {                                             
		fprintf(stderr, "Calloc Stack stack_n Failure!\n");           
		exit(EXIT_FAILURE);                             
	}                                                       
								
	tmp->x = x;                                             /* stack_n.x */
	tmp->link = st_p->head;                                 /* stack_n.link */
	st_p->head = tmp;                                       /* stack.head */
	st_p->cnt++;                                            /* stack.cnt */
}                                                              

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  stack_pop
 *  Description:  return the poped one
 * =====================================================================================
 */
STACK_TYPE stack_pop(stack_t * st_p)
{
	assert(st_p);
	/* can't use it, if poped all, cnt ought to be 0 */
	/* assert(st_p->cnt); */

	if (!st_p->cnt) {
		return 0;
	}

	stack_n *tmp = st_p->head;
	STACK_TYPE x = tmp->x;

	st_p->head = st_p->head->link;                          /* stack.head */
	st_p->cnt--;                                            /* stack.cnt */

	free(tmp);                                              /* stack_n */
	tmp = NULL;                                             /* make sure */
	
	return x;
}


/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  stack_free
 *  Description:  free stack and all of nodes
 * =====================================================================================
 */
void stack_free(stack_t * st_p)
{
	assert(st_p);

	stack_n * current = st_p->head;
	stack_n * next;

        while (current) {                                       /* current is the flag */
		next = current->link;
		free(current);
		current = next;
	}

	free(st_p);
	st_p = NULL;
}
