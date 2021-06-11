#include <stdio.h>
#include <stdlib.h>

#include "rbtree.h"

#define PAUSE	system("pause")
#define SIZEOF(t) sizeof(t)


int main(int argc, char **argv)
{
	printf("hello world\n");
	
	int i;
	struct rb_node tree;

	
	printf("color: %x\n", &(tree.rb_parent_color));	
	printf("parnt: %x\n", rb_parent(&tree));
	printf("sizeof: %d\n", sizeof(struct rb_node));
	printf("sizeof: %d\n", SIZEOF(long));
	
	PAUSE;
	return 0;
}
