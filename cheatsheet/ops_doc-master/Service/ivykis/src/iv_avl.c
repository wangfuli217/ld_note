/*
 * ivykis, an event handling library
 * Copyright (C) 2010 Lennert Buytenhek
 * Dedicated to Marija Kulikova.
 *
 * This library is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version
 * 2.1 as published by the Free Software Foundation.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License version 2.1 for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License version 2.1 along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street - Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include <stdio.h>
#include <iv.h>
#include "iv_avl.h"

static int height(const struct iv_avl_node *an)
{
	return an != NULL ? an->height : 0;
}

static void recalc_height(struct iv_avl_node *an)
{
	int hl;
	int hr;

	hl = height(an->left);
	hr = height(an->right);
	an->height = 1 + ((hl > hr) ? hl : hr);
}

/*
 * There are four different rotations that may need to be performed
 * to rebalance subtrees after an insertion or deletion operation.
 *
 * In the diagrams below, the letters a - g symbolise tree nodes or
 * subtrees, where capital letters denote nodes that are guaranteed
 * to be present, and lower case letters denote nodes that may be NULL.
 *
 * The tables document the balance factors for each of the capital
 * letter nodes, where the balance factor is defined as the height of
 * the right subtree minus the height of the left subtree.
 *
 *
 * left rotation:
 *
 *    B              D			 before |  after
 *   / \            / \			  B   D |  D   B
 *  a   D    =>    B   E		--------+--------
 *     / \        / \			 +2   0 | -1  +1
 *    c   E      a   c			 +2  +1 |  0   0
 *
 *
 * right rotation:
 *
 *      D          B			 before |  after
 *     / \        / \			  D   B |  B   D
 *    B   e  =>  A   D			--------+--------
 *   / \            / \			 -2  -1 |  0   0
 *  A   c          c   e		 -2   0 | +1  -1
 *
 *
 * left-right rotation:
 *
 *      F            D			     before |  after
 *     / \          / \			  F   B   D |  D   B   F
 *    B   g  =>    /   \		------------+------------
 *   / \          B     F		 -2  +1  -1 |  0   0  +1
 *  a   D        / \   / \		 -2  +1   0 |  0   0   0
 *     / \      a   c e   g		 -2  +1  +1 |  0  -1   0
 *    c   e
 *
 *
 * right-left rotation:
 *
 *    B              D			     before |  after
 *   / \            / \			  B   F   D |  D   B   F
 *  a   F    =>    /   \		------------+------------
 *     / \        B     F		 +2  -1  -1 |  0   0  +1
 *    D   g      / \   / \		 +2  -1   0 |  0   0   0
 *   / \        a   c e   g		 +2  -1  +1 |  0  -1   0
 *  c   e
 */
static void rotate_left(struct iv_avl_node **root)
{
	struct iv_avl_node *b = *root;
	struct iv_avl_node *d = b->right;
	struct iv_avl_node *c;

	c = d->left;
	b->right = c;
	if (c != NULL)
		c->parent = b;
	recalc_height(b);

	d->left = b;
	d->parent = b->parent;
	b->parent = d;
	recalc_height(d);

	*root = d;
}

static void rotate_right(struct iv_avl_node **root)
{
	struct iv_avl_node *d = *root;
	struct iv_avl_node *b = d->left;
	struct iv_avl_node *c;

	c = b->right;
	d->left = c;
	if (c != NULL)
		c->parent = d;
	recalc_height(d);

	b->right = d;
	b->parent = d->parent;
	d->parent = b;
	recalc_height(b);

	*root = b;
}

static void rotate_left_right(struct iv_avl_node **root)
{
	struct iv_avl_node *f = *root;
	struct iv_avl_node *b = f->left;
	struct iv_avl_node *d = b->right;
	struct iv_avl_node *c;
	struct iv_avl_node *e;

	c = d->left;
	b->right = c;
	if (c != NULL)
		c->parent = b;
	recalc_height(b);

	e = d->right;
	f->left = e;
	if (e != NULL)
		e->parent = f;
	recalc_height(f);

	d->left = b;
	d->right = f;
	d->parent = f->parent;
	b->parent = d;
	f->parent = d;
	recalc_height(d);

	*root = d;
}

static void rotate_right_left(struct iv_avl_node **root)
{
	struct iv_avl_node *b = *root;
	struct iv_avl_node *f = b->right;
	struct iv_avl_node *d = f->left;
	struct iv_avl_node *c;
	struct iv_avl_node *e;

	c = d->left;
	b->right = c;
	if (c != NULL)
		c->parent = b;
	recalc_height(b);

	e = d->right;
	f->left = e;
	if (e != NULL)
		e->parent = f;
	recalc_height(f);

	d->left = b;
	d->right = f;
	d->parent = b->parent;
	b->parent = d;
	f->parent = d;
	recalc_height(d);

	*root = d;
}

static int balance(const struct iv_avl_node *an)
{
	return height(an->right) - height(an->left);
}

static void rebalance_node(struct iv_avl_node **_root)
{
	struct iv_avl_node *root = *_root;
	int bal;

	bal = balance(root);
	if (bal == -2) {
		if (balance(root->left) <= 0)
			rotate_right(_root);
		else
			rotate_left_right(_root);
	} else if (bal == 2) {
		if (balance(root->right) < 0)
			rotate_right_left(_root);
		else
			rotate_left(_root);
	}
}

