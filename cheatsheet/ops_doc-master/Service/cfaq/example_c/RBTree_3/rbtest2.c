#include "rbtree_rc.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define PAUSE	system("pause")

int
main(void)
{
	struct rb_root mytree;
	struct container * pc;
	int ret;
	int size = sizeof(int);
	int find, erase, replace;
	
	const int max = 100000;
	int i, rd;
	
	printf("rbtest go ... \n");
	
	init_rbtree(&mytree);
	
	for (i = 0; i < max; ++i)
	{
		rd = rand() % max;
		
		// container ´´½¨
		pc = calloc(sizeof(struct container) + size, 1);
		pc -> rb_data.key = i;
		*(int*)&pc -> rb_data.data = rd;
		pc -> rb_data.size = size;
		
		// ²åÈë
		ret = container_insert(&mytree, pc);		
		if (ret < 0)
			printf("failed + insert key: %d, data: %d\n", i, rd);
		else
			printf("successful + insert  key: %d, data: %d\n", i, rd);
		
		// ²éÕÒ			
		pc = container_search(&mytree, i);
		if (pc != 0)
			printf("successful ^ search  key: %d, data: %d\n", i, *(int*)&pc->rb_data.data);
		else
			printf("failed ^ search no key %d\n", i);
		
		// Ìæ»»Ä³Ð©½Úµã
		if (i % 20 == 0)
		{
			pc = calloc(sizeof(struct container) + size, 1);
			pc -> rb_data.key = i;
			*(int*)&pc -> rb_data.data = rand() % max;
			pc -> rb_data.size = size;
			pc = container_replace(&mytree, i, pc);
			if (pc != 0)
			{
				printf("successful @ replace key: %d, old data: %d, new data: %d\n", 
						i, *(int*)&pc->rb_data.data, 
						*(int*)&container_search(&mytree, i)->rb_data.data
						);
				free(pc);
			}
			else
			{
				printf("failed @ replace key: %d failed\n", i);	
			}	
		}
		
		// É¾³ýÄ³Ð©½Úµã
		if (i % 10 == 0)
		{
			pc = container_delete(&mytree, i);
			if (pc == 0)
			{
				printf("failed - delete key: %d\n", i);
			}
			else
			{
				printf("successful - delete  key: %d, data: %d\n", i, *(int*)&pc->rb_data.data);
				free(pc);
			}
		}
	}

	printf("rbtest end\n");
		
	PAUSE;	
		
	return 0;
} 
