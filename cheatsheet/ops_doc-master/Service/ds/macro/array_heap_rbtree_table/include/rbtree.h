/*
 * rbtree.h - Red-black trees
 *
 * Copyright 2017 Eric Chai <electromatter@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef RBTREE_H
#define RBTREE_H

/*
 * Red-black trees satisfy the following invariants:
 *  - Links are directed
 *  - All paths start from the root
 *  - A link is either red or black
 *  - A nil link terminates a path and are considered to be black
 *  - A node is defined have the same color as the link from its parent
 *  - A red node only contains black links
 *  - Every path has the same number of black links
 *
 * Thus, height of a red-black tree is bounded by 2 * lg(n)
 */

#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <limits.h>
#include <assert.h>

/* Red-black tree link type. Must be an integer that can contain a pointer. */
typedef uintptr_t rbt_link_t;

/*
 * struct rbt_node must be aligned to at least 2 bytes since the lowest bit of
 * the pointer is used as the color of the pointer. This must be the field
 * member of node_t.
 */
struct rbt_node {
	rbt_link_t left, right;
};

/* The Red-black tree root. */
#define RBT_DEF(name)							\
struct name {								\
	/* Link to the root node */					\
	rbt_link_t root;						\
	/* Structural modification counter */				\
	size_t mod_count;						\
}

/* Maximum height of a tree in memory */
#define RBT_MAX_HEIGHT			(sizeof(size_t) * CHAR_BIT * 2)
/* Mask of the pointer value of a rbt_link_t */
#define RBT_MASK			(~(rbt_link_t)1)
/* A rbt_link_t nil link */
#define RBT_NIL				((rbt_link_t)0)

/* Is the tree empty */
#define RBT_EMPTY(tree)			(!tree->root)

/* rbt_link_t constructors */
#define RBT_LINK(node, red)		((rbt_link_t)(node) | (!!red))
#define RBT_BLACK_LINK(node)		(RBT_LINK(node, 0))
#define RBT_RED_LINK(node)		(RBT_LINK(node, 1))

/* rbt_link_t accessors */
#define RBT_RED(link)			((link) & 1)
#define RBT_NODE(link)							\
	((struct rbt_node *)((1 ? (link) : RBT_NIL) & RBT_MASK))

/* struct rbt_node accessors */
#define RBT_ROOT(tree)			(RBT_NODE((tree)->root))
#define RBT_LEFT(node)			(RBT_NODE((node)->left))
#define RBT_RIGHT(node)			(RBT_NODE((node)->right))

/* struct rbt_node * to node_t */
#define RBT_USER(node_t, field, node)	 				\
	((node_t*)((char *)(1 ? (node) : &((node_t *)0)->field) -	\
						offsetof(node_t, field)))

/* rbt_link_t to node_t */
#define RBT_USERNODE(node_t, field, link)				\
	RBT_USER(node_t, field, RBT_NODE(link))

/* The identity key function */
#define RBT_ID(x)			(x)

static inline rbt_link_t *rbt_insert_descend(rbt_link_t *link, int dir)
{
	struct rbt_node *node, *child;

	/*
	 * Invariants:
	 *  - The node is black.
	 *  - The grandparent is black or node is the root.
	 */

	/* If the link is nil, then it is the insertion point. */
	node = RBT_NODE(*link);
	if (!node)
		return link;

	/* Split a 4-node into two 2-nodes and merge into the grandparent. */
	if (RBT_RED(node->left) && RBT_RED(node->right)) {
		node->left = RBT_BLACK_LINK(RBT_LEFT(node));
		node->right = RBT_BLACK_LINK(RBT_RIGHT(node));
		*link = RBT_RED_LINK(node);
	}

	if (dir > 0) {
		if (!RBT_RED(node->right))
			return &node->right;
		/* Rotate to ensure that the node is black */
		child = RBT_RIGHT(node);
		node->right = child->left;
		child->left = RBT_RED_LINK(node);
		*link = RBT_BLACK_LINK(child);
		return link;
	} else if (dir < 0) {
		if (!RBT_RED(node->left))
			link = &node->left;
		/* Rotate to ensure that the node is black */
		child = RBT_LEFT(node);
		node->left = child->right;
		child->right = RBT_RED_LINK(node);
		*link = RBT_BLACK_LINK(child);
		return link;
	} else {
		/* Found the node in the tree */
		return link;
	}
}

