#include <stdio.h>
#include "alist.h"
#include "llist.h"

/*
 * All examples in here can be used with both array and linked lists. To use
 * arraylists instead of linked lists, change LLIST_PROTO and LLIST to
 * ALIST_PROTO and ALIST, respectively.
 *
 * The examples use a list of integers named int_list. The list name and the
 * type of its elements are arbitrary. The name of supplementary types and
 * functions is derived by appending a _name to the supplied name, such as
 * int_list_new (int_list ## _new). A list can contain pointers as well as
 * normal values (primitives, structs, etc).
 */

/* create prototypes for a list of integers, this should be put in a header*/
LLIST_PROTO(int, int_list);

/* create functions for our list, this goes in a .c file */
LLIST(int, int_list);

/* a helper function to print a list and demonstrate iterating */
void print_list(int_list *list)
{
	/* to iterate lists, use an iterator */
	int_list_iterator i;

	/*
	 * int_list_iterator int_list_iterate(int_list *) will give us a new iterator.
	 * In linked list, that's a poiner to a struct containing the value and
	 * pointer to the next such element of the list and in alist, that's an
	 * integer index.
	 *
	 * int int_list_next(int_list *, int_list_iterator *) must be used first to
	 * move the iterator to the first element. It returns 0 when there are no
	 * more elements in the list.
	 */
	for (i = int_list_iterate(list); int_list_next(list, &i); ) {
		/* 
		 * int int_list_get_at(int list *, int_list_iterator) will retrieve
		 * the value in the list stored at the current position of the iterator.
		 *
		 * This is undefined for new iterators that haven't been moved to the first
		 * element with int_list_next yet.
		 *
		 * like int_list_get_at is the iterator equivalent to int_list_get,
		 * int_list_set_at is equivalent to int_list_set.
		 * There are also int_list_insert_after and int_list_pop_after, which
		 * work on the element one position after the iterator's current position.
		 */
		printf("%d ", int_list_get_at(list, i));
	}
	/* 
	 * int int_list_size(int_list *) is the length of the list.
	 * 
	 * In llist, this shouldn't be changed. In alist, this can be decremented to
	 * remove elements from the tail of the list. alists also have list->cap,
	 * which is the current capacity of the array, of which only the first
	 * list->len elements are defined. These fields are not exported by the _PROTO
	 * macros and have to be exported manually.
	 */
	printf("len: %d\n", int_list_size(list));
}

int main(void)
{
	/* a list is always stored as a pointer */
	int_list *list;

	/* int_list *int_list_new(void) allocates and initializes a new list */
	list = int_list_new();

	/*
	 * int_list_insert(int_list *list, int item, int pos) inserts item to
	 * position pos in the list (so that int_list_get(list, pos) == item).
	 * The type of item parameter is the same as the type of list elements.
	 *
	 * A special position -1 means insert to the tail of the list (same as
	 * inserting with position set int_list_size(list)). That is an O(1) operation
	 * in both llist and alist.
	 *
	 * Additionally, inserting to the head of the list (position == 0) is also
	 * O(1) in linked lists. Otherwise, linked list insertions are O(n) in llist
	 * because it's necessary to iterate the list to the position before inserting
	 * and also in alist because all the elements after pos need to be shifted.
	 */
	int_list_insert(list, 20, 0);  /* {20} */
	int_list_insert(list, 40, 1);  /* {20, 40} */
	int_list_insert(list, 30, 1);  /* {20, 30, 40} */
	int_list_insert(list, 50, -1); /* {20, 30, 40, 50} */
	int_list_insert(list, 10, 0);  /* {10, 20, 30, 40, 50} */
	print_list(list);

	/* int int_list_get(int_list *list, int pos) returns the item in list at
	 * position pos (the return value type depends on the type of list elements).
	 *
	 * Just like in insert, value of -1 means the last item.
	 *
	 * In llist, this is an O(n) operation, as the list must be iterated first.
	 */
	printf("list[3] is %d\n", int_list_get(list, 3)); /* 40 */
	printf("list[-1] is %d\n", int_list_get(list, -1)); /* 50 */

	/*
	 * int int_list_pop(int_list *list, int pos) will remove the element at
	 * position pos from list and return it (return value type depends on element
	 * type). The return value from this function can be ignored to just remove
	 * an element.
	 *
	 * Position -1 again means position int_list_size(list).
	 *
	 * In llist, this is an O(n) operation except for pos 0 or -1, since the
	 * list needs to be iterated to pos. In alist, this is also O(n), since all
	 * elements past position pos need to be shifted back (except on position -1
	 * or int_list_size(list), where it's O(1), as it requires only list->len to
	 * be decremented).
	 */
	printf("pop list[2]: %d\n", int_list_pop(list, 2)); /* 30 */
	print_list(list); /* 10 20 40 50 */

	/*
	 * int_list_set(int_list *list, int value, int pos) sets the element in list
	 * at position pos to value (type of the value parameter is the type of list
	 * elements).
	 *
	 * Position -1 is equivalent to position int_list_size(list).
	 *
	 * In llist, this is a O(n) operation except for the first and last elements,
	 * since the list needs to be iterated to that position first.
	 */
	int_list_set(list, 30, 2);
	int_list_set(list, 40, -1);
	print_list(list); /* 10 20 30 40 */

	/* the list can't just be free'd with free(), as it contains other pointers */
	int_list_free(list);

	return 0;
}
