/*
 * pheap.h - Pairing heap
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

#ifndef PHEAP_H
#define PHEAP_H

#include <stdlib.h>
#include <assert.h>

#define PHEAP_ENTRY(node_t)						\
struct {								\
	node_t **link, *next, *sub;					\
}

#define PHEAP_ROOT(name, node_t)					\
struct name {								\
	node_t *root;							\
}

#define PHEAP_PEEK(heap)		do { ((heap)->root) } while(0)
#define PHEAP_EMPTY(heap)		(!(heap)->root)

#define PHEAP_INITALIZER		{NULL}
#define PHEAP_INIT(heap)		((heap)->root = NULL)

#define PHEAP_NODE_INITALIZER		{NULL, NULL, NULL}
#define PHEAP_NODE_INIT(field, node)					\
	do {								\
		(node)->field.link = NULL;				\
		(node)->field.next = NULL;				\
		(node)->field.sub = NULL;				\
	} while (0)							\

/* Heap property predicates */
#define PHEAP_ORDER_MIN(cmp_parent_child)	(cmp_parent_child <= 0)
#define PHEAP_ORDER_MAX(cmp_parent_child)	(cmp_parent_child >= 0)

#define PHEAP_PROTO(attr, prefix, heap_t, node_t)			\
attr void prefix##init_heap(heap_t *heap);				\
attr void prefix##init_node(node_t *node);				\
attr void prefix##merge(heap_t *heap, heap_t *other);			\
attr void prefix##remove(node_t *node);					\
attr void prefix##push(heap_t *heap, node_t *node);			\
attr node_t *prefix##pop(heap_t *heap);

/**/
#define PHEAP_GEN(attr, prefix, heap_t, node_t, field, cmp, order)	\
attr void prefix##init_heap(heap_t *heap)				\
{									\
	PHEAP_INIT(heap);						\
}									\
									\
attr void prefix##init_node(node_t *node)				\
{									\
	PHEAP_NODE_INIT(field, node);					\
}									\
									\
attr void prefix##merge(heap_t *heap, heap_t *other_heap)		\
{									\
	node_t *node = heap->root, *other = other_heap->root;		\
									\
	/* Merging from an empty heap */				\
	if (!other)							\
		return;							\
									\
	/* Unlink other from its heap */				\
	assert(other->field.link == &other_heap->root);			\
	*other->field.link = other->field.next;				\
	if (*other->field.link)						\
		(*other->field.link)->field.link = other->field.link;	\
	other->field.link = NULL;					\
	other->field.next = NULL;					\
									\
	/* Merging into an empty heap */				\
	if (!node) {							\
		other->field.link = &heap->root;			\
		heap->root = other;					\
		return;							\
	}								\
									\
	assert(node->field.link == &heap->root);			\
									\
	/* Link other into the heap under node */			\
	if (order(cmp(node, other))) {					\
		other->field.next = node->field.sub;			\
		if (other->field.next)					\
			other->field.next->field.link =			\
						&other->field.next;	\
		other->field.link = &node->field.sub;			\
		node->field.sub = other;				\
		return;							\
	}								\
									\
	/* Other becomes the new root */				\
	*node->field.link = other;					\
	other->field.link = node->field.link;				\
	other->field.next = node->field.next;				\
	if (other->field.next)						\
		other->field.next->field.link = &other->field.next;	\
	node->field.next = other->field.sub;				\
	if (node->field.next)						\
		node->field.next->field.link = &node->field.next;	\
	node->field.link = &other->field.sub;				\
	other->field.sub = node;					\
}									\
									\
attr void prefix##remove(node_t *node)					\
{									\
	node_t **link, **sub, **pair;					\
									\
	/* Check that node is in a heap */				\
	if (!node)							\
		return;							\
									\
	link = node->field.link;					\
	if (!link)							\
		return;							\
									\
	/* Promote the sibling */					\
	*link = node->field.next;					\
	if (*link)							\
		(*link)->field.link = link;				\
	node->field.link = NULL;					\
	node->field.next = NULL;					\
									\
	/* Pairwise merge the subheaps */				\
	sub = &node->field.sub;						\
	while (*sub) {							\
		pair = &(*sub)->field.next;				\
		prefix##merge((heap_t *)sub, (heap_t *)pair);		\
		prefix##merge((heap_t *)link, (heap_t *)sub);		\
	}								\
}									\
									\
attr void prefix##push(heap_t *heap, node_t *node)			\
{									\
	heap_t other;							\
	assert(!heap->root || !heap->root->field.next);			\
	assert(!node->field.link && !node->field.next 			\
						&& !node->field.sub);	\
	if (node->field.link || node->field.next || node->field.sub)	\
		abort();						\
	other.root = node;						\
	node->field.link = &other.root;					\
	prefix##merge(heap, &other);					\
}									\
									\
attr node_t *prefix##pop(heap_t *heap)					\
{									\
	node_t *node = heap->root;					\
	assert(!heap->root || !heap->root->field.next);			\
	prefix##remove(node);						\
	return node;							\
}

#endif
