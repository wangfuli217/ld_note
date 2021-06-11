#include "rbtree_rc.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define PAUSE system("pause")

int
main(void)
{
	struct rb_root mytree = RB_ROOT;
	struct container * pc;
	int ret;
	int size = 100;
	int find, erase, replace;
	printf("rbtest go ... \n");
	
	/*
	 * 插入测试
	 */
	pc = calloc(sizeof(struct container) + size, 1);
	strcat((char*)&pc->rb_data.data, "hello world 1");
	pc -> rb_data.key = 1;
	pc -> rb_data.size = size;
	ret = container_insert(&mytree, pc);
	printf("insert 1 ret = %d\n", ret);

	pc = calloc(sizeof(struct container) + size, 1);
	strcat((char*)&pc->rb_data.data, "hello world 2");
	pc -> rb_data.key = 2;
	pc -> rb_data.size = size;
	ret = container_insert(&mytree, pc);
	printf("insert 2 ret = %d\n", ret);
	
	pc = calloc(sizeof(struct container) + size, 1);
	strcat((char*)&pc->rb_data.data, "hello world 4");
	pc -> rb_data.key = 4;
	pc -> rb_data.size = size;
	ret = container_insert(&mytree, pc);
	printf("insert 4 ret = %d\n", ret);
	
	pc = calloc(sizeof(struct container) + size, 1);
	strcat((char*)&pc->rb_data.data, "hello world 3");
	pc -> rb_data.key = 3;
	pc -> rb_data.size = size;
	ret = container_insert(&mytree, pc);
	printf("insert 3 ret = %d\n", ret);
	/********************************************************/
	
	/*
	 * 查找测试
	 */
	find = 6;
	printf("find key %d\n", find);
	pc = container_search(&mytree, find);
	if (pc != 0)
		printf("key %d pc data: %s\n", find, (char*)pc->rb_data.data);
	else
		printf("no find %d\n", find);
	
	find = 3;
	printf("find key %d\n", find);
	pc = container_search(&mytree, find);
	if (pc != 0)
		printf("find key %d data: %s\n", find, (char*)pc->rb_data.data);
	else
		printf("no find %d\n", find);
	/********************************************************/
	
	/*
	 * 节点删除测试
	 */
	erase = 3;
	printf("erase key %d\n", erase);
	pc = container_delete(&mytree, erase);
	if (pc != 0) {
		printf("erase key %d data: %s\n", find, (char*)pc->rb_data.data);
		free(pc);
	}
	else
		printf("no erase %d\n", find);
	
	find = 3;
	printf("find key %d\n", find);
	pc = container_search(&mytree, find);
	if (pc != 0)
		printf("find key %d data: %s\n", find, (char*)pc->rb_data.data);
	else
		printf("no find %d\n", find);
	/********************************************************/
	
	/*
	 * 节点更新替换测试
	 */
	replace = 2;
	printf("replace key %d\n", replace);
	pc = calloc(sizeof(struct container) + size, 1);
	strcat((char*)&pc->rb_data.data, "this is replace key 2");
	pc -> rb_data.key = replace;
	pc -> rb_data.size = size;
	pc = container_replace(&mytree, replace, pc);
	if (pc != 0)
	{
		printf("replace key %d ret = %p, data: %s\n", replace, pc, (char*)pc->rb_data.data);
		free(pc);
	}
	else
	{
		printf("replace key %d failed\n", replace);	
	}
	
	find = 2;
	printf("find key %d\n", find);
	pc = container_search(&mytree, find);
	if (pc != 0)
		printf("find key %d data: %s\n", find, (char*)pc->rb_data.data);
	else
		printf("no find %d\n", find);
	/********************************************************/
	
	printf("rbtest end\n");
			
	PAUSE;		
	return 0;
} 
