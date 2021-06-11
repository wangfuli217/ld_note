#include "rbtree_augmented.h"
#include "rbtree.h"
#include "types.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>


#define NODES       100
#define PERF_LOOPS  100000
#define CHECK_LOOPS 100
static int g_error_count = 0;
struct test_node {
	unsigned int key;
	struct rb_node rb;

	/* following fields used for testing augmented rbtree functionality */
	unsigned int val;
	unsigned int augmented;
};

static struct rb_root root = RB_ROOT;
static struct test_node nodes[NODES];


static void insert(struct test_node *node, struct rb_root *root)
{
	struct rb_node **new = &root->rb_node, *parent = NULL;
	unsigned int key = node->key;

	while (*new) {
		parent = *new;
		if (key < rb_entry(parent, struct test_node, rb)->key)
			new = &parent->rb_left;
		else
			new = &parent->rb_right;
	}

	rb_link_node(&node->rb, parent, new);
	rb_insert_color(&node->rb, root);
}

static inline void erase(struct test_node *node, struct rb_root *root)
{
	rb_erase(&node->rb, root);
}

static inline unsigned int augment_recompute(struct test_node *node)
{
	unsigned int max = node->val, child_augmented;
	if (node->rb.rb_left) {
		child_augmented = rb_entry(node->rb.rb_left, struct test_node, rb)->augmented;
		if (max < child_augmented)
			max = child_augmented;
	}
	if (node->rb.rb_right) {
		child_augmented = rb_entry(node->rb.rb_right, struct test_node,
					   rb)->augmented;
		if (max < child_augmented)
			max = child_augmented;
	}
	return max;
}

RB_DECLARE_CALLBACKS(static, augment_callbacks, struct test_node, rb,
		     unsigned int, augmented, augment_recompute)

static void insert_augmented(struct test_node *node, struct rb_root *root)
{
	struct rb_node **new = &root->rb_node, *rb_parent = NULL;
	unsigned int key = node->key;
	unsigned int val = node->val;
	struct test_node *parent;

	while (*new) {
		rb_parent = *new;
		parent = rb_entry(rb_parent, struct test_node, rb);
		if (parent->augmented < val)
			parent->augmented = val;
		if (key < parent->key)
			new = &parent->rb.rb_left;
		else
			new = &parent->rb.rb_right;
	}

	node->augmented = val;
	rb_link_node(&node->rb, rb_parent, new);
	rb_insert_augmented(&node->rb, root, &augment_callbacks);
}

static void erase_augmented(struct test_node *node, struct rb_root *root)
{
	rb_erase_augmented(&node->rb, root, &augment_callbacks);
}

static void init(void)
{
	int i;
	for (i = 0; i < NODES; i++) {
		nodes[i].key = random();
		nodes[i].val = random();
	}
}

static int is_red(struct rb_node *rb)
{
	return !(rb->__rb_parent_color & 1);
}

static int black_path_count(struct rb_node *rb)
{
	int count;
	for (count = 0; rb; rb = rb_parent(rb))
		count += !is_red(rb);
	return count;
}

static void check_postorder_foreach(int nr_nodes)
{
	struct test_node *cur, *n;
	int count = 0;
	rbtree_postorder_for_each_entry_safe(cur, n, &root, rb)
		count++;
	if(count != nr_nodes){
		g_error_count++;
		printf("rbtree nodes number error\n");
	}

}

static void check_postorder(int nr_nodes)
{
	struct rb_node *rb;
	int count = 0;
	for (rb = rb_first_postorder(&root); rb; rb = rb_next_postorder(rb))
		count++;
	if(count != nr_nodes){
		g_error_count++;
		printf("rbtree nodes number error\n");
	}
	
}

static void check(int nr_nodes)
{
	struct rb_node *rb;
	int count = 0, blacks = 0;
	unsigned int prev_key = 0;

	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
		struct test_node *node = rb_entry(rb, struct test_node, rb);
		if(node->key < prev_key){
			g_error_count++;
			printf("rbtree wrong key\n");
		}
		if(is_red(rb) && (!rb_parent(rb) || is_red(rb_parent(rb)))){
			g_error_count++;
			printf("rbtree wrong color\n");
		}
		if (!count)
			blacks = black_path_count(rb);
		else if(((!rb->rb_left || !rb->rb_right) && blacks != black_path_count(rb))){
			g_error_count++;
			printf("rbtree path error");
		}
			
		prev_key = node->key;
		count++;
	}
	if(count != nr_nodes){
		g_error_count++;
		printf("rbtree nodes number error\n");
	}
	if(count < (1 << black_path_count(rb_last(&root))) - 1){
		g_error_count++;
		printf("not a blace tree\n");
	}
	check_postorder(nr_nodes);
	check_postorder_foreach(nr_nodes);
}

static void check_augmented(int nr_nodes)
{
	struct rb_node *rb;

	check(nr_nodes);
	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
		struct test_node *node = rb_entry(rb, struct test_node, rb);
		if(node->augmented != augment_recompute(node))
			printf("augmented data error\n");
	}
}

int  main(int argc, char *argv[])
{
	int i, j;

	printf("rbtree testing\n");

	init();


	for (i = 0; i < PERF_LOOPS; i++) {
		for (j = 0; j < NODES; j++)
			insert(nodes + j, &root);
		for (j = 0; j < NODES; j++)
			erase(nodes + j, &root);
	}


	for (i = 0; i < CHECK_LOOPS; i++) {
		init();
		for (j = 0; j < NODES; j++) {
			check(j);
			insert(nodes + j, &root);
		}
		for (j = 0; j < NODES; j++) {
			check(NODES - j);
			erase(nodes + j, &root);
		}
		check(0);
	}
	if(!g_error_count) printf("rbtree test OK!!!!!!\n");
	g_error_count = 0;
	printf("augmented rbtree testing\n");

	init();


	for (i = 0; i < PERF_LOOPS; i++) {
		for (j = 0; j < NODES; j++)
			insert_augmented(nodes + j, &root);
		for (j = 0; j < NODES; j++)
			erase_augmented(nodes + j, &root);
	}


	for (i = 0; i < CHECK_LOOPS; i++) {
		init();
		for (j = 0; j < NODES; j++) {
			check_augmented(j);
			insert_augmented(nodes + j, &root);
		}
		for (j = 0; j < NODES; j++) {
			check_augmented(NODES - j);
			erase_augmented(nodes + j, &root);
		}
		check_augmented(0);
	}
	if(!g_error_count) printf("rbtree augmented test OK!!!!!!\n");

	return 0; 
}
