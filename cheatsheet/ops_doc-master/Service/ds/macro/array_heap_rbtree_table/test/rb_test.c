#include <stdlib.h>
#include <stdio.h>

#include "rbtree.h"

RBT_DEF(rbtree);

struct node {
	struct rbt_node node;
	int data;
};

static inline int cmp(int left, int right)
{
	if (left > right)
		return 1;
	else if (left < right)
		return -1;
	else
		return 0;
}

#define KEYF(node)	((node)->data)

RBT_GEN(static inline, rb_, struct rbtree, struct node, int, node, KEYF, cmp)

static void print_subtree(rbt_link_t tree, int indent)
{
	struct rbt_node *node = RBT_NODE(tree);
	if (!node)
		return;
	print_subtree(node->right, indent + 1);
	for (int i = 0; i < indent; i++)
		printf("    ");
	printf(RBT_RED(tree) ? "(%d)\n" : " %d\n", ((struct node *)node)->data);
	print_subtree(node->left, indent + 1);
}

static int check_order_invariant(rbt_link_t tree)
{
	struct node *node, *left, *right;
	node = RBT_USERNODE(struct node, node, tree);
	if (!node)
		return 1;

	left = RBT_USERNODE(struct node, node, node->node.left);
	if (left && cmp(left->data, node->data) >= 0)
		return 0;

	right = RBT_USERNODE(struct node, node, node->node.right);
	if (right && cmp(node->data, right->data) >= 0)
		return 0;

	return check_order_invariant(node->node.left) &&
		check_order_invariant(node->node.right);
}

static int check_red_invariant(rbt_link_t tree)
{
	struct rbt_node *node;

	node = RBT_NODE(tree);
	if (!node)
		return 1;

	if (RBT_RED(tree) && RBT_RED(node->left))
		return 0;
	if (RBT_RED(tree) && RBT_RED(node->right))
		return 0;

	return check_red_invariant(node->left) &&
		check_red_invariant(node->right);
}

static int black_height(rbt_link_t tree)
{
	struct rbt_node *node = RBT_NODE(tree);
	int left_height, right_height;

	if (!node)
		return 0;

	left_height = black_height(node->left);
	if (left_height < 0)
		return -1;

	right_height = black_height(node->right);
	if (left_height != right_height)
		return -1;

	return left_height + !RBT_RED(tree);
}

static int height(rbt_link_t tree)
{
	struct rbt_node *node;
	int left_height, right_height;

	node = RBT_NODE(tree);
	if (!node)
		return 0;

	left_height = height(node->left);
	right_height = height(node->right);

	if (left_height > right_height)
		return 1 + left_height;

	return 1 + right_height;
}

static int count(rbt_link_t tree)
{
	struct rbt_node *node = RBT_NODE(tree);
	if (!node)
		return 0;
	return 1 + count(node->left) + count(node->right);
}

static void show_tests(struct rbtree *tree)
{
	printf("height: %d\n", height(tree->root));
	printf("black height: %d\n", black_height(tree->root));
	printf("count: %d\n", count(tree->root));
	printf("red ok: %d\n", check_red_invariant(tree->root));
	printf("order ok: %d\n", check_order_invariant(tree->root));
}

static void assert_tests(struct rbtree *tree)
{
	assert(black_height(tree->root) >= 0);
	assert(check_red_invariant(tree->root));
	assert(check_order_invariant(tree->root));
}

#if !NO_MAIN
int main(int argc, char **argv)
{
	struct rbtree tree;
	struct node *node;
	int size = 1000;

	if (argc > 1)
		size = atoi(argv[1]);

	rb_init(&tree);
	assert_tests(&tree);
	for (int i = 0; i < size; i++) {
		node = malloc(sizeof(*node));
		if (!node)
			return 1;
		node->data = i;
		if (rb_insert(&tree, node))
			return 1;
		assert_tests(&tree);
	}

#if !NO_TEST
	show_tests(&tree);
#endif

#if !NO_PRINT
	print_subtree(tree.root, 0);
#endif

	for (int i = 0; i < size; i++) {
		free(rb_remove(&tree, i));

		printf("==========================================================\n");
		printf("remove: %d\n", i);

		show_tests(&tree);
		assert_tests(&tree);

#if !NO_PRINT
		print_subtree(tree.root, 0);
#endif
	}

	return 0;
}
#endif
