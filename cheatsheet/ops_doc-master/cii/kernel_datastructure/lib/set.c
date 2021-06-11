#include "set.h"

int set_insert(struct set *set, struct set_node *node)
{
	struct set_node **new = &(set->root.rb_node);
	struct set_node *parent = NULL;
	while(*new){
		parent = *new;
		if(set->cmp_func(parent, node) > 0)
			new = &parent->rb_left;
		else if (set->cmp_func(parent, node) < 0)
			new = &parent->rb_right;
		else if (set->cmp_func(parent, node) == 0)
			return 1;
	}
	rb_link_node(node, parent, new);
	rb_insert_color(node, &set->root);
	set->num++;
	return 0;
}

int set_remove(struct set *set, struct set_node *node)
{
	rb_erase(node, &set->root);
	if(set->num > 0) set->num--;
	return 0;
}
int set_remove_destroy(struct set *set, struct set_node *node)
{
	rb_erase(node, &set->root);
	if(set->destroy_func)
		set->destroy_func(node);
	if(set->num > 0) set->num--;
	return 0;
}
int set_is_member(struct set *set, struct set_node *node)
{
	struct set_node **new = &(set->root.rb_node);
	struct set_node *parent = NULL;
	while(*new){
		parent = *new;
		if(set->cmp_func(parent, node) > 0)
			new = &parent->rb_left;
		else if (set->cmp_func(parent, node) < 0)
			new = &parent->rb_right;
		else if (set->cmp_func(parent, node) == 0)
			return 1;
	}
	return 0;
}
int set_intersection(struct set *setu, struct  set *set1, struct set *set2)
{
	struct set_node *pos;
	struct set_node *new_node;
	if(!set1->cmp_func || !set1->copy_func){
		SET_ERROR("please implememt copy func");
		return -1;
	}
	set_init(setu, set1->cmp_func, set1->copy_func, set1->destroy_func);
	set_for_each(pos, set1){
		if(!set_is_member(set2, pos))
			continue;
		new_node = set1->copy_func(pos);
		if(new_node)
			set_insert(setu, new_node);
	}
	return 0;
}

int set_difference(struct set *setd,struct  set *set1,struct  set *set2)
{
	struct set_node *pos;
	struct set_node *new_node;
	if(!set1->cmp_func || !set1->copy_func){
		SET_ERROR("please implememt copy func");
		return -1;
	}
	set_init(setd, set1->cmp_func, set1->copy_func, set1->destroy_func);
	set_for_each(pos, set1){
		if(set_is_member(set2, pos))
			continue;
		new_node = set1->copy_func(pos);
		set_insert(setd, new_node);
	}
	return 0;
}

int set_union(struct set *setu, struct set *set1,struct  set *set2)
{
	struct set_node *pos;
	struct set_node *new_node;
	if(!set1->cmp_func || !set1->copy_func){
		SET_ERROR("please implememt copy func");
		return -1;
	}
	set_init(setu, set1->cmp_func, set1->copy_func, set1->destroy_func);
	set_for_each(pos, set1){
		new_node = set1->copy_func(pos);
		set_insert(setu, new_node);
	}
	set_for_each(pos, set2){
		if(set_is_member(setu, pos))
			continue;
		new_node = setu->copy_func(pos);
		set_insert(setu, new_node);
	}
	return 0;
}

int set_is_subset(struct set *set1,struct  set *set2)
{
	struct set_node *pos;
	if(set1->num > set2->num) return 0;
	set_for_each(pos, set1){
		if(!set_is_member(set2, pos))
			return 0;
	}
	return 1;
}

int set_is_equal(struct set *set1, struct set *set2)
{
	if(set1->num != set2->num) return 0;
	return set_is_subset(set1, set2);
}