/*
 * Find the address of the (child) pointer that points to an.
 */
static struct iv_avl_node **
find_reference(struct iv_avl_tree *tree, const struct iv_avl_node *an)
{
	if (an->parent != NULL) {
		if (an->parent->left == an)
			return &an->parent->left;
		else
			return &an->parent->right;
	} else {
		return &tree->root;
	}
}

static void replace_reference(struct iv_avl_tree *tree,
			      const struct iv_avl_node *an,
			      struct iv_avl_node *new_child)
{
	*find_reference(tree, an) = new_child;
}

/*
 * Rebalance the tree from an back to the root.  Rebalancing can stop
 * at the first node where no re-balancing was needed, or where
 * re-balancing restored the height of the subtree to what it was
 * before the insertion or deletion.
 */
static void rebalance_path(struct iv_avl_tree *tree, struct iv_avl_node *an)
{
	while (an != NULL) {
		int old_height;
		struct iv_avl_node **ref;

		old_height = an->height;
		recalc_height(an);

		ref = find_reference(tree, an);
		rebalance_node(ref);
		an = *ref;

		if (old_height == an->height)
			break;

		an = an->parent;
	}
}

int iv_avl_tree_insert(struct iv_avl_tree *tree, struct iv_avl_node *an)
{
	struct iv_avl_node *p;
	struct iv_avl_node **pp;

	/*
	 * Find the node to which an is to be attached as a leaf.
	 */
	p = NULL;
	pp = &tree->root;
	while (*pp != NULL) {
		int ret;

		p = *pp;

		ret = tree->compare(an, p);
		if (ret < 0)
			pp = &p->left;
		else if (ret > 0)
			pp = &p->right;
		else
			return -1;
	}

	/*
	 * Insert an.
	 */
	an->left = NULL;
	an->right = NULL;
	an->parent = p;
	an->height = 1;
	*pp = an;

	/*
	 * Start rebalancing from an's parent.
	 */
	rebalance_path(tree, p);

	return 0;
}

static struct iv_avl_node *
iv_avl_tree_delete_leaf(struct iv_avl_tree *tree, struct iv_avl_node *an)
{
	/*
	 * Simply replace the reference from an's parent to an by NULL,
	 * and start rebalancing from an's parent.
	 */
	replace_reference(tree, an, NULL);

	return an->parent;
}

static struct iv_avl_node *
iv_avl_tree_delete_nonleaf(struct iv_avl_tree *tree, struct iv_avl_node *an)
{
	struct iv_avl_node *victim;
	struct iv_avl_node *p;

	/*
	 * an is not a leaf node, so removing it is slightly more
	 * complicated than NULLing its parent's reference to it.
	 *
	 * an will be replaced by either the maximum node in the
	 * left subtree or the minimum node in the right subtree,
	 * depending on the relative heights of those subtrees.  We
	 * call the replacing node the victim node.
	 *
	 * The victim node, i.e. the maximum (minimum) node in the
	 * left (right) subtree could still have a left (right) child
	 * node.  Here, we replace the victim node by its child, and
	 * unlink the victim node from the tree.
	 */
	if (height(an->left) > height(an->right)) {
		victim = an->left;
		while (victim->right != NULL)
			victim = victim->right;

		replace_reference(tree, victim, victim->left);
		if (victim->left != NULL)
			victim->left->parent = victim->parent;
	} else {
		victim = an->right;
		while (victim->left != NULL)
			victim = victim->left;

		replace_reference(tree, victim, victim->right);
		if (victim->right != NULL)
			victim->right->parent = victim->parent;
	}

	/*
	 * We will start rebalancing the tree from the victim node's
	 * original parent, unless that original parent is an, in which
	 * case we will start rebalancing from the victim node itself
	 * (after it has replaced an).
	 */
	p = victim->parent;
	if (p == an)
		p = victim;

	/*
	 * Point an's parent's pointer to it to victim, move an's
	 * children to victim, and make an's children point back to
	 * victim as their parent.
	 */
	replace_reference(tree, an, victim);
	victim->left = an->left;
	victim->right = an->right;
	victim->parent = an->parent;
	victim->height = an->height;
	if (victim->left != NULL)
		victim->left->parent = victim;
	if (victim->right != NULL)
		victim->right->parent = victim;

	return p;
}

void iv_avl_tree_delete(struct iv_avl_tree *tree, struct iv_avl_node *an)
{
	struct iv_avl_node *p;

	if (an->left == NULL && an->right == NULL)
		p = iv_avl_tree_delete_leaf(tree, an);
	else
		p = iv_avl_tree_delete_nonleaf(tree, an);

	rebalance_path(tree, p);
}

struct iv_avl_node *iv_avl_tree_next(struct iv_avl_node *an)
{
	struct iv_avl_node *p;

	if (an->right != NULL) {
		an = an->right;
		while (an->left != NULL)
			an = an->left;

		return an;
	}

	p = an->parent;
	while (p != NULL && an == p->right) {
		an = p;
		p = an->parent;
	}

	return p;
}

struct iv_avl_node *iv_avl_tree_prev(struct iv_avl_node *an)
{
	struct iv_avl_node *p;

	if (an->left != NULL) {
		an = an->left;
		while (an->right != NULL)
			an = an->right;

		return an;
	}

	p = an->parent;
	while (p != NULL && an == p->left) {
		an = p;
		p = an->parent;
	}

	return p;
}
