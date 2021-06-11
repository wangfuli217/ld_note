关键字：queue

/*队列 queue*/
队列就是一种具有先进先出特性的数据结构，简称为FIFO（first in first out）
	队列是一种可以在两端进行增删操作的数据结构，
	其中插入元素的端点叫做后端，也就是队尾；
	其中删除元素的端点叫做前端，也就是队首/队头；
	队列属于逻辑结构中的线性结构；

队列的基本操作
	创建（queue_create）
	销毁（queue_destroy）
	判断队列是否为空（queue_empty）
	判断队列是否为满（queue_full）
	入队（queue_push）
	遍历队列中所有有效元素（queue_travel）
	计算队列中有效元素的个数（queue_size）
	查看队列中队首元素值（queue_front）
	查看队列中队尾元素值（queue_back）
	出队（queue_pop）
	清空队列中所有元素（queue_clear）

使用顺序结构实现队列的基本操作
/*使用顺序结构实现队列*/
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

typedef struct{
	int *arr; //记录数组的首地址
	int len;//记录数组中最多存储的元素的个数
	int front;//记录队列中队首元素的个数
	int cnt;//记录有效元素的个数
}Queue;

//创建
Queue *queue_create(int len);
//销毁
void queue_destroy(Queue *pq);
//队列是否为空
bool queue_empty(Queue *pq);
//队列是否为满
bool queue_full(Queue *pq);
//入列
void queue_push(Queue *pq,int data);
//遍历队列有效元素
void queue_travel(Queue *pq);
//计算有效元素个数
int queue_size(Queue *pq);
//查看队首元素
void queue_front(Queue *pq);
//查看队尾元素
void queue_back(Queue *pq);
//出队
void queue_pop(Queue *pq);
//清空队列
void queue_clear(Queue *pq);

int main()
{
	Queue *pq=queue_create(5);
	
	printf("%s\n",queue_empty(pq)?"队列已经空了":"队列没有空");
	printf("%s\n",queue_full(pq)?"队列已经满了":"队列没有满");
	printf("有效元素的个数%d\n",queue_size(pq));
	printf("----------------------------------------------\n");
	int i=0;
	for(i=1;i<7;i++)
	{
		queue_push(pq,i*10+i);
		queue_travel(pq);
	}
	printf("有效元素的个数%d\n",queue_size(pq));
	printf("----------------------------------------------\n");
	queue_front(pq);
	queue_back(pq);
	queue_pop(pq);
	queue_pop(pq);
	printf("有效元素的个数%d\n",queue_size(pq));
	queue_travel(pq);
	queue_clear(pq);
	queue_travel(pq);

	queue_destroy(pq);
	pq=NULL;
	return 0;
}

//创建
Queue *queue_create(int len)
{
	Queue *pq=(Queue*)malloc(sizeof(Queue));
	if(pq==NULL)
	{
		printf("创建队列失败，程序结束\n");
		exit(-1);
	}
	pq->arr=NULL;
	pq->len=len;
	pq->front=0;
	pq->cnt=0;
	int *arr=(int*)malloc(sizeof(int)*len);
	if(arr==NULL)
	{
		printf("创建数组失败，程序结束\n");
		exit(-1);
	}
	pq->arr=arr;
	return pq;

}
//销毁
void queue_destroy(Queue *pq)
{
	free(pq->arr);
	pq->arr=NULL;// 必须先free最内部的 再是外部的 要不然段错误
	free(pq);
	pq=NULL;
}
//队列是否为空
bool queue_empty(Queue *pq)
{
	return pq->cnt==0;
}
//队列是否为满
bool queue_full(Queue *pq)
{
	return pq->len==pq->cnt;
}
//计算有效元素个数
int queue_size(Queue *pq)
{
	return pq->cnt;
}
//入列
void queue_push(Queue *pq,int data)
{
	if(queue_full(pq))
	{
		printf("队列已满，无法入队\n");
		return;
	}
	pq->arr[(pq->front + pq->cnt)%pq->len]=data;
	pq->cnt++;
}
//遍历队列有效元素
void queue_travel(Queue *pq)
{
	if(queue_empty(pq))
	{
		printf("队列为空\n");
		return;
	}
	printf("队列中元素有：");
	int i=0;
	for(i=pq->front;i<pq->cnt+pq->front;i++)
	{
		printf("%d ",pq->arr[i%pq->len]);
	}
	printf("\n");

}
//查看队首元素
void queue_front(Queue *pq)
{
	if(queue_empty(pq))
	{
		printf("查看队首元素失败\n");
		return;
	}
	printf("队首元素：%d\n",pq->arr[pq->front%pq->len]);
}
//查看队尾元素
void queue_back(Queue *pq)
{
	if(queue_empty(pq))
	{
		printf("查看队尾元素失败\n");
		return;
	}
	printf("队尾元素:%d\n",pq->arr[(pq->front+pq->cnt-1)%pq->len]);//还要减一
}
//出队
void queue_pop(Queue *pq)
{
	if(queue_empty(pq))
	{
		printf("队列已空，出队失败\n");
		return;
	}
	printf("元素%d出队\n",pq->arr[pq->front%pq->len]);
	pq->front++;
	pq->cnt--;
}
//清空队列
void queue_clear(Queue *pq)
{
	pq->front=0;
	pq->cnt=0;
}


