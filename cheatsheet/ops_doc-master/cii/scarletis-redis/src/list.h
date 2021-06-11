#ifndef LIST_H
#define LIST_H

/* Basic type for the double-link list.  */
typedef struct list_head {
  struct list_head *next;
  struct list_head *prev;
} list_t;

/* Define a variable with the head and tail of the list.  */
# define S_LIST_HEAD(name) \
  list_t name = { &(name), &(name) }

/* Initialize a new list head.  */
# define S_INIT_LIST_HEAD(ptr) \
  (ptr)->next = (ptr)->prev = (ptr)

/* Get typed element from list at a given position.  */
# define list_entry(ptr, type, member) \
  ((type *) ((char *) (ptr) - (unsigned long) (&((type *) 0)->member)))

/* Iterate forward over the elements of the list.  */
# define list_for_each(pos, head) \
  for (pos = (head)->next; pos != (head); pos = pos->next)

/* Iterate forward over the elements list.  The list elements can be
   removed from the list while doing this.  */
# define list_for_each_safe(pos, p, head) \
  for (pos = (head)->next, p = pos->next; pos != (head); pos = p, p = pos->next)

/* Iterate backwards over the elements of the list.  */
# define list_for_each_prev(pos, head) \
  for (pos = (head)->prev; pos != (head); pos = pos->prev)

/* Iterate backwards over the elements list.  The list elements can be
   removed from the list while doing this.  */
# define list_for_each_prev_safe(pos, p, head) \
  for (pos = (head)->prev, p = pos->prev; pos != (head); pos = p, p = pos->prev)

/* Insert new element before a element.  */
void list_insert (list_t *newp, list_t *elem);

/* Remove element from list.  */
void list_del (list_t *elem);

/* Slice list */
void list_slice (list_t *head, list_t *elem, list_t *new_head);

/* Get ptr to the middle node of the list */
list_t *list_half (list_t *head);

/* Swap elements in list. */
void list_swap (list_t *a, list_t *b);

/* Join two lists.  */
void list_join (list_t *head, list_t *add);

#endif	/* list.h */
