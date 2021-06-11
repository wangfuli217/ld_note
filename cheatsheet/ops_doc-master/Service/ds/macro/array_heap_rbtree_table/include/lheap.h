/*
 * lheap.h - Linked leftist heap
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

#ifndef LHEAP_H
#define LHEAP_H

/*
 * Leftist heaps are skewed to the left so that the shortest path to a nil
 * link is the right path. A simple inductive argument can show that in
 * the worst case, number of steps to reach the nil link is O(lg(n)).
 * The s-value of each node is defined as the number of nodes, including
 * the node itself on the shortest path to a nil link. A valid leftist heap
 * has the minimum s-value in the right subheap. In the worst case, the
 * heap is well-balanced, in which case, the s-value is the same for every
 * path.
 */

#include <assert.h>
#include <stdlib.h>

/* Leftist heap entry field */
#define LHEAP_ENTRY(node_t)						\
struct {								\
	node_t *parent, *left, *right;					\
	int s;								\
}

/* Leftist heap root */
#define LHEAP_ROOT(name, node_t)					\
struct name {								\
	node_t *root;							\
}

/* Get the minimum or maximum without removing it */
#define LHEAP_PEEK(heap)		((heap)->root)
/* Check if the heap is empty */
#define LHEAP_EMPTY(heap)		(!LHEAP_PEEK(heap))

/* Node accessors (internal) */
#define LHEAP_LEFT(field, node)		((node)->field.left)
#define LHEAP_RIGHT(field, node)	((node)->field.right)
#define LHEAP_PARENT(field, node)	((node)->field.parent)
#define LHEAP_S(field, node)		(!(node) ? 0 : (node)->field.s)

/* Heap property predicates */
#define LHEAP_ORDER_MIN(cmp_parent_child)	(cmp_parent_child <= 0)
#define LHEAP_ORDER_MAX(cmp_parent_child)	(cmp_parent_child >= 0)

/* Generate leftist heap prototypes */
#define LHEAP_PROTO(attr, prefix, heap_t, node_t)			\
attr void prefix##init_heap(heap_t *heap);				\
attr void prefix##init_node(node_t *node);				\
attr void prefix##merge(heap_t *heap, heap_t *other);			\
attr void prefix##push(heap_t *heap, node_t *node);			\
attr void prefix##remove(heap_t *heap, node_t *node);			\
attr node_t *prefix##pop(heap_t *heap);

/*
 * Generate the leftist heap implementation.
 *
 * Parameters:
 *  - attr: function attributes
 *  - prefix: function identifier prefix
 *  - heap_t: heap type as defined by LHEAP_ROOT
 *  - node_t: node type
 *  - field: the LHEAP_NODE element of node_t
 *  - cmp: the compare function
 *  - order: either LHEAP_ORDER_MIN or LHEAP_ORDER_MAX
 *
 * The compare function has the signature:
 *
 * int cmp(node_t *left, node_t *right);
 *
 * And satisfies:
 *  - cmp(left, right) = 1  if left `>` right
 *  - cmp(left, right) = -1 if left `<` right
 *  - cmp(left, right) = 0  if left `=` right
 *
 * All functions operate in O(lg(n)) time.
 *
 *
 * void prefix##init_heap(heap_t *heap);
 *
 * Initialize the heap.
 *
 *
 * void prefix##init_node(node_t *node);
 *
 * Initialize a node.
 *
 *
 * void prefix##merge(heap_t *heap, heap_t *other);
 *
 * Merge other into heap.
 *
 *
 * void prefix##push(heap_t *heap, node_t *node);
 *
 * Insert a node into heap.
 *
 *
 * void prefix##remove(heap_t *heap, node_t *node);
 *
 * Remove node from heap.
 *
 *
 * node_t *prefix##pop(heap_t *heap);
 *
 * Remove the minimum or maximum element of heap.
 */

#define LHEAP_GEN(attr, prefix, heap_t, node_t, field, cmp, order)	\
attr void prefix##init_heap(heap_t *heap)				\
{									\
	heap->root = NULL;						\
}									\
									\
attr void prefix##init_node(node_t *node)				\
{									\
	node->field.s = 0;						\
	LHEAP_PARENT(field, node) = NULL;				\
	LHEAP_LEFT(field, node) = NULL;					\
	LHEAP_RIGHT(field, node) = NULL;				\
}									\
									\
