/* reference David Hanson, "C Interfaces and Implementations" */

#ifndef SLIST_INCLUDED
#define SLIST_INCLUDED

#include "pair.h"
#include "arena.h"

/* 
 * A singly-linked list. The simplest generic container imaginable,
 * provides:
 * 	O(n) access to arbitrary element of list
 * 	O(n) access to tail of list
 * 	O(1) access to head of list
 * 	O(1) insertion or removal to head of list
 *
 * Apart from simplicity the major benefit of slist is the fact that
 * there is no "head" pointer, so an arbitrary element of the list 
 * can "stand in" as a complete list consisting of that element and
 * all subsequent elements of the original list. You initialize a 
 * new list by creating a node pointer and setting it to NULL.
 * 
 * You should usually use "vector", not "slist", for generic linear
 * components. Vectors provide constant-time random access to elements
 * of the list, amortized insertion (by doubling in size when resizing
 * is required), but slower insertion (due to copying) at any point
 * other than the end of the container. 
 *
 * See below for API documentation.
 */

struct list_s {
	struct list_s *next;
	void *data;
};

/* Basic thing to remember:
 *
 * There is no head pointer, so operations that change the list return a
 * pointer to the "new" (original, but modified) list. You must replace
 * the pointer to the list with the return value of the operation!
 */
 
typedef struct list_s slist_t;

/* Cat two slists together. An idiom for adding an element to the end
 * of a list (this is expensive):
 *
 * list = slist_append(list, slist_list(element, NULL));
 *
 * This creates a new, single-element list for the element and appends
 * the single-element list to the original list.
 */
slist_t *slist_append(slist_t *list, slist_t *tail);

/* Copy the nodes (but not the data values) of a list 
 */
slist_t *slist_copy(slist_t *list);

/* Create a new list; varargsed until NULL 
 */
slist_t *slist_list(void *x, ...);

/* Remove the first element from the list (save the return value!), 
 * returning the data value through "x"
 */
slist_t *slist_pop(slist_t *list, void **x);

/* Delete a node from the list (iterate through the list, saving
 * node pointers, pass the victim node pointer through.
 */
slist_t *slist_delete(slist_t *list, slist_t *victim);

/* The fastest and best way to add an element to the list:
 *     list = slist_push(list, element); // at head of list
 */
slist_t *slist_push(slist_t *list, void *x);

/* Reverse the order of elements in the list in O(n) time, with no allocs */
slist_t *slist_reverse(slist_t *list) ;

/* Count the number of elements in the list in O(n) time. This is
 * "expensive" in slist.
 */
int     slist_count(slist_t *list);

#define slist_next(np) (np)->next
#define slist_data(np) (np)->data

/* Find an element using a callback */
slist_t *slist_find(slist_t *list, void *key, 
			int compare(slist_t *, const void *));

/* Release a list, pass a POINTER TO A POINTER to the list (this fn
 * NULLs the pointer
 */
void    slist_release(slist_t **list) ;

/* Convert the list to a void *array[] of elements 
 */
void  **slist_2array(slist_t *list, void *end);

/* Call a function over each element of the list */
void    slist_map(slist_t *list, 
		     void apply(void **x, void *cl),
		     void *cl);

/* arena-ized variants of the creative/destructive functions above, 
 * for temporary lists
 */
slist_t *tslist_copy(arena_t *a, slist_t *list);
slist_t *tslist_list(arena_t *a, void *x, ...);
slist_t *tslist_pop(arena_t *a, slist_t *list, void **x);
slist_t *tslist_delete(arena_t *a, slist_t *list, slist_t *victim);
slist_t *tslist_push(arena_t *a, slist_t *list, void *x);
void     tslist_release(arena_t *a, slist_t **list) ;


#endif
