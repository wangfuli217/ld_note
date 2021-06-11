#ifndef __RCYH_RBTREE_RC_H__
#define __RCYH_RBTREE_RC_H__

#include "rbtree.h"

struct rb_data
{
	signed   long key;
	unsigned long size;
	unsigned char data[];
};

struct container
{
	struct rb_node rb_node;
	struct rb_data rb_data;
};

/*
 * Initializing rbtree root
 */
extern void 
init_rbtree(struct rb_root *root);

/*
 * Search key node from rbtree
 */
extern struct container *
container_search(struct rb_root *root, int key);

/*
 * Insert key node into rbtree
 */
extern int 
container_insert(struct rb_root *root, struct container *cont);

/*
 * Delete the key node from rbtree
 *     delete node from rbtree, return node pointer
 */
extern struct container *
container_delete(struct rb_root *root, int key);

/*
 * Replace the key node from rbtree for new container
 *    replace node from rbtree, return old node pointer
 */
struct container * 
container_replace(struct rb_root *root, int key, struct container *con);

#endif /* __RCYH_RBTREE_RC_H__ */