使用链式结构实现队列的基本操作
/*使用链式结构实现队列*/
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

typedef struct node{
	int data;//记录数据元素本身
	struct node *next;//记录下一个节点的地址
}Node;

typedef struct{
	Node *head;//记录第一个节点的地址
	Node *tail;//记录最后一个节点的地址
	int cnt;
}Queue;

//创建
Queue *queue_create(void);
//销毁
void queue_destroy(Queue *pq);
//队列是否为空
bool queue_empty(Queue *pq);
//队列是否为满
bool queue_full(Queue *pq);
//入队
void queue_push(Queue *pq,int data);
//遍历所有元素
void queue_travel(Queue *pq);
//计算有效元素个数
void queue_size(Queue *pq);
//查看队首元素
void queue_head(Queue *pq);
//查看队尾元素
void queue_tail(Queue *pq);
//出队
void queue_pop(Queue *pq);
//清空队
void queue_clear(Queue *pq);

int main()
{	
	Queue *pq=queue_create();
	
	printf("%s\n",queue_empty(pq)?"队列已经空了":"队列没有空");
	printf("%s\n",queue_full(pq)?"队列满了":"队列没有满");
	queue_size(pq);
	int i=0;
	for(i=1;i<7;i++)
	{
		queue_push(pq,i*10+i);
	}
	queue_pop(pq);
	queue_pop(pq);
	queue_pop(pq);
	queue_pop(pq);
	queue_pop(pq);
	queue_pop(pq);
	queue_travel(pq);
	queue_size(pq);
	queue_head(pq);
	queue_tail(pq);
	queue_clear(pq);
	queue_travel(pq);
	queue_destroy(pq);
	pq=NULL;
	return 0;
}

//创建
Queue *queue_create(void)
{
	Queue *pq=(Queue*)malloc(sizeof(Queue));
	if(NULL==pq)
	{
		printf("创建队失败，程序结束\n");
		exit(-1);
	}
	pq->head=NULL;
	pq->tail=NULL;
	pq->cnt=0;
	return pq;
}
//销毁
void queue_destroy(Queue *pq)
{
	free(pq);
	pq=NULL;
}
//队列是否为空
bool queue_empty(Queue *pq)
{
	return pq->head==NULL;
}
//队列是否为满
bool queue_full(Queue *pq)
{
	return false;
}
//计算有效元素个数
void queue_size(Queue *pq)
{
	/*int cnt=0;
	Node *pt=pq->head;
	while(pt!=NULL)
	{
		cnt++;
		pt=pt->next;	//挨个数的方式计算有效元素个数
	}
	*/
	printf("有%d个有效元素\n",pq->cnt);
}
//入队
void queue_push(Queue *pq,int data)
{
	Node *pd=(Node*)malloc(sizeof(Node));
	if(NULL==pd)
	{
		printf("创建元素失败\n");
		return;
	}
	
	pd->data=data;

	//当队列为空时，直接让head指向新节点
	if(queue_empty(pq))
	{
		pq->head=pd;	
	}
	else
	{
	/*Node *pt=pq->head;
	while(pt->next!=NULL)//当队列不为空，先找到最后一个节点
		pt=pt->next;
	pt->next=pd;	//让最后一个节点的next指向新节点*/

		pq->tail->next=pd;
	}
	pq->tail=pd;
	pd->next=NULL;
	pq->cnt++;


}
//遍历所有元素
void queue_travel(Queue *pq)
{
	if(queue_empty(pq))
	{
		printf("队列中的元素为零\n");
		return;
	}
	printf("队列中元素：");
	Node *pt=pq->head;
	while(pt!=NULL)
	{	
		printf("%d ",pt->data);
		pt=pt->next;
	}
	printf("\n");
}
//查看队首元素
void queue_head(Queue *pq)
{
	if(queue_empty(pq))
	{
		return;
	}
	printf("队首元素：%d\n",pq->head->data);
}
//查看队尾元素
void queue_tail(Queue *pq)
{
/*	Node *pt=pq->head;
	while(pt->next!=NULL)
		pt=pt->next;
	printf("队尾元素：%d\n",pt->data);*/
	if(queue_empty(pq))
	{
		return;
	}
	printf("队尾元素：%d\n",pq->tail->data);
}
//出队
void queue_pop(Queue *pq)
{
	if(queue_empty(pq))
	{
		printf("队列已为空\n");
		return;
	}
	Node *pt=pq->head;
	pq->head=pt->next;
	if(NULL==pq->head)
	{
		pq->tail=NULL;
	}
	
	
	printf("出队元素：%d\n",pt->data);
	
	pq->cnt--;
	free(pt);
	pt=NULL;
}
//清空队
void queue_clear(Queue *pq)
{
	pq->head=NULL;
	pq->tail=NULL;

}

实际应用
	可以用于打印机打印任务控制，银行取号系统

