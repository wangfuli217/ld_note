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
	int *pint;
	SLIST_ENTRY(_Data) entry;	
	/* 
	 *	struct {
	 *		struct _Data *sle_next
	 *	}
	 *
	 */
};

#define INIT(i)	\
		struct _Data *cur = (struct _Data *)calloc(1, sizeof(struct _Data));	\
		cur->pint = (int *)calloc(1, sizeof(int));	\
		*cur->pint = (i);	\
		printf("%p -- (%p)%d\n", cur, cur->pint, *cur->pint);

int main(int argc, const char *argv[])
{
#if 0
	SLIST_HEAD(slist_head, _Data) head = SLIST_HEAD_INITIALIZER(&head);	
#else
	SLIST_HEAD(slist_head, _Data) head;
	SLIST_INIT(&head);
#endif
	int i;

	struct _Data *prev = NULL;
	for (i = 0; i < 10; i++) {
		INIT(i);	
		if (SLIST_EMPTY(&head))	{
			SLIST_INSERT_HEAD(&head, cur, entry);	
		} else {
			SLIST_INSERT_AFTER(prev, cur, entry);		
			// 为什么没有SLIST_INSERT_BEFORE()?
		}
		prev = cur;
	}


	printf("old head %p\n", SLIST_FIRST(&head));
	SLIST_REMOVE_HEAD(&head, entry);
	printf("new head %p\n", SLIST_FIRST(&head));

	printf("\n");
	struct _Data *pdata = NULL;
#if 0	/* iterator */

	for (pdata = head.slh_first; pdata; pdata = pdata->entry.sle_next) {
		printf("%p -- (%p)%d\n", pdata, pdata->pint, *pdata->pint);
		free(pdata->pint);
		free(pdata);
		SLIST_REMOVE(&head, pdata, _Data, entry);
	}
#else
#if 1
	for (pdata = SLIST_FIRST(&head); pdata; pdata = SLIST_NEXT(pdata, entry)) {
		printf("%p -- (%p)%d\n", pdata, pdata->pint, *pdata->pint);
		free(pdata->pint);
		free(pdata);
		SLIST_REMOVE(&head, pdata, _Data, entry);
	}
#else
	SLIST_FOREACH(pdata, &head, entry) {
		printf("%p -- (%p)%d\n", pdata, pdata->pint, *pdata->pint);
		free(pdata->pint);
		free(pdata);
		SLIST_REMOVE(&head, pdata, _Data, entry);
	}
#endif
#endif	/* iterator end */

	if (SLIST_EMPTY(&head)) {
		printf("slist is empty now.\n");	
	}

	exit(EXIT_SUCCESS);
}
