#include <stdio.h>

#include "lheap.h"

typedef struct lnode node_t;

struct lnode {
	LHEAP_ENTRY(node_t) node;
	int data;
};

typedef LHEAP_ROOT(, node_t) heap_t;

static inline int cmp(struct lnode *left, struct lnode *right)
{
	if (left->data > right->data)
		return 1;
	if (left->data < right->data)
		return -1;
	return 0;
}

LHEAP_GEN(static inline, lheap_, heap_t, node_t, node, cmp, LHEAP_ORDER_MIN)

void show_node(node_t *node, int indent)
{
	if (!node)
		return;
	show_node(node->node.right, indent + 1);
	for (int i = 0; i < indent; i++)
		printf("    ");
	printf("%d\n", node->data);
	show_node(node->node.left, indent + 1);
}

void show_heap(heap_t *heap)
{
	show_node(LHEAP_PEEK(heap), 0);
}

int count(node_t *heap)
{
	if (!heap)
		return 0;
	return 1 + count(heap->node.left) + count(heap->node.right);
}

int height(node_t *heap)
{
	int left, right;
	if (!heap)
		return 0;
	left = height(heap->node.left);
	right = height(heap->node.right);
	if (left < right)
		return 1 + right;
	return 1 + left;
}

int nil_height(node_t *heap)
{
	int left, right;
	if (!heap)
		return 0;
	left = nil_height(heap->node.left);
	right = nil_height(heap->node.right);
	if (left < right)
		return 1 + left;
	return 1 + right;
}

int check_leftist(node_t *heap)
{
	int left = 0, right = 0;

	if (!heap)
		return 1;

	if (heap->node.left)
		left = heap->node.left->node.s;

	if (heap->node.right)
		right = heap->node.right->node.s;

	if (left < right)
		return 0;

	if (right + 1 != heap->node.s)
		return 0;

	if (!check_leftist(heap->node.left))
		return 0;

	if (!check_leftist(heap->node.right))
		return 0;

	return 1;
}

int check_order(node_t *heap)
{
	if (!heap)
		return 1;
	if (heap->node.left && heap->data > heap->node.left->data)
		return 0;
	if (heap->node.right && heap->data > heap->node.right->data)
		return 0;
	if (!check_order(heap->node.left))
		return 0;
	if (!check_order(heap->node.right))
		return 0;
	return 1;
}

int check_parents2(node_t *heap)
{
	if (!heap)
		return 1;
	if (heap->node.left && heap->node.left->node.parent != heap)
		return 0;
	if (heap->node.right && heap->node.right->node.parent != heap)
		return 0;
	if (!check_parents2(heap->node.left))
		return 0;
	if (!check_parents2(heap->node.right))
		return 0;
	return 1;
}

int check_parents(heap_t *heap)
{
	if (!heap->root)
		return 1;
	return heap->root->node.parent == NULL && check_parents2(heap->root);
}

void assert_tests(heap_t *heap)
{
	assert(check_parents(heap));
	assert(check_leftist(heap->root));
	assert(check_order(heap->root));
}

void show_tests(heap_t *heap)
{
	printf("count: %d\n", count(heap->root));
	printf("height: %d\n", height(heap->root));
	printf("nil-height: %d\n", nil_height(heap->root));
	printf("check_leftist: %d\n", check_leftist(heap->root));
	printf("check_order: %d\n", check_order(heap->root));
	printf("check_parents: %d\n", check_parents(heap));
}

#ifndef BENCHMARK
#define BENCHMARK 0
#endif

int main(int argc, char **argv)
{
	heap_t heap;
	node_t *node;
	int size = 10, max_nil_height = 0;
	lheap_init_heap(&heap);

	if (argc >= 2)
		size = atoi(argv[1]);

	for (int i = 0; i < size; i++) {
		node = malloc(sizeof(*node));
		if (!node)
			return 1;
		node->data = i;
		lheap_init_node(node);
		lheap_push(&heap, node);
#if !BENCHMARK
		printf("====\ninsert: %d\n", i);
		show_heap(&heap);
		show_tests(&heap);
		assert_tests(&heap);
#endif
		if (heap.root && heap.root->node.s > max_nil_height)
			max_nil_height = heap.root->node.s;
	}

	for (int i = 0; i < size; i++) {
		node = lheap_pop(&heap);
		if (!node)
			break;
#if !BENCHMARK
		printf("====\npop: %d\n", node->data);
#endif
		assert(node->data == i);
		free(node);
#if !BENCHMARK
		show_heap(&heap);
		show_tests(&heap);
		assert_tests(&heap);
#endif
		if (heap.root && heap.root->node.s > max_nil_height)
			max_nil_height = heap.root->node.s;
	}

	printf("max:%d\n", max_nil_height);

	return 0;
}