static inline rbt_link_t *rbt_remove_descend(rbt_link_t *link, int dir)
{
	struct rbt_node *node, *child, *sib, *sib_near;

	/*
	 * Invariant: At least one of the following is red or has a red child:
	 *  - This node.
	 *  - This node's left child.
	 *  - This node's right child.
	 */

	node = RBT_NODE(*link);
	if (dir > 0) {
		child = RBT_RIGHT(node);
		sib = RBT_LEFT(node);

		/* If the child is part of a 3-node or 4-node then continue */
		if (!node->right || RBT_RED(node->right) ||
				RBT_RED(child->left) ||
				RBT_RED(child->right)) {
			return &node->right;
		}

		/*
		 * The sibling is red, node must be black, rotate to get to
		 * the sibling 2-3-4 node.
		 */
		if (RBT_RED(node->left)) {
			*link = RBT_BLACK_LINK(sib);
			node->left = sib->right;
			sib->right = RBT_RED_LINK(node);
			link = &sib->right;
			sib = RBT_LEFT(node);
		}

		/*
		 * The child is a 2-node, therefore it's sibling exists.
		 * If the sibling is a 2-node, then either node is the root
		 * or it must be red. In either case, we can merge node, child,
		 * and the sibling into a 4-node.
		 */
		if (!RBT_RED(sib->left) && !RBT_RED(sib->right)) {
			node->right = RBT_RED_LINK(child);
			node->left = RBT_RED_LINK(sib);
			*link = RBT_BLACK_LINK(node);
			return &node->right;
		}

		/* Borrow the far child of the sibling */
		if (!RBT_RED(sib->right)) {
			node->left = sib->right;
			node->right = RBT_RED_LINK(child);
			sib->right = RBT_BLACK_LINK(node);
			sib->left = RBT_BLACK_LINK(RBT_NODE(sib->left));
			*link = RBT_LINK(sib, RBT_RED(*link));
			return &node->right;
		}

		/* Borrow the near child of the sibling */
		sib_near = RBT_RIGHT(sib);
		sib->right = sib_near->left;
		node->left = sib_near->right;
		node->right = RBT_RED_LINK(child);
		sib_near->left = RBT_BLACK_LINK(sib);
		sib_near->right = RBT_BLACK_LINK(node);
		*link = RBT_LINK(sib_near, RBT_RED(*link));
		return &node->right;
	} else if (dir < 0) {
		child = RBT_LEFT(node);
		sib = RBT_RIGHT(node);

		/* If the child is part of a 3-node or 4-node then continue */
		if (!node->left || RBT_RED(node->left) ||
				RBT_RED(child->right) ||
				RBT_RED(child->left)) {
			return &node->left;
		}

		/*
		 * The sibling is red, node must be black, rotate to get to
		 * the sibling 2-3-4 node.
		 */
		if (RBT_RED(node->right)) {
			*link = RBT_BLACK_LINK(sib);
			node->right = sib->left;
			sib->left = RBT_RED_LINK(node);
			link = &sib->left;
			sib = RBT_RIGHT(node);
		}

		/*
		 * The child is a 2-node, therefore it's sibling exists.
		 * If the sibling is a 2-node, then either node is the root
		 * or it must be red. In either case, we can merge node, child,
		 * and the sibling into a 4-node.
		 */
		if (!RBT_RED(sib->right) && !RBT_RED(sib->left)) {
			*link = RBT_BLACK_LINK(node);
			node->left = RBT_RED_LINK(child);
			node->right = RBT_RED_LINK(sib);
			return &node->left;
		}

		/* Borrow the far child of the sibling */
		if (!RBT_RED(sib->left)) {
			node->right = sib->left;
			node->left = RBT_RED_LINK(child);
			sib->left = RBT_BLACK_LINK(node);
			sib->right = RBT_BLACK_LINK(RBT_NODE(sib->right));
			*link = RBT_LINK(sib, RBT_RED(*link));
			return &node->left;
		}

		/* Borrow the near child of the sibling */
		sib_near = RBT_LEFT(sib);
		sib->left = sib_near->right;
		node->right = sib_near->left;
		node->left = RBT_RED_LINK(child);
		sib_near->right = RBT_BLACK_LINK(sib);
		sib_near->left = RBT_BLACK_LINK(node);
		*link = RBT_LINK(sib_near, RBT_RED(*link));
		return &node->left;
	} else {
		/* Found the node in the tree */
		return NULL;
	}
}