attr void prefix##merge(heap_t *heap, heap_t *other_heap)		\
{									\
	node_t *node, *other, *parent, *temp;				\
									\
	/* other is the node we are merging */				\
	other = other_heap->root;					\
	other_heap->root = NULL;					\
	if (!other)							\
		return;							\
									\
	/* node is in the heap we are merging into */			\
	node = heap->root;						\
	if (!node) {							\
		heap->root = other;					\
		return;							\
	}								\
									\
	/* Walk down the shortest path to find an insertion point */	\
	while (1) {							\
		/* Check if node could be the parent of other */	\
		if (order(cmp(node, other))) {				\
			if (!LHEAP_RIGHT(field, node)) {		\
				/* Found an insertion point */		\
				LHEAP_RIGHT(field, node) = other;	\
				LHEAP_PARENT(field, other) = node;	\
				break;					\
			}						\
									\
			/* Continue down the short path */		\
			node = LHEAP_RIGHT(field, node);		\
			continue;					\
		}							\
									\
		/*							\
		 * Swap the node and other subheaps to maintain the	\
		 * heap property					\
		 */							\
		parent = LHEAP_PARENT(field, node);			\
		if (parent) {						\
			LHEAP_RIGHT(field, parent) = other;		\
			LHEAP_PARENT(field, other) = parent;		\
			LHEAP_PARENT(field, node) = NULL;		\
		} else {						\
			heap->root = other;				\
		}							\
		temp = node;						\
		node = other;						\
		other = temp;						\
	}								\
									\
	/* Walk up to the root repairing the nodeist property */	\
	do {								\
		if (LHEAP_S(field, LHEAP_LEFT(field, node)) <		\
			     LHEAP_S(field, LHEAP_RIGHT(field, node))) {\
			temp = LHEAP_LEFT(field, node);			\
			LHEAP_LEFT(field, node) =			\
					LHEAP_RIGHT(field, node);	\
			LHEAP_RIGHT(field, node) = temp;		\
		}							\
									\
		node->field.s = 1 +					\
			LHEAP_S(field, LHEAP_RIGHT(field, node));	\
	} while ((node = LHEAP_PARENT(field, node)));			\
}									\
									\
attr void prefix##push(heap_t *heap, node_t *node)			\
{									\
	heap_t other;							\
	assert(!LHEAP_S(field, node) && "uninitalized?");		\
	if (LHEAP_S(field, node))					\
		abort();						\
	LHEAP_PARENT(field, node) = NULL;				\
	LHEAP_LEFT(field, node) = NULL;					\
	LHEAP_RIGHT(field, node) = NULL;				\
	node->field.s = 1;						\
	other.root = node;						\
	prefix##merge(heap, &other);					\
}									\
									\
attr void prefix##remove(heap_t *heap, node_t *node)			\
{									\
	node_t *parent, *temp;						\
	heap_t left, right;						\
	int s;								\
									\
	/* If s is 0, then node is not in the heap */			\
	if (!LHEAP_S(field, node))					\
		return;							\
									\
	/* Merge the left and right subheaps */				\
	if ((left.root = LHEAP_LEFT(field, node)))			\
		LHEAP_PARENT(field, left.root) = NULL;			\
	if ((right.root = LHEAP_RIGHT(field, node)))			\
		LHEAP_PARENT(field, right.root) = NULL;			\
	prefix##merge(&left, &right);					\
									\
	/* Remove node from the heap */					\
	parent = LHEAP_PARENT(field, node);				\
	prefix##init_node(node);					\
	if (!parent) {							\
		heap->root = left.root;					\
		return;							\
	}								\
									\
	/* 								\
	 * Walk up the tree to correct the leftist property		\
	 * In the worst case, this path becomes the shortest,		\
	 * which requires O(lg(n)) steps to update each node		\
	 * on the path.							\
	 */								\
	do {								\
		if (LHEAP_S(field, LHEAP_LEFT(field, parent)) <		\
			   LHEAP_S(field, LHEAP_RIGHT(field, parent))) {\
			temp = LHEAP_LEFT(field, parent);		\
			LHEAP_LEFT(field, parent) =			\
					LHEAP_RIGHT(field, parent);	\
			LHEAP_RIGHT(field, parent) = temp;		\
		}							\
									\
		/* Update the s value */				\
		s = 1 + LHEAP_S(field, LHEAP_RIGHT(field, parent));	\
		if (LHEAP_S(field, parent) == s)			\
			break;						\
		parent->field.s = s;					\
	} while((parent = LHEAP_PARENT(field, parent)));		\
}									\
									\
attr node_t *prefix##pop(heap_t *heap)					\
{									\
	node_t *node = heap->root;					\
	if (!node)							\
		return NULL;						\
	prefix##remove(heap, node);					\
	return node;							\
}

#endif
