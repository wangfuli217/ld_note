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
	int 				value;
	LIST_ENTRY(_Data) 	dlist_entry;
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

	struct _Data *data1 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data1->value = 1;
	LIST_INSERT_HEAD(&head, data1, dlist_entry);
	
	struct _Data *data2 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data2->value = 2;
	LIST_INSERT_AFTER(data1, data2, dlist_entry);

	struct _Data *data3 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data3->value = 3;
	LIST_INSERT_HEAD(&head, data3, dlist_entry);

	struct _Data *data4 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data4->value = 4;
	LIST_INSERT_BEFORE(data1, data4, dlist_entry);


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
		LIST_FOREACH(pdata, &head, dlist_entry) {
			printf("head.lh_frist = %p -- %d\n", head.lh_first, pdata->value);
//			free(pdata->pint);
			free(pdata);
			LIST_REMOVE(pdata, dlist_entry);
		}
#endif
#endif
	}

	if (LIST_EMPTY(&head)) {
		printf("list is empty now.\n");	
	}

	exit(EXIT_SUCCESS);
}
