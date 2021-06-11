/*
 * =====================================================================================
 *
 *       Filename:  list.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  09.03.10
 *       Revision:  
 *       Compiler:  GCC 4.4.3
 *
 *         Author:  Yang Zhang, imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */


#include	<stdio.h>
#include	<stdlib.h>
#include	<assert.h>

#define		LIST_IMP_ZY
#include	<zy/list.h>
#include	<zy/alloc.h>

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  list_create
 *  Description:  
 * =====================================================================================
 */
list_t_zy *create()
{
	return MALLOC(sizeof(list_t_zy));
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  list_free
 *  Description:  free the nodes & list itself
 * =====================================================================================
 */
void free(list_t_zy * list)
{
	assert(list);

	list_n_zy *current = list->head;
	list_n_zy *next;
	while (current) {	/* the list */
		next = current->link;
		FREE(current);
		current = next;
	}
	FREE(list);		/* the head */
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  list_length
 *  Description:  length of the request list
 * =====================================================================================
 */
size_t length(list_t_zy * list)
{
	assert(list);
	return list->cnt;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  list_push
 *  Description:  as the name, push one at the head
 * =====================================================================================
 */
void push(list_t_zy * list, LIST_T_ZY x)
{
	assert(list);
	list_n_zy *node = MALLOC(sizeof(list_n_zy));
	node->x = x;
	node->link = list->head;	/* maybe NULL, if it's the 1st */
	list->head = node;
	list->cnt++;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  list_pop
 *  Description:  as the name, pop one
 * =====================================================================================
 */
LIST_T_ZY pop(list_t_zy * list)
{
	assert(list);
	list_n_zy *node = list->head;
	list->head = node->link;
	LIST_T_ZY retval = node->x;
	FREE(node);
	return retval;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  list_append
 *  Description:  add a new node at the tail
 * =====================================================================================
 */
int append(list_t_zy * list, LIST_T_ZY x)
{
	assert(list);
	list_n_zy *search;
	list_n_zy *node = (list_n_zy *)CALLOC(1, sizeof(list_n_zy));
	node->x = x;		/* link default to be NULL */

	if (!(search = list->head)) {
		list->head = node;
		list->cnt++;
		return 0;
	}

	/*-----------------------------------------------------------------------------
	 *  if arrive here, the list has at least one node
	 *
	 *  can't be "while (search)"
	 *  when find out that it's NULL, no way to go one step back
	 *  setjmp/longjmp could fix it, but we don't wanna use it here
	 *-----------------------------------------------------------------------------*/
	while (search->link) {
		search = search->link;
	}
	search->link = node;
	list->head = node;
	list->cnt++;

	return 0;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  list_insert
 *  Description:  insert a list at the certain position returned by FUNC
 *  		  which is a func pointer and uses the same parameters with the caller
 * =====================================================================================
 */
size_t insert(list_t_zy * list, LIST_T_ZY x, size_t(*)(list_t_zy *, LIST_H_ZY) func)
{
	size_t pos = func(list, x);
	list_n_zy *ptr = list->head;
	list_n_zy *node;

	if (pos > list->cnt + 1) {	/* maybe a new one appended */
		fprintf(stderr, "Insert Failure!\n");
		fflush(stderr);
		exit(EXIT_FAILURE);
	}

	/*-----------------------------------------------------------------------------
	 *  insert at position POS, so need the addr of "pos - 1"
	 *-----------------------------------------------------------------------------*/
	for (int i = 0; i < pos - 1; i += 1) {
		ptr = ptr->link;
	}
	node = MALLOC(sizeof(list_n_zy));
	node->link = ptr->link;
	ptr->link = node;

	return pos;
}
