#ifndef SET_H_
#define SET_H_
#include "rbtree_augmented.h"
#include "types.h"
/*
 *we use red black tree to implement set
 */
#ifdef DEBUG
#include <stdio.h>
#define SET_ERROR   printf
#else
static inline  void SET_ERROR(char *fmt, ...){};
#endif
#define set_node rb_node
/*cmp function 
 * return 0 if elem1 == elem2
 * return >0 if elem1 > elem2
 * return <0 if elem1 < elem2
 */
typedef int (*set_cmp_func)(struct set_node *elem1,struct set_node *elem2);
typedef struct set_node *(*set_copy_func)(struct set_node *elem);
typedef void (*set_destroy_func)(struct set_node *elem);
struct set {
	struct rb_root root;
	set_cmp_func cmp_func;
	set_copy_func copy_func;
	set_destroy_func destroy_func;
	unsigned  long num;
};

static inline void set_init(struct set *set, set_cmp_func cmp_func, set_copy_func copy_func, set_destroy_func destroy_func)
{
	set->root = RB_ROOT;
	set->cmp_func = cmp_func;
	set->copy_func = copy_func;
	set->destroy_func = destroy_func;
	set->num = 0;
}
#define	set_entry(ptr, type, member) container_of(ptr, type, member)
#define set_for_each(pos, set) \
	for (pos = rb_first(&(set)->root); pos; pos = rb_next(pos))

#define set_for_each_reverse(pos, set) \
	for (pos = rb_last(&(set)->root); pos; pos = rb_prev(pos))

extern int set_insert(struct set *set, struct set_node *node);
extern int set_remove(struct set *set, struct set_node *node);
extern int set_remove_destroy(struct set *set, struct set_node *node);
extern int set_union(struct set *setu, struct set *set1, struct set *set2);
extern int set_difference(struct set *setd,struct  set *set1, struct set *set2);
extern int set_intersection(struct set *seti,struct  set *set1, struct set *set2);
extern int set_is_equal(struct set *set1, struct set *set2);
extern int set_is_subset(struct set *set1, struct set *set2);

#endif
