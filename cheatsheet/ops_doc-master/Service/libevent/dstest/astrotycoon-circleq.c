#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>

struct _Data {
	int 					value;
	CIRCLEQ_ENTRY(_Data)	next;
};

int main(int argc, const char *argv[])
{
	/* 1. 初始化队列 */
#if 0
	CIRCLEQ_HEAD(head, _Data) 	head = CIRCLEQ_HEAD_INITIALIZER(head);
#else
	CIRCLEQ_HEAD(head, _Data)   head;
	CIRCLEQ_INIT(&head);
#endif
	struct _Data *pdata = NULL;

	/* 2. 在队列末尾插入data1 */
	struct _Data *data1 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data1->value = 1;
	CIRCLEQ_INSERT_TAIL(&head, data1, next);	
	/* 3. 在队列末尾插入data2 */
	struct _Data *data2 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data2->value = 2;
	CIRCLEQ_INSERT_TAIL(&head, data2, next);	
	/* 4. 在data1之后插入data3 */
	struct _Data *data3 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data3->value = 3;
	CIRCLEQ_INSERT_AFTER(&head, data1, data3, next);
	/* 5. 在data2之前插入data4 */
	struct _Data *data4 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data4->value = 4;
	CIRCLEQ_INSERT_BEFORE(&head, data2, data4, next);
	/* 6. 在队列首部插入data5 */
	struct _Data *data5 = (struct _Data *)calloc(1, sizeof(struct _Data));
	data5->value = 5;
	CIRCLEQ_INSERT_HEAD(&head, data5, next);
	
	/* 遍历队列 */
	CIRCLEQ_FOREACH(pdata, &head, next) {
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");

	/* 7. 删除data5 */
	CIRCLEQ_REMOVE(&head, data5, next);

	/* 正序遍历队列 */
	/* 方法一 */
	CIRCLEQ_FOREACH(pdata, &head, next) {
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");
	/* 方法二 */
	for (pdata = CIRCLEQ_FIRST(&head); pdata != (const void *)&head; pdata = CIRCLEQ_NEXT(pdata, next)) {
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");
	/* 方法三： 假设从data4开始遍历 */
	pdata = data4;
	printf("pdata->value = %d\n", pdata->value);
	while ((pdata = CIRCLEQ_LOOP_NEXT(&head, pdata, next)) != NULL) {
		if (pdata == data4)	break;
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");

	/* 逆序遍历队列 */
	/* 方法一 */
	CIRCLEQ_FOREACH_REVERSE(pdata, &head, next) {
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");
	/* 方法二：假设从data1开始逆向遍历 */
	pdata = data1;
	printf("pdata->value = %d\n", pdata->value);
	while ((pdata = CIRCLEQ_LOOP_PREV(&head, pdata, next)) != NULL) {
		if (pdata == data1)	break;
		printf("pdata->value = %d\n", pdata->value);
	}
	puts("");

	/* 方法三 */
	for (pdata = CIRCLEQ_LAST(&head); pdata != (const void *)&head; pdata = CIRCLEQ_PREV(pdata, next)) {
		printf("pdata->value = %d\n", pdata->value);
		CIRCLEQ_REMOVE(&head, pdata, next);
	}
	puts("");
	
	if (CIRCLEQ_EMPTY(&head)) {
		printf("the circle queue is empty now.\n");	
	}

	exit(EXIT_SUCCESS);
}

