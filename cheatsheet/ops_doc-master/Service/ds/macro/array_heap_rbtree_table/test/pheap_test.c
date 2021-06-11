#include <stdlib.h>
#include <stdio.h>

#include "pheap.h"

struct node {
	PHEAP_ENTRY(struct node) pheap_node;
	int data;
};

PHEAP_ROOT(heap, struct node);

int cmp(struct node *left, struct node *right)
{
	if (left->data > right->data)
		return 1;
	if (left->data < right->data)
		return -1;
	return 0;
}

PHEAP_GEN(static, pheap_, struct heap, struct node, pheap_node,
							cmp, PHEAP_ORDER_MIN)

void show_node(struct node *node, int indent)
{
	struct node *child;
	if (!node)
		return;
	for (int i = 0; i < indent; i++)
		printf("    ");
	printf("%d\n", node->data);
	child = node->pheap_node.sub;
	while (child) {
		show_node(child, indent + 1);
		child = child->pheap_node.next;
	}
}

void show_heap(struct heap *heap)
{
	show_node(heap->root, 0);
}

int check_link_node(struct node *node)
{
	struct node *child, **link;
	if (!node)
		return 1;
	link = &node->pheap_node.sub;
	while ((child = *link)) {
		if (child->pheap_node.link != link)
			return 0;
		if (!check_link_node(child))
			return 0;
		link = &child->pheap_node.next;
	}
	return 1;
}

int check_link(struct heap *heap)
{
	if (!heap->root)
		return 1;
	if (heap->root->pheap_node.link != &heap->root)
		return 0;
	return check_link_node(heap->root);
}

int check_order(struct node *node)
{
	struct node *child;
	if (!node)
		return 1;
	child = node->pheap_node.sub;
	while (child) {
		if (cmp(node, child) > 0)
			return 0;
		if (!check_order(child))
			return 0;
		child = child->pheap_node.next;
	}
	return 1;
}

int max_node_order(struct node *node)
{
	struct node *child;
	int count = 0, child_count = 0, max_child = 1;
	if (!node)
		return 0;
	child = node->pheap_node.sub;
	while (child) {
		child_count = max_node_order(child);
		if (child_count > max_child)
			max_child = child_count;
		count++;
		child = child->pheap_node.next;
	}
	if (count > max_child)
		return count;
	return max_child;
}

int max_order(struct heap *heap)
{
	return max_node_order(heap->root);
}

void assert_tests(struct heap *heap)
{
	assert(check_link(heap));
	assert(check_order(heap->root));
}

void show_tests(struct heap *heap)
{
	printf("link: %d\n", check_link(heap));
	printf("order: %d\n", check_order(heap->root));
	printf("arity: %d\n", max_order(heap));
}

int main(int argc, char **argv)
{
	int size = 10;
	struct heap heap;
	struct node *node;

	if (argc >= 2)
		size = atoi(argv[1]);

	pheap_init_heap(&heap);
	for (int i = size - 1; i >= 0; i--) {
		node = malloc(sizeof(*node));
		if (!node)
			return 1;
		pheap_init_node(node);
		node->data = i;
#if !NO_DISPLAY
		printf("====\npush: %d\n", node->data);
#endif
		pheap_push(&heap, node);
#if !NO_DISPLAY
		show_heap(&heap);
		show_tests(&heap);
		assert_tests(&heap);
#endif
	}

	for (int i = 0; i < size; i++) {
		node = pheap_pop(&heap);
#if !NO_DISPLAY
		printf("====\npop: %d\n", node->data);
		show_heap(&heap);
		show_tests(&heap);
		assert_tests(&heap);
#endif
		free(node);
	}

	return 0;
}
