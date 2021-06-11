#include <stdio.h>
#include <stdlib.h>
#include "tree.h"
struct INT{
	int data;
	SPLAY_ENTRY(INT) link;
};
int inline cmp(struct INT *x, struct INT *y)
{
	return x->data - y->data;
}
SPLAY_HEAD(INT_head, INT) root = SPLAY_INITIALIZER(root);
SPLAY_PROTOTYPE(INT_head, INT, link, cmp);
SPLAY_GENERATE(INT_head, INT, link, cmp);
int test_splay_tree()
{
	int i, j;
	struct INT *x, *y, f;
	
	for(i = 0; i < 10; i++){
		x = (struct INT *)calloc(1, sizeof(struct INT));		
		x->data = i + 10;
		SPLAY_INSERT(INT_head, &root, x);
	}
	SPLAY_FOREACH(y, INT_head, &root){
		printf("%d \t", y->data);
	}
	printf("\n\n");
	f.data = 15;
	printf("before search\n");
	printf("root %d\n", root.sph_root->data);
	y = SPLAY_FIND(INT_head, &root, &f);
	printf("root %d\n", root.sph_root->data);
	printf("%p %p\n", y->link.spe_left, y->link.spe_right);
	y = SPLAY_FIND(INT_head, &root, &f);
	printf("%p %p\n", y->link.spe_left, y->link.spe_right);
	y = SPLAY_FIND(INT_head, &root, &f);
	y = SPLAY_FIND(INT_head, &root, &f);
	y = SPLAY_NEXT(INT_head, &root, y);
	if(y)
			printf("\n the next of f is %d\n", y->data);
	else
			printf("not find next\n");
	y = SPLAY_MIN(INT_head, &root);
	printf("\n min :%d\n", y->data);
	y = SPLAY_MAX(INT_head, &root);
	printf("\nmax:%d\n", y->data);
	if(y == NULL)
		printf("elem not find\n");
	printf("find %d\t", y->data);
	
	printf("\n\n");
	SPLAY_FOREACH(y, INT_head, &root){
		printf("%d \t", y->data);
	}
	

	y =  SPLAY_REMOVE(INT_head, &root, &f);
//	y = SPLAY_NEXT(INT_head, &root, y);
	if(y)
			printf("\n the next of f is %d\n", y->data);
	else
			printf("not find next\n");
	y = SPLAY_FIND(INT_head, &root, &f);
	if(y == NULL)
		printf("elem not find\n");

	printf("\n\n");
	return 0;
}




//test for rb tree

struct RBINT{
	int data;
	RB_ENTRY(RBINT) link;
};
int inline rb_cmp(struct RBINT *x, struct RBINT *y)
{
	return x->data - y->data;
}
RB_HEAD(RBINT_head, RBINT) root1 = RB_INITIALIZER(root1);
RB_PROTOTYPE(RBINT_head, RBINT, link, rb_cmp);
RB_GENERATE(RBINT_head, RBINT, link, rb_cmp);
int test_rb_tree()
{
	int i, j;
	struct RBINT *x, *y, f;
	
	for(i = 0; i < 10; i++){
		x = (struct RBINT *)calloc(1, sizeof(struct RBINT));		
		x->data = i + 10;
		RB_INSERT(RBINT_head, &root1, x);
	}
	RB_FOREACH(y, RBINT_head, &root1){
		printf("%d \t", y->data);
	}
	printf("\n\n");
	f.data = 15;
	printf("before search\n");
	printf("root %d\n", root1.rbh_root->data);
	y = RB_FIND(RBINT_head, &root1, &f);
	printf("root %d\n", root1.rbh_root->data);
	printf("%p %p\n", y->link.rbe_left, y->link.rbe_right);
	y = RB_FIND(RBINT_head, &root1, &f);
	printf("%p %p\n", y->link.rbe_left, y->link.rbe_right);
	y = RB_FIND(RBINT_head, &root1, &f);
	y = RB_FIND(RBINT_head, &root1, &f);
	y = RB_NEXT(RBINT_head, &root1, y);
	if(y)
			printf("\n the next of f is %d\n", y->data);
	else
			printf("not find next\n");
	y = RB_MIN(RBINT_head, &root1);
	printf("\n min :%d\n", y->data);
	y = RB_MAX(RBINT_head, &root1);
	printf("\nmax:%d\n", y->data);
	if(y == NULL)
		printf("elem not find\n");
	printf("find %d\t", y->data);
	
	printf("\n\n");
	RB_FOREACH(y, RBINT_head, &root1){
		printf("%d \t", y->data);
	}
	

	//y =  RB_REMOVE(RBINT_head, &root1, &f);
//	y = RB_NEXT(RBINT_head, &root, y);
	if(y)
			printf("\n the next of f is %d\n", y->data);
	else
			printf("not find next\n");
	y = RB_FIND(RBINT_head, &root1, &f);
	if(y == NULL)
		printf("elem not find\n");

	printf("\n\n");
	return 0;
}
int main()
{
	//test_splay_tree();
	test_rb_tree();
	return 0;
}