/*
 * Generate the red-black tree prototypes
 *
 * Parameters:
 *  - attr: the function attributes (i.e. static)
 *  - preifx: the function identifier prefix
 *  - tree_t: the tree type defined by RBT_DEF
 *  - node_t: the node type
 *  - key_t: the key type
 */
#define RBT_PROTO(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_INIT(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_INSERT(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_REPLACE(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_REMOVE(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_FIND(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_SUCC(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_PRED(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_FIRST(attr, prefix, tree_t, node_t, key_t)			\
RBT_PROTO_LAST(attr, prefix, tree_t, node_t, key_t)

#define RBT_PROTO_INIT(attr, prefix, tree_t, node_t, key_t)		\
	attr void prefix##init(tree_t *);

#define RBT_PROTO_INSERT(attr, prefix, tree_t, node_t, key_t)		\
	attr int prefix##insert(tree_t *, node_t *);

#define RBT_PROTO_REPLACE(attr, prefix, tree_t, node_t, key_t)		\
	attr node_t *prefix##replace(tree_t *, node_t *);

#define RBT_PROTO_REMOVE(attr, prefix, tree_t, node_t, key_t)		\
	attr node_t *prefix##remove(tree_t *, key_t );

#define RBT_PROTO_FIND(attr, prefix, tree_t, node_t, key_t)		\
	attr node_t *prefix##find(tree_t *, key_t );

#define RBT_PROTO_SUCC(attr, prefix, tree_t, node_t, key_t)		\
	attr node_t *prefix##succ(tree_t *, key_t );

#define RBT_PROTO_PRED(attr, prefix, tree_t, node_t, key_t)		\
	attr node_t *prefix##pred(tree_t *, key_t );

#define RBT_PROTO_FIRST(attr, prefix, tree_t, node_t, key_t)		\
	attr node_t *prefix##first(tree_t *);

#define RBT_PROTO_LAST(attr, prefix, tree_t, node_t, key_t)		\
	attr node_t *prefix##last(tree_t *);

