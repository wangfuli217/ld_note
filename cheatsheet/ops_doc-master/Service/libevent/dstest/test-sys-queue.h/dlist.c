/**
 *          File: dlist.c
 *
 *        Create: 2015-1-19 10:03:37
 *
 *   Discription: sys/queue.h中的双向链表使用测试程序
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
	LIST_ENTRY(_Data) entry;
	/* 
	 *	struct {
	 *		struct _Data *le_next
	 *		struct _Data **le_prev;
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
	int i;
#if 0
	LIST_HEAD(list_head, _Data) head;	
	LIST_INIT(&head);
#else
	LIST_HEAD(list_head, _Data) head = LIST_HEAD_INITIALIZER(&head);	
#endif

	struct _Data *prev = NULL;
	for (i = 0; i < 10; i++) {
		INIT(i);
		if (LIST_EMPTY(&head)) {	/* or if (i == 0) */
			LIST_INSERT_HEAD(&head, cur, entry);
		} else {
			LIST_INSERT_AFTER(prev, cur, entry);
//			LIST_INSERT_BEFORE(prev, cur, entry);
		}
		prev = cur;
	}

	if (!LIST_EMPTY(&head)) {
		struct _Data *pdata = NULL;
#if 0
		for (pdata = head.lh_first; pdata; pdata = pdata->entry.le_next) {
			printf("head.lh_frist = %p -- %d\n", head.lh_first, *pdata->pint);
			free(pdata->pint);
			free(pdata);
			LIST_REMOVE(pdata, entry);
		}
#else
#if 0
		for (pdata = LIST_FIRST(&head); pdata; pdata = LIST_NEXT(pdata, entry)) {
			printf("head.lh_frist = %p -- %d\n", head.lh_first, *pdata->pint);
			free(pdata->pint);
			free(pdata);
			LIST_REMOVE(pdata, entry);
		}
#else 
		LIST_FOREACH(pdata, &head, entry) {
			printf("head.lh_frist = %p -- %d\n", head.lh_first, *pdata->pint);
			free(pdata->pint);
			free(pdata);
			LIST_REMOVE(pdata, entry);
		}
#endif
#endif
	}

	if (LIST_EMPTY(&head)) {
		printf("list is empty now.\n");	
	}

	exit(EXIT_SUCCESS);
}
