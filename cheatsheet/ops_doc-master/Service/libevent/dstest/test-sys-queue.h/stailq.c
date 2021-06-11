#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>

struct _Data {
	int 				value;
	STAILQ_ENTRY(_Data)	next;
};

int main(int argc, const char *argv[])
{
	/* 初始化队列 */
#if 0
	STAILQ_HEAD(head, _Data)	head = STAILQ_HEAD_INITIALIZER(head);
#else
	STAILQ_HEAD(head, _Data)    head;
	STAILQ_INIT(&head);
#endif

	int i;
	struct _Data *pdata = NULL;

	/* 2. 在队列末尾插入data1 head->1->NULL */
	struct _Data *data1 = (struct _Data *)calloc(1, sizeof(struct _Data));	
	data1->value = 1;
	STAILQ_INSERT_TAIL(&head, data1, next);
	/* 3. 在队列末尾插入data2 head->1->2->NULL */
	struct _Data *data2 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data2->value = 2;
	STAILQ_INSERT_TAIL(&head, data2, next);
	/* 4. 在data1之后插入data3 head->1->3->2->NULL */
	struct _Data *data3 = (struct _Data *)calloc(1, sizeof(struct _Data));	
	data3->value = 3;
	STAILQ_INSERT_AFTER(&head, data1, data3, next);	
	/* 5. 在队列首部插入data4 head->4->1->3->2->NULL */
	struct _Data *data4 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data4->value = 4;	
	STAILQ_INSERT_HEAD(&head, data4, next);

	/* 遍历队列 */
	STAILQ_FOREACH(pdata, &head, next) {
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");
	
	/* 6. 删除data2 head->4->1->3->NULL */
	STAILQ_REMOVE(&head, data2, _Data, next);

	/* 遍历队列 */
	STAILQ_FOREACH(pdata, &head, next) {
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");

	exit(EXIT_SUCCESS);
}