/*
 * Generate the red-black tree implementation
 *
 * Parameters:
 *  - attr: function attributes (i.e. static)
 *  - prefix: function identifier prefix
 *  - tree_t: the tree type defined by RBT_DEF
 *  - node_t: the node type
 *  - key_t: the key type
 *  - field: the name of the struct rbt_node field of node_t
 *  - keyf: the key function
 *  - cmp: the compare function
 *
 * node_t must be a type that has a field of type rbt_node that can be
 * accessed using the syntax: node->field.
 *
 * The key function must have the signature:
 *
 * key_t keyf(node_t *node);
 *
 * The key function returns the key of a node.
 *
 *
 * The compare function must have the signature:
 *
 * int cmp(key_t left, key_t right);
 *
 * The return value of the compare function is specified as follows:
 *  - cmp(left, right) = 1  if left `>` right
 *  - cmp(left, right) = -1 if left `<` right
 *  - cmp(left, right) = 0  if left `=` right
 *
 *
 * All functions are O(lg(n)) where n is the number of nodes in the tree.
 *
 *
 * void prefix##init(tree_t *tree);
 *
 * Initialize an empty tree.
 *
 *
 * int prefix##insert(tree_t *tree, node_t *node);
 *
 * Insert node into the tree and return 0. However, if a node with the same key
 * exists in the tree, return 1 without inserting a duplicate.
 *
 *
 * node_t *prefix##replace(tree_t *tree, node_t *node);
 *
 * Insert node into the tree if it is not already contained in the tree. If
 * a node with the same key exists in the key, then it is replaced with the
 * node passed as an argument and the displaced node is returned.
 *
 *
 * node_t *prefix##remove(tree_t *tree, key_t key);
 *
 * Remove the element identified by key and return it. If no such element
 * is contained in the tree, then NULL is returned.
 *
 *
 * node_t *prefix##succ(tree_t *tree, key_t key);
 *
 * Return the in-order successor of the key if one exists in the tree.
 *
 *
 * node_t *prefix##pred(tree_t *tree, key_t key);
 *
 * Return the in-order predecessor of the key if one exists in the tree.
 *
 *
 * node_t *prefix##min(tree_t *tree);
 *
 * Return the minimum node in the tree. Returns NULL if the tree is empty.
 *
 *
 * node_t *prefix##last(tree_t *tree);
 *
 * Return the maximum node of the tree. Returns NULL if the tree is empty.
 */
#define RBT_GEN(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_INIT(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_INSERT(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_REPLACE(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_REMOVE(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_SUCC(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_PRED(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_FIRST(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)	\
RBT_GEN_LAST(attr, prefix, tree_t, node_t, key_t, field, keyf, cmp)

#define RBT_GEN_INIT(attr, prefix, tree_t, node_t, key_t,	 	\
						field, keyf, cmp) 	\
attr void prefix##init(tree_t *tree)					\
{									\
	struct {							\
		char o;							\
		node_t node;						\
	} *ptr = 0;							\
	int alignment = (rbt_link_t)(((char *)&ptr->node.field) - 0);	\
									\
	/* Ensure the alignemnt in arbitrary structs is correct */	\
	assert(!(alignment & 1) && "bad alignment");			\
	if (alignment & 1)						\
		abort();						\
									\
	tree->root = RBT_NIL;						\
	tree->mod_count = 0;						\
}

#define RBT_GEN_INSERT(attr, prefix, tree_t, node_t, key_t, 		\
						field, keyf, cmp) 	\
attr int prefix##insert(tree_t *tree, node_t *user_node)		\
{									\
	struct rbt_node *node = &user_node->field;			\
	rbt_link_t *link;						\
	int dir;							\
									\
	/* Ensure the alignment is correct */				\
	assert(!((rbt_link_t)node & 1) && "bad alignment");		\
	if ((rbt_link_t)node & 1)					\
		abort();						\
									\
	/* Find an insertion point */					\
	link = &tree->root;						\
	while (*link) {							\
		dir = cmp(keyf(user_node), 				\
			keyf(RBT_USERNODE(node_t, field, *link)));	\
		if (!dir) {						\
			/* Duplicate node */				\
			tree->root = RBT_BLACK_LINK(RBT_ROOT(tree));	\
			tree->mod_count++;				\
			return 1;					\
		}							\
		link = rbt_insert_descend(link, dir);			\
	}								\
									\
	/* Link a new red node */					\
	node->left = node->right = RBT_NIL;				\
	*link = RBT_RED_LINK(node);					\
	tree->root = RBT_BLACK_LINK(RBT_ROOT(tree));			\
	tree->mod_count++;						\
	return 0;							\
}

#define RBT_GEN_REPLACE(attr, prefix, tree_t, node_t, key_t, 		\
						field, keyf, cmp)	\
