#include<stdio.h>
typedef struct
{
	int data[5];  //存储元素的位置
	int front;  //记录队首元素的下标
	int rear; //下一个可以存放元素的下标
}QUEUE;
//函数声明
void push(QUEUE *,int);
void travel(const QUEUE *);
int peek(const QUEUE *);
int pop(QUEUE *);
int full(const QUEUE *);
int empty(const QUEUE *);
int tail(const QUEUE *);
int tail(const QUEUE *p_q)
{
	if(empty(p_q))
		return -1;
	return p_q->data[(p_q->rear-1)%5];
}
int empty(const QUEUE *p_q)
{
	return p_q->rear-p_q->front==0?1:0;
}
int full(const QUEUE *p_q)
{
	return p_q->rear-p_q->front==5?1:0;
}
int peek(const QUEUE *p_q)
{
	if(empty(p_q))
		return -1;
	return p_q->data[p_q->front%5];
}
int pop(QUEUE *p_q)
{
	//判断队列是否为空
	if(empty(p_q))
		return -1;
	return p_q->data[p_q->front++%5];
}
void travel(const QUEUE *p_q)
{
	int i=0;
	printf("队列中的元素有:");
	for(i=p_q->front;i<p_q->rear;i++)
		printf("%d ",p_q->data[i%5]);
	printf("\n");
}
void push(QUEUE *p_q,int data)
{
	//判断队列为满的情况
	if(full(p_q))
	{
		printf("队列已满\n");
		return;
	}
	p_q->data[p_q->rear++%5]=data;
}
int main(void)
{
	QUEUE queue={};  //创建队列，并且进行初始化
	push(&queue,1);
	push(&queue,2);
	push(&queue,3);
	push(&queue,4);
	push(&queue,5);
	push(&queue,5);
	printf("%s\n",full(&queue)?"队列是满的":"队列不是满的");
	printf("%s\n",empty(&queue)?"队列是空的":"队列不是空的");
	travel(&queue);
	printf("出队的是:%d\n",pop(&queue));
	printf("队首元素是:%d\n",peek(&queue));
	printf("队尾元素是:%d\n",tail(&queue));
	travel(&queue);
	return 0;
}
