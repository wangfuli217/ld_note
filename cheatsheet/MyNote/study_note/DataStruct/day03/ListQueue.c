#include<stdio.h>
#include<stdlib.h>
typedef struct node
{
	int data;
	struct node *next;
}node;
typedef struct
{
	node *head; //保存第一个节点地址
	node *tail; //保存最后一个节点地址
}QUEUE;
//函数声明
void push(QUEUE *,int);
void travel(QUEUE *);
void rea(QUEUE *);
int pop(QUEUE *);
int empty(QUEUE*);
int peek(QUEUE*);
int tail(QUEUE*);
int size(QUEUE*);

int size(QUEUE *p_q)
{
	int size=0;
	node *p_t=p_q->head;
	while(p_t)
	{
		p_t=p_t->next;
		size++;
	}
	p_t=NULL;
	return size;
}

int tail(QUEUE *p_q)
{
	if(empty(p_q))
		return -1;
	return p_q->tail->data;
}
int peek(QUEUE *p_q)
{
	if(empty(p_q))
		return -1;
	return p_q->head->data;
}

int empty(QUEUE* p_q)
{
	return p_q->head?0:1;
}

int pop(QUEUE *p_q)
{
	
	{
		printf("队列是空的\n");
			return -1;
	}
	int temp=p_q->head->data;
	node *p_t=p_q->head->next;
	free(p_q->head);
	p_q->head=p_t;
	return temp;
}

void rea(QUEUE *p_q)
{
	node *p_t=p_q->head;
	while(p_t)
	{
		p_q->head=p_t->next;
		free(p_t);
		p_t=p_q->head;
	}
	p_t=NULL;
}
void travel(QUEUE *p_q)
{
	node *p_t=p_q->head;
	if(empty(p_q))
	{
		printf("队列是空的\n");
		return ;
	}
	printf("队列中的元素有:");
	while(p_t)
	{
		printf("%d ",p_t->data);
		p_t=p_t->next;
	}
	printf("\n");
	p_t=NULL;
}
void push(QUEUE *p_q,int data)
{
	node *p_t=(node *)malloc(sizeof(node));
	p_t->data=data;
	p_t->next=NULL;
	if(!p_q->head)
		p_q->head=p_q->tail=p_t;
	else
	{
		p_q->tail->next=p_t;
		p_q->tail=p_t;
	}
	p_t=NULL;
}
int main(void)
{
	QUEUE queue={};
	push(&queue,1);
	printf("%s\n",empty(&queue)?"队列是空的":"队列不是空的");
	push(&queue,2);
	push(&queue,3);
	printf("出队列的是:%d\n",pop(&queue));
	push(&queue,4);
	push(&queue,5);
	push(&queue,6);
	travel(&queue);
	printf("队首元素是:%d\n",peek(&queue));
	printf("队尾元素是:%d\n",tail(&queue));
	printf("队列的长度是:%d\n",size(&queue));
	rea(&queue);
	return 0;
}