attr node_t *prefix##replace(tree_t *tree, node_t *user_node)		\
{									\
	struct rbt_node *node = &user_node->field;			\
	rbt_link_t *link;						\
	struct rbt_node *existing;					\
	int dir;							\
									\
	/* Ensure the alignment is correct */				\
	assert(((rbt_link_t)node & 1) == 0 && "bad alignment");		\
	if ((rbt_link_t)node & 1)					\
		abort();						\
									\
	/* Find an insertion point */					\
	link = &tree->root;						\
	while (*link) {							\
		dir = cmp(keyf(user_node), 				\
			keyf(RBT_USERNODE(node_t, field, *link)));	\
		if (!dir)						\
			break;						\
		link = rbt_insert_descend(link, dir);			\
	}								\
									\
	existing = RBT_NODE(*link);					\
	if (!existing) {						\
		/* Link a new red node */				\
		node->left = node->right = RBT_NIL;			\
		*link = RBT_RED_LINK(node);				\
		tree->root = RBT_BLACK_LINK(RBT_ROOT(tree));		\
		tree->mod_count++;					\
		return NULL;						\
	}								\
									\
	/* If the node exists in the tree, then ignore the request */	\
	if (existing == node) {						\
		tree->root = RBT_BLACK_LINK(RBT_ROOT(tree));		\
		tree->mod_count++;					\
		return NULL;						\
	}								\
									\
	/* Otherwise, replace the node and return the old one */	\
	node->left = existing->left;					\
	node->right = existing->right;					\
	*link = RBT_LINK(node, RBT_RED(*link));				\
	tree->root = RBT_BLACK_LINK(RBT_ROOT(tree));			\
	tree->mod_count++;						\
	return RBT_USER(node_t, field, existing);			\
}

#define RBT_GEN_REMOVE(attr, prefix, tree_t, node_t, key_t,		\
						field, keyf, cmp)	\
attr node_t *prefix##remove(tree_t *tree, key_t key)			\
{									\
	rbt_link_t *link, *succ_link, *next_link;			\
	struct rbt_node *node, *succ;					\
	int dir;							\
									\
	/* Check for an empty tree. */					\
	node = RBT_ROOT(tree);						\
	if (!node)							\
		return NULL;						\
									\
	dir = cmp(key, keyf(RBT_USER(node_t, field, node)));		\
	if (!node->left && !node->right) {				\
		/* Degenerate case when the tree is a singleton. */	\
		if (dir)						\
			return NULL;					\
		tree->root = RBT_NIL;					\
		tree->mod_count++;					\
		return RBT_USER(node_t, field, node);			\
	}								\
									\
	/*								\
	 * Ensure that either the root or it's children have at least	\
	 * one 3-node or 4-node.					\
	 */								\
	if (!RBT_RED(node->left) && !RBT_RED(node->right) &&		\
			!RBT_RED(RBT_LEFT(node)->left) &&		\
			!RBT_RED(RBT_LEFT(node)->right) &&		\
			!RBT_RED(RBT_RIGHT(node)->left) &&		\
			!RBT_RED(RBT_RIGHT(node)->right)) {		\
		node->left = RBT_RED_LINK(RBT_LEFT(node));		\
		node->right = RBT_RED_LINK(RBT_RIGHT(node));		\
	}								\
									\
	/*								\
	 * Find the node in the tree ensuring we are never left in a	\
	 * 2-node.							\
	 */								\
	next_link = &tree->root;					\
	do {								\
		link = next_link;					\
		dir = cmp(key,						\
			keyf(RBT_USERNODE(node_t, field, *link)));	\
		next_link = rbt_remove_descend(link, dir);		\
	} while (next_link);						\
									\
	/* If the node is node is a leaf, remove it. */			\
	node = RBT_NODE(*link);						\
	if (!node->right) {						\
		*link = RBT_BLACK_LINK(RBT_NODE(node->left));		\
	} else if (!node->left) {					\
		*link = RBT_BLACK_LINK(RBT_NODE(node->right));		\
	} else {							\
		/* Otherwise, node is internal. Find the successor. */	\
		next_link = rbt_remove_descend(link, 1);		\
		do {							\
			succ_link = next_link;				\
			next_link = rbt_remove_descend(succ_link, -1);	\
		} while (next_link);					\
									\
		/* Replace node with the successor. */			\
		succ = RBT_NODE(*succ_link);				\
		*succ_link = RBT_BLACK_LINK(RBT_NODE(succ->right));	\
		succ->left = node->left;				\
		succ->right = node->right;				\
		*link = RBT_LINK(succ, RBT_RED(*link));			\
	}								\
									\
	tree->root = RBT_BLACK_LINK(RBT_ROOT(tree));			\
	tree->mod_count++;						\
	return RBT_USER(node_t, field, node);				\
}

