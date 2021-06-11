#include "rbtree_rc.h"
#include <stddef.h>

/*
 * Initializing rbtree root
 */
void init_rbtree(struct rb_root *root)
{
	*root = RB_ROOT;
}

/*
 * Search key node from rbtree
 */
struct container *container_search(struct rb_root *root, int key)
{
	struct rb_node *node = root->rb_node;
	
	while (node) 
	{
		struct container *this = rb_entry(node, struct container, rb_node);
		
		int result = key - this->rb_data.key;
		
		if (result < 0)
			node = node->rb_left;
		else if (result > 0)
			node = node->rb_right;
		else
			return this;
	}
	return 0;
}

/*
 * Insert key node into rbtree
 */
int container_insert(struct rb_root *root, struct container *cont)
{
	struct rb_node **new = &(root->rb_node); 
	struct rb_node  *parent = 0;
		
	/* Figure out where to put new node */
	while (*new) 
	{
		struct container *this = rb_entry(*new, struct container, rb_node);
		
		int result = cont->rb_data.key - this->rb_data.key;
		
		parent = *new;
		
		if (result < 0)
			new = &((*new)->rb_left);
		else if (result > 0)
			new = &((*new)->rb_right);
		else
			return -1; // the key is already exists
	}

	/* Add new node and rebalance tree. */
	rb_link_node(&(cont->rb_node), parent, new);
	rb_insert_color(&(cont->rb_node), root);

	return 0;
}

/*
 * Delete the key node from rbtree
 *     delete node from rbtree, return node pointer
 */
struct container *container_delete(struct rb_root *root, int key)
{
	struct container *find = container_search(root, key);
	if (!find)
		return 0;
	rb_erase(&find->rb_node, root);
	return find;
}

/*
 * Replace the key node from rbtree for new container
 *    replace node from rbtree, return old node pointer
 */
struct container * container_replace(struct rb_root *root, int key, struct container *con)
{
	struct container *find = container_search(root, key);
	if (!find)
		return 0;
	rb_replace_node(&(find->rb_node), &con->rb_node, root);
	return find;
}
