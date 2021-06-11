#include "set.h"
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#define MAX_NODE 100
#define INTERSECT_BEGIN 40
struct set_int{
	int val;
	struct set_node node;
};

struct set_string{
	char *name;
	struct set_node node;
};

static int cmp_string(struct set_node *elem1, struct set_node *elem2)
{
	char *val1 = set_entry(elem1, struct set_string, node)->name;
	char *val2 = set_entry(elem2, struct set_string, node)->name;
	return strcmp(val1, val2);
}

static void string_destroy_func(struct set_node *elem)
{
	struct set_string *node;
	node = set_entry(elem, struct set_string, node);
#ifdef DEBUG
//	printf("free node val = %d\n", node->val);
#endif
	if(!node->name) free(node->name);
	free(node);
}

static struct set_node *string_copy_func(struct set_node *elem)
{
	struct set_string *node;
	struct set_string *new_node = NULL;
	node = set_entry(elem, struct set_string, node);
	new_node = (struct set_string*)malloc(sizeof(struct set_string));
	if(new_node){
		memcpy(new_node, node, sizeof(struct set_string));
		node->name = strdup(node->name);
		if(!node->name){
			return NULL;
		}
#ifdef DEBUG
		printf("alloc node val = %s\n", node->name);
#endif
		return &new_node->node;
	}
	return NULL;
}
static void destroy_func(struct set_node *elem)
{
	struct set_int *node;
	node = set_entry(elem, struct set_int, node);
#ifdef DEBUG
	printf("free node val = %d\n", node->val);
#endif
	if(!node)
		free(node);
}

static struct set_node *copy_func(struct set_node *elem)
{
	struct set_int *node;
	struct set_int *new_node = NULL;
	node = set_entry(elem, struct set_int, node);
	new_node = (struct set_int*)malloc(sizeof(struct set_int));
	if(new_node)
		memcpy(new_node, node, sizeof(struct set_int));
#ifdef DEBUG
	printf("alloc node val = %d\n", node->val);
#endif
	if(new_node)
		return &new_node->node;
	return NULL;
}

static int cmp_int(struct set_node *elem1, struct set_node *elem2)
{
	int val1 = set_entry(elem1, struct set_int, node)->val;
	int val2 = set_entry(elem2, struct set_int, node)->val;
	return val1 - val2;
}
#define STRING_NODE_NUM 5
char *name1[5] = {"lili", "hihi", "jiji", "fifi", "higi"};
char *name2[5] = {"gigi", "fifi", "lili", "kiki", "lili"};
static void test_set_string(void)
{
	struct set set1,set2,set3;
	unsigned int i;
	struct set_string *tmp_test_node;
	struct set_node *tmp_set_node;
	set_init(&set1, cmp_string, string_copy_func, string_destroy_func);
	set_init(&set2, cmp_string, string_copy_func, string_destroy_func);
	printf("================Start test set string=============\n");
	for(i = 0; i < STRING_NODE_NUM; i++){
		tmp_test_node = (struct set_string *)malloc(sizeof(struct set_string));
		tmp_test_node->name = strdup(name1[i]);
		set_insert(&set1, &tmp_test_node->node);

		tmp_test_node = (struct set_string *)malloc(sizeof(struct set_string));
		tmp_test_node->name = strdup(name2[i]);
		if(set_insert(&set2, &tmp_test_node->node)){
			free(tmp_test_node->name);
			free(tmp_test_node);
		}
	}
	assert((set1.num == STRING_NODE_NUM) && (set2.num == STRING_NODE_NUM - 1));
	printf("name in set1:");
	set_for_each(tmp_set_node, &set1){
		tmp_test_node = set_entry(tmp_set_node, struct set_string, node);
		printf("%s   ", tmp_test_node->name);
	}
	printf("\n");
	printf("name in set2:");
	set_for_each(tmp_set_node, &set2){
		tmp_test_node = set_entry(tmp_set_node, struct set_string, node);
		printf("%s   ", tmp_test_node->name);
	}
	printf("\n");

	printf("name is both set1 and set2:");
	set_intersection(&set3, &set2, &set1);
	set_for_each(tmp_set_node, &set3){
		tmp_test_node = set_entry(tmp_set_node, struct set_string, node);
		printf("%s   ", tmp_test_node->name);
	}
	set_for_each(tmp_set_node, &set3){
		set_remove_destroy(&set3, tmp_set_node);
	}
	assert(set3.num == 0);
	printf("\n");

	printf("name in  set2 but not in set1:");
	set_difference(&set3, &set2, &set1);
	set_for_each_reverse(tmp_set_node, &set3){
		tmp_test_node = set_entry(tmp_set_node, struct set_string, node);
		printf("%s   ", tmp_test_node->name);;
	}
	set_for_each(tmp_set_node, &set3){
		set_remove_destroy(&set3, tmp_set_node);
	}
	printf("\n");

	set_union(&set3, &set2, &set1);
	printf("atfer union :");
	set_for_each(tmp_set_node, &set3){
		tmp_test_node = set_entry(tmp_set_node, struct set_string, node);
		printf("%s   ", tmp_test_node->name);
	}
	printf("\n");
	assert(set_is_subset(&set1, &set3) && set_is_subset(&set2, &set3) && !set_is_subset(&set1, &set2));
	assert(set_is_equal(&set1, &set1) && !set_is_equal(&set2, &set3));
	set_for_each(tmp_set_node, &set1){
		set_remove_destroy(&set1, tmp_set_node);
	}
	set_for_each(tmp_set_node, &set2){
		set_remove_destroy(&set2, tmp_set_node);
	}
	set_for_each(tmp_set_node, &set3){
		set_remove_destroy(&set3, tmp_set_node);
	}
	printf("==========================test set string OK=================\n");

}

