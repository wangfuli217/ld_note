
/*
 * List code based on Linux's list.h.
 */

#ifndef __LIST_H__
#define __LIST_H__

#include <stdlib.h>

struct list_head {
    struct list_head *prev, *next;
};

#define list_entry(ptr, type, memb) \
	((type *)((void *)ptr - (size_t)&((type *)0)->memb))

#define list_for_each(i, head) \
	for((i)=(head)->next; (i)!=(head); (i)=(i)->next)

#define list_for_each_prev(i, head) \
	for((i)=(head)->prev; (i)!=(head); (i)=(i)->prev)

#define list_for_each_entry(i, h, m) \
	for ((i) = list_entry((h)->next, typeof(*(i)), m); \
			&(i)->m != (h); \
			(i) = list_entry((i)->m.next, typeof(*(i)), m))

#define list_for_each_entry_safe(i, n, h, m) \
	for ((n) = (i) = list_entry((h)->next, typeof(*(i)), m); \
			(n) = list_entry((n)->m.next, typeof(*(i)), m), \
			&(i)->m != (h); \
			(i) = (n))

#define LIST_HEAD_INIT(name) { &(name), &(name) }
#define LIST_HEAD(name) struct list_head name = LIST_HEAD_INIT(name)
#define INIT_LIST_HEAD(list) do { \
	(list)->next = (list)->prev = (list); \
} while(0)

#define INIT_LIST_ITEM(name) { name , name }

static inline void list_head_init (struct list_head *item) {
    item->next = item->prev = item;
}

static inline void __list_add (struct list_head *new, struct list_head *prev, struct list_head *next) {
    new->next = next;
    new->prev = prev;
    next->prev = new;
    prev->next = new;
}

static inline void list_add (struct list_head *new, struct list_head *head) {
    __list_add (new, head, head->next);
}

static inline void list_add_tail (struct list_head *new, struct list_head *head) {
    __list_add (new, head->prev, head);
}

static inline void list_del (struct list_head *item) {
    item->next->prev = item->prev;
    item->prev->next = item->next;
    item->next = item;
    item->prev = NULL;
}

static inline void list_del_init (struct list_head *item) {
    list_del (item);
    INIT_LIST_HEAD (item);
}

static inline int list_empty (const struct list_head *item) {
    return item->next == item;
}

static inline void list_move (struct list_head *item, struct list_head *head) {
    list_del (item);
    list_add (item, head);
}

static inline void list_move_tail (struct list_head *item, struct list_head *head) {
    list_del (item);
    list_add_tail (item, head);
}

static inline void __list_splice (struct list_head *list, struct list_head *head) {
    struct list_head *first = list->next;
    struct list_head *last = list->prev;
    struct list_head *at = head->next;

    first->prev = head;
    head->next = first;

    last->next = at;
    at->prev = last;
}

static inline void list_splice (struct list_head *list, struct list_head *head) {
    if (!list_empty (list))
        __list_splice (list, head);
}

static inline void list_splice_init (struct list_head *list, struct list_head *head) {
    if (!list_empty (list)) {
        __list_splice (list, head);
        list_head_init (list);
    }
}

static inline struct list_head *list_pop (struct list_head *head) {
    struct list_head *item = head->next;
    if (item != head)
        list_del_init (item);
    return item;
}

#define list_pop_entry(head, type, member) \
	list_entry(list_pop(head), type, member)

#define list_next_entry(pos, memb) \
	list_entry((pos)->memb.next, typeof(*pos), memb)

#define list_prev_entry(pos, memb) \
	list_entry((pos)->memb.prev, typeof(*pos), memb)

#endif
