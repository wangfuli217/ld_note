/**
 *          File: slist.c
 *
 *        Create: 2015-1-19 10:05:05
 *
 *   Discription: sys/queue.h中的单向链表使用测试程序
 *
 *        Author: astrol 
 *         Email: astrotycoon@gmail.com
 *
 *===========================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>

struct _Data {
	int 				value;
	/* ... 任意其他数据 */
	SLIST_ENTRY(_Data)	slist_entry;	
};

int main(int argc, const char *argv[])
{
	/* 初始化单链表 */
#if 0
	SLIST_HEAD(slist_head, _Data) head = SLIST_HEAD_INITIALIZER(&head);	
#else
	SLIST_HEAD(slist_head, _Data) head;
	SLIST_INIT(&head);
#endif

	struct _Data *data1 = (struct _Data *)malloc(sizeof(struct _Data));
	data1->value = 1;
	SLIST_INSERT_HEAD(&head, data1, slist_entry);

	struct _Data *data2 = (struct _Data *)malloc(sizeof(struct _Data));
	data2->value = 2;
	SLIST_INSERT_AFTER(data1, data2, slist_entry);		

	struct _Data *data3 = (struct _Data *)malloc(sizeof(struct _Data));
	data3->value = 3;
	SLIST_INSERT_HEAD(&head, data3, slist_entry);

#if 0
	/* 往单链表中添加10个数据元素 */
	struct _Data *prev = NULL;
	for (i = 0; i < 10; i++) {
		struct _Data *cur = (struct _Data *)calloc(1, sizeof(struct _Data));	
		cur->value = i;	
#ifdef _DEBUG
		printf("%p -- %d\n", cur, cur->value);
#endif
#if 0
		if (SLIST_EMPTY(&head))	{
			SLIST_INSERT_HEAD(&head, cur, slist_entry);	
		} else {
			SLIST_INSERT_AFTER(prev, cur, slist_entry);		
			// 为什么没有SLIST_INSERT_BEFORE()?
		}
#endif
		if (SLIST_EMPTY(&head)) {
			SLIST_INSERT_HEAD(&head, cur, slist_entry);	
		} else if (i == 2) {
			SLIST_INSERT_HEAD(&head, cur, slist_entry);	
		} else {
			SLIST_INSERT_AFTER(prev, cur, slist_entry);		
		}

		prev = cur;
	}

	puts("");

#if 0
#ifdef _DEBUG
	printf("old head %p %p\n", &head, SLIST_FIRST(&head));
#endif
	SLIST_REMOVE_HEAD(&head, slist_entry);
#ifdef _DEBUG
	printf("new head %p %p\n", &head, SLIST_FIRST(&head));
#endif
#endif
#endif

	puts("");

	struct _Data *pdata = NULL;
	/* 遍历整个单链表，并删除每个元素 */
#if 0
	for (pdata = SLIST_FIRST(&head); pdata; pdata = SLIST_NEXT(pdata, slist_entry)) {
		printf("%p -- %d\n", pdata, pdata->value);
		free(pdata);
		SLIST_REMOVE(&head, pdata, _Data, slist_entry);
	}
#else
	SLIST_FOREACH(pdata, &head, slist_entry) {
		printf("%p -- %d\n", pdata, pdata->value);
		free(pdata);
		SLIST_REMOVE(&head, pdata, _Data, slist_entry);
	}
#endif
	puts("");

	if (SLIST_EMPTY(&head)) {
		printf("slist is empty now.\n");	
	}

	exit(EXIT_SUCCESS);
}