#define RBT_GEN_FIND(attr, prefix, tree_t, node_t, key_t,		\
						field, keyf, cmp)	\
attr node_t *prefix##find(tree_t *tree, key_t key)			\
{									\
	struct rbt_node *node = RBT_ROOT(tree);				\
	int dir;							\
	while (node) {							\
		dir = cmp(key, keyf(RBT_USER(node_t, field, node)));	\
		if (dir > 0) {						\
			node = RBT_RIGHT(node);				\
		} else if (dir < 0) {					\
			node = RBT_LEFT(node);				\
		} else {						\
			break;						\
		}							\
	}								\
									\
	if (!node)							\
		return NULL;						\
									\
	return RBT_USER(node_t, field, node);				\
}

#define RBT_GEN_SUCC(attr, prefix, tree_t, node_t, key_t, 		\
						field, keyf, cmp)	\
attr node_t *prefix##succ(tree_t *tree, key_t key)			\
{									\
	struct rbt_node *node = RBT_ROOT(tree), *next = NULL;		\
	int dir;							\
									\
	while (node) {							\
		dir = cmp(key, keyf(RBT_USER(node_t, field, node)));	\
		if (dir > 0) {						\
			node = RBT_RIGHT(node);				\
		} else if (dir < 0) {					\
			next = node;					\
			node = RBT_LEFT(node);				\
		} else {						\
			break;						\
		}							\
	}								\
									\
	if (node && node->right) {					\
		next = RBT_RIGHT(node);					\
		while (next->left)					\
			next = RBT_LEFT(next);				\
	}								\
									\
	if (!next)							\
		return NULL;						\
									\
	return RBT_USER(node_t, field, next);				\
}

#define RBT_GEN_PRED(attr, prefix, tree_t, node_t, key_t, 		\
						field, keyf, cmp)	\
attr node_t *prefix##pred(tree_t *tree, key_t key)			\
{									\
	struct rbt_node *node = RBT_ROOT(tree), *prev = NULL;		\
	int dir;							\
									\
	while (node) {							\
		dir = cmp(key, keyf(RBT_USER(node_t, field, node)));	\
		if (dir > 0) {						\
			prev = node;					\
			node = RBT_RIGHT(node);				\
		} else if (dir < 0) {					\
			node = RBT_LEFT(node);				\
		} else {						\
			break;						\
		}							\
	}								\
									\
	if (node && node->left) {					\
		prev = RBT_LEFT(node);					\
		while (prev->right)					\
			prev = RBT_RIGHT(prev);				\
	}								\
									\
	if (!prev)							\
		return NULL;						\
									\
	return RBT_USER(node_t, field, prev);				\
}

#define RBT_GEN_FIRST(attr, prefix, tree_t, node_t, key_t,		\
						field, keyf, cmp)	\
attr node_t *prefix##first(tree_t *tree)				\
{									\
	struct rbt_node *node = RBT_ROOT(tree);				\
	while (node && node->left)					\
		node = RBT_LEFT(node);					\
	if (!node)							\
		return NULL;						\
	return RBT_USER(node_t, field, node);				\
}

#define RBT_GEN_LAST(attr, prefix, tree_t, node_t, key_t, 		\
						field, keyf, cmp)	\
attr node_t *prefix##last(tree_t *tree)					\
{									\
	struct rbt_node *node = RBT_ROOT(tree);				\
	while (node && node->right)					\
		node = RBT_RIGHT(node);					\
	if (!node)							\
		return NULL;						\
	return RBT_USER(node_t, field, node);				\
}

#endif