static void test_set_int(void)
{
	struct set set1,set2,set3;
	unsigned int i, j;
	struct set_int *tmp_test_node;
	struct set_node *tmp_set_node;
	set_init(&set1, cmp_int, copy_func, destroy_func);
	set_init(&set2, cmp_int, copy_func, destroy_func);
	printf("================Start test set int=============\n");
	for(i = 0; i < MAX_NODE; i++){
		tmp_test_node = (struct set_int *)malloc(sizeof(struct set_int));
		tmp_test_node->val = i;
		set_insert(&set1, &tmp_test_node->node);

		tmp_test_node = (struct set_int *)malloc(sizeof(struct set_int));
		tmp_test_node->val = INTERSECT_BEGIN + i;
		set_insert(&set2, &tmp_test_node->node);
	}
	assert(set1.num == MAX_NODE && set2.num == MAX_NODE);

	j = INTERSECT_BEGIN;
	set_intersection(&set3, &set2, &set1);
	set_for_each(tmp_set_node, &set3){
		tmp_test_node = set_entry(tmp_set_node, struct set_int, node);
		assert(tmp_test_node->val == j++);
	}

	set_for_each(tmp_set_node, &set3){
		set_remove_destroy(&set3, tmp_set_node);
	}
	assert(set3.num == 0);

	set_difference(&set3, &set2, &set1);
	j = MAX_NODE + INTERSECT_BEGIN - 1;
	set_for_each_reverse(tmp_set_node, &set3){
		tmp_test_node = set_entry(tmp_set_node, struct set_int, node);
		assert(tmp_test_node->val == j--);
	}
	assert(set3.num == INTERSECT_BEGIN);
	printf("\n");
	set_for_each(tmp_set_node, &set3){
		set_remove_destroy(&set3, tmp_set_node);
	}

	set_union(&set3, &set2, &set1);
	j = 0;
	set_for_each(tmp_set_node, &set3){
		tmp_test_node = set_entry(tmp_set_node, struct set_int, node);
		assert(tmp_test_node->val == j++);
	}
	assert(set3.num == MAX_NODE + INTERSECT_BEGIN);

	assert(set_is_subset(&set1, &set3) && set_is_subset(&set2, &set3) && !set_is_subset(&set1, &set2));
	assert(set_is_equal(&set1, &set1) && !set_is_equal(&set2, &set3));
	set_for_each(tmp_set_node, &set1){
		set_remove_destroy(&set1, tmp_set_node);
	}
	set_for_each(tmp_set_node, &set2){
		set_remove_destroy(&set2, tmp_set_node);
	}
	set_for_each(tmp_set_node, &set3){
		set_remove_destroy(&set3, tmp_set_node);
	}
	printf("==========================test set int OK=================\n");

}
int main(int argc, char **argv)
{
	test_set_int();
	test_set_string();
	return 0;
}
