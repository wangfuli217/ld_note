/* From David Hanson, C Interfaces & Implementations */

#include "slist.h"

#include <stdarg.h>
#include <stddef.h>
#include <assert.h>
#include <stdlib.h>

/* ------------------------------------------------------------ */

/* append list at "tail" to "list" */

slist_t *
slist_append(slist_t *list, slist_t *tail) {
	slist_t **lp = &list;

	while(*lp) 
		lp = &(*lp)->next;

	*lp = tail;

	return(list);
}

/* ------------------------------------------------------------ */

/* stick the value at "x" onto "list" */

#define U1 (size_t)1

slist_t *
slist_push(slist_t *list, void *x) {
	slist_t *p = (slist_t *) calloc(U1, sizeof(struct list_s));

	p->data = x;
	p->next = list;

	return(p);
}

/* ------------------------------------------------------------ */

/* create a new list with a variable number of pointers */

slist_t *
slist_list(void *x, ...) {
	va_list ap;
	slist_t *list = NULL;
	slist_t **lp = &list;

	va_start(ap, x);

	for( /* */ ; x; x = va_arg(ap, void *)) {
		*lp = calloc(U1, sizeof(**lp));
		(*lp)->data = x;
		lp = &(*lp)->next;
	}

	*lp = NULL;

	va_end(ap);

	return(list);
}

/* ------------------------------------------------------------ */

/* copy "list" into a new list */

slist_t *
slist_copy(slist_t *list) {
	slist_t *head = NULL;
	slist_t **lp = &head;

	for( /* */ ; list; list = list->next) {
		*lp = calloc(U1, sizeof(**lp));
		(*lp)->data = list->data;
		lp = &(*lp)->next;
	}

	*lp = NULL;

	return(head);
}

/* ------------------------------------------------------------ */

/* deallocate and return the value of the first node of "list" */

slist_t *
slist_pop(slist_t *list, void **x) {
	if(list) {
		slist_t *head = list->next;
		if(x)
			*x = list->data;
		     
		free(list);

		return(head);
	} else {
		*x = NULL;
		return(list);
	}
}

/* ------------------------------------------------------------ */

slist_t *
slist_delete(slist_t *list, slist_t *victim) {
	slist_t *savenode = NULL, *node;

	if(!victim || !list)
		return(NULL);
	
	if(list == victim) {
		list = list->next;
		free(victim);
		return(list);
	}

	for(node = list; node; savenode = node, node = savenode->next) 
		if(node == victim)
			break;

	if(!node) {
		free(victim);
		return(NULL);
	}

	node = node->next;
	savenode->next = node;
	free(victim);

	return(list);
}

/* ------------------------------------------------------------ */

/* flip "list" over */

slist_t *
slist_reverse(slist_t *list) {
	slist_t *head = NULL; 
	slist_t *next;

	for( /* */ ; list; list = next) {
		next = list->next;
		list->next = head;
		head = list;
	}

	return(head);
}

/* ------------------------------------------------------------ */

/* return the length of "list" */

int 
slist_count(slist_t *list) {
	int i;

	for(i = 0; list; list = list->next) 
		i++;

	return(i);
}

/* ------------------------------------------------------------ */

/* find a node in a linked list, return a pointer to it */

slist_t *slist_find(list, key, compare)
slist_t *list;
void *key;
int compare(slist_t *, const void *);
{
	slist_t *node;

	assert(compare);

	if(!list)
		return(NULL);

	for(node = list; node; node = node->next) 
		if(compare(node, key))
			return(node);

	return(NULL);
}

/* ------------------------------------------------------------ */

/* free up the entire linked list */

void 
slist_release(slist_t **list) {
	slist_t *next;

	assert(list);

	for( /* */ ; *list; *list = next) {
		next = (*list)->next;
		free(*list);
	}
}

/* ------------------------------------------------------------ */

/* call "apply" for the value of each node in the list. "cl" 
 * is the value to use for the end of the list - leave it
 * as "NULL" if you don't care.
 */

void 
slist_map(slist_t *list,
	   void apply(void **x, void *cl),
	   void *cl) {
	assert(apply);

	for( /* */ ; list; list = list->next) 
		apply(&list->data, cl);
}

/* ------------------------------------------------------------ */

/* return an array representing the value of each node in "list",
 * with "END" being the value for the end of the list, or NULL. 
 */

void **
slist_2array(slist_t *list, void *end) {
	int i;
	int l = slist_count(list);

	void **array = (void *) malloc((l + 1) * sizeof(*array));

	for(i = 0; i < l; i++) {
		array[i] = list->data;
		list = list->next;
	}

	array[i] = end;

	return(array);
}

/* ------------------------------------------------------------ */

slist_t *
tslist_copy(arena_t *a, slist_t *list) {
	slist_t *head = NULL;
	slist_t **lp = &head;

	for( /* */ ; list; list = list->next) {
		*lp = arena_alloc(a, sizeof(**lp));
		(*lp)->next = NULL;
		(*lp)->data = list->data;
		lp = &(*lp)->next;
	}

	*lp = NULL;

	return(head);
}

/* ------------------------------------------------------------ */

slist_t *
tslist_list(arena_t *a, void *x, ...) {
	va_list ap;
	slist_t *list = NULL;
	slist_t **lp = &list;

	va_start(ap, x);

	for( /* */ ; x; x = va_arg(ap, void *)) {
		*lp = arena_alloc(a, sizeof(**lp));
		(*lp)->data = x;
		(*lp)->next = NULL;
		lp = &(*lp)->next;
	}

	*lp = NULL;

	va_end(ap);

	return(list);
}

/* ------------------------------------------------------------ */

slist_t *
tslist_pop(arena_t *a, slist_t *list, void **x) {
	if(list) {
		slist_t *head = list->next;
		if(x)
			*x = list->data;
		     
		return(head);
	} else {
		*x = NULL;
		return(list);
	}
}

/* ------------------------------------------------------------ */

slist_t *
tslist_delete(arena_t *a, slist_t *list, slist_t *victim) {
	slist_t *savenode = NULL, *node;

	if(!victim || !list)
		return(NULL);
	
	if(list == victim) {
		list = list->next;
		return(list);
	}

	for(node = list; node; savenode = node, node = savenode->next) 
		if(node == victim)
			break;

	if(!node) {
		free(victim);
		return(NULL);
	}

	node = node->next;
	savenode->next = node;

	return(list);
}

/* ------------------------------------------------------------ */

slist_t *
tslist_push(arena_t *a, slist_t *list, void *x) {
	slist_t *p = (slist_t *) arena_alloc(a, sizeof *p);

	p->data = x;
	p->next = list;

	return(p);
}

/* ------------------------------------------------------------ */

void 
tslist_release(arena_t *a, slist_t **list) {
	*list = NULL;
}
