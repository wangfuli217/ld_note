#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>

struct _Data {
	int	*pint;
	TAILQ_ENTRY(_Data)	entry;
};

#define INIT(i)	\
		struct _Data *cur = (struct _Data *)calloc(1, sizeof(struct _Data));	\
		cur->pint = (int *)calloc(1, sizeof(int));	\
		*cur->pint = (i);	\
		printf("%p -- (%p)%d\n", cur, cur->pint, *cur->pint);

int main(int argc, const char *argv[])
{
#if 1
	/* 这里的初始化传递的并不是指针 */
	TAILQ_HEAD(tqueue_head, _Data)	head1 = TAILQ_HEAD_INITIALIZER(head1), head2 = TAILQ_HEAD_INITIALIZER(head2);
#else
	/* 这里的初始化传递的是指针  	*/
	TAILQ_HEAD(tqueue_head, _Data)	head1, head2;
	TAILQ_INIT(&head1);
	TAILQ_INIT(&head2);
#endif
	int i;

	struct _Data *prev = NULL;
	for (i = 0; i < 10; i++) {
		INIT(i);
		if (TAILQ_EMPTY(&head1)) {
			TAILQ_INSERT_HEAD(&head1, cur, entry);	
		} else {
//			TAILQ_INSERT_TAIL(&head1, cur, entry);
//			TAILQ_INSERT_AFTER(&head1, prev, cur, entry);
			TAILQ_INSERT_BEFORE(prev, cur, entry);
		}
		prev = cur;
	}
	
	printf("\n");

	if (!TAILQ_EMPTY(&head1)) {
		struct _Data *pdata = NULL;
#if 0
		for (pdata = head1.tqh_first; pdata; pdata = pdata->entry.tqe_next)	{
			printf("%p -- (%p)%d\n", pdata, pdata->pint, *pdata->pint);
			free(pdata->pint);	
			free(pdata);
			TAILQ_REMOVE(&head1, pdata, entry);
		}
#else
#if 1

#else

#endif
#endif	
	}

	if (TAILQ_EMPTY(&head1)) {
		printf("tail queue head1 is empty now.\n");	
	}

	printf("\n");

	prev = NULL;
	for (i = 100; i < 110; i++) {
		INIT(i);	
		if (TAILQ_EMPTY(&head2)) {
			TAILQ_INSERT_HEAD(&head2, cur, entry);	
		} else {
			TAILQ_INSERT_TAIL(&head2, cur, entry);
//			TAILQ_INSERT_AFTER(&head2, prev, cur, entry);
//			TAILQ_INSERT_BEFORE(prev, cur, entry);
		}
		prev = cur;
	}
	
	exit(EXIT_SUCCESS);
}
