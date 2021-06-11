#include <stdio.h>  
#include <stdlib.h>  
#include <sys/queue.h>  
  
struct _Data {  
	int                 value;  
	TAILQ_ENTRY(_Data)  tailq_entry;  
};  
  
int main(int argc, const char *argv[])  
{  
	/* 1. 初始化队列 */  
#if 0  
	TAILQ_HEAD(tailq_head, _Data)   head = TAILQ_HEAD_INITIALIZER(head);  
#else  
	TAILQ_HEAD(tailq_head, _Data)   head;  
	TAILQ_INIT(&head);  
#endif  
	struct _Data *pdata = NULL;  
  
	/* 2. 在队列末尾插入data1 */  
	struct _Data *data1 = (struct _Data *)calloc(1, sizeof(struct _Data));  
	data1->value = 1;  
	TAILQ_INSERT_TAIL(&head, data1, tailq_entry);  
	/* 3. 在队列末尾插入data2 */  
	struct _Data *data2 = (struct _Data *)calloc(1, sizeof(struct _Data));  
	data2->value = 2;  
	TAILQ_INSERT_TAIL(&head, data2, tailq_entry);  
	/* 4. 在data1之后插入data3 */  
	struct _Data *data3 = (struct _Data *)calloc(1, sizeof(struct _Data));  
	data3->value = 3;  
	TAILQ_INSERT_AFTER(&head, data1, data3, tailq_entry);  
	/* 5. 在data2之前插入data4 */  
	struct _Data *data4 = (struct _Data *)calloc(1, sizeof(struct _Data));  
	data4->value = 4;  
	TAILQ_INSERT_BEFORE(data2, data4, tailq_entry);  
	/* 6. 在队列首部插入data5 */  
	struct _Data *data5 = (struct _Data *)calloc(1, sizeof(struct _Data));  
	data5->value = 5;  
	TAILQ_INSERT_HEAD(&head, data5, tailq_entry);  
	/* 遍历队列 */  
	TAILQ_FOREACH(pdata, &head, tailq_entry) {  
		printf("pdata->value1 = %d\n", pdata->value);       
	}  
	puts("");  
	/* 7. 删除data5 */  
	TAILQ_REMOVE(&head, data5, tailq_entry);  
	free(data5);	/* TAILQ_REMOVE宏只是从队列中删除该节点，因此还需手动free */
  
	TAILQ_FOREACH(pdata, &head, tailq_entry) {  
		printf("pdata->value1 = %d\n", pdata->value);       
	}  
	puts("");  
  
	/* 正序遍历尾队列 */  
	/* 方法一 */  
	TAILQ_FOREACH(pdata, &head, tailq_entry) {  
		printf("pdata->value1 = %d\n", pdata->value);       
	}  
	puts("");  
	/* 方法二 */  
	for (pdata = TAILQ_FIRST(&head); pdata;   
					pdata = TAILQ_NEXT(pdata, tailq_entry)) {  
		printf("pdata->value1 = %d\n", pdata->value);       
	}  
  
	puts("");  
  
	/* 逆序遍历尾队列 */  
	/* 方法一 */  
	TAILQ_FOREACH_REVERSE(pdata, &head, tailq_head, tailq_entry) {  
		printf("pdata->value1 = %d\n", pdata->value);       
	}  
	puts("");  
	/* 方法二 */  
	for (pdata = TAILQ_LAST(&head, tailq_head); pdata;   
			pdata = TAILQ_PREV(pdata, tailq_head, tailq_entry)) {  
		printf("pdata->value1 = %d\n", pdata->value);       
		TAILQ_REMOVE(&head, pdata, tailq_entry);  
		free(pdata);  
	}  
  
	if (TAILQ_EMPTY(&head)) {  
		printf("the tail queue is empty now.\n");     
	}  
  
	exit(EXIT_SUCCESS);  
}  
