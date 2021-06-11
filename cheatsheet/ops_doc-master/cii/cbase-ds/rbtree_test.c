/**
 * File: rbtree_test.c
 * Author: ZhuXindi
 * Date: 2014-04-22
 */

#include <rbtree.h>
#include <log.h>
#include <systime.h>
#include <stdio.h>
#include <stdlib.h>

struct my_node {
	struct rb_node node;
	unsigned long key;
};

void print_tree(const struct rb_root *tree)
{
	struct rb_node *n;

	for (n = rb_first(tree); n; n = rb_next(n))
		log_info(">>>%p left=%p right=%p key=%lu", n, n->rb_left, n->rb_right,
			 rb_entry(n, struct my_node, node)->key);
}

struct my_node *search_node(const struct rb_root *tree, unsigned long key)
{
	struct rb_node *n = tree->rb_node;
	struct my_node *node;

	while (n) {
		node = rb_entry(n, struct my_node, node);
		if (key < node->key)
			n = n->rb_left;
		else if (key > node->key)
			n = n->rb_right;
		else
			return node;
	}
	return NULL;
}

void insert_node(struct rb_root *tree, struct my_node *node)
{
	struct rb_node **p = &(tree->rb_node);
	struct rb_node *parent = NULL;
	struct my_node *tmp;

	while (*p) {
		parent = *p;
		tmp = rb_entry(parent, struct my_node, node);

		if (node->key < tmp->key)
			p = &((*p)->rb_left);
		else
			p = &((*p)->rb_right);
	}

	rb_link_node(&node->node, parent, p);
	rb_insert_color(&node->node, tree);
}

struct my_node *min_node(const struct rb_root *tree)
{
	struct rb_node *n = rb_min_node(tree);
	return n ? rb_entry(n, struct my_node, node): NULL;
}

int main()
{
	struct rb_root tree = RB_ROOT;
	struct my_node nodes[10];
	struct my_node *p;
	int i;
	unsigned long key;

	update_pid();
	update_sys_time();
	set_log_level(LOG_DEBUG);

	for (i = 0; i < 10; i++) {
		nodes[i].key = rand() % 10;
		log_info("add %p key=%lu", &nodes[i], nodes[i].key);
		insert_node(&tree, &nodes[i]);
		print_tree(&tree);
	}

	p = min_node(&tree);
	log_info("min %p key=%lu", p, p->key);

	key = 1;
	p = search_node(&tree, key);
	if (p)
		log_info("found %p key=%lu", p, key);
	else
		log_info("not found key=%lu", key);

	log_info("del %p key=%lu", &nodes[2], nodes[2].key);
	rb_erase(&nodes[2].node, &tree);
	print_tree(&tree);

	log_info("del %p key=%lu", &nodes[5], nodes[5].key);
	rb_erase(&nodes[5].node, &tree);
	print_tree(&tree);

	log_info("del %p key=%lu", &nodes[9], nodes[9].key);
	rb_erase(&nodes[9].node, &tree);
	print_tree(&tree);

	p = min_node(&tree);
	log_info("min %p key=%lu", p, p->key);

	p = search_node(&tree, key);
	if (p)
		log_info("found %p key=%lu", p, key);
	else
		log_info("not found key=%lu", key);

	return 0;
}
