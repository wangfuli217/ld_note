/*
   实现单链表的各种操作
   */
#include<stdio.h>
#include<stdlib.h>
typedef struct node
{
	int data;   //数据内容,可以是其他的数据类型
	struct node* next;  //下一个节点地址	
}Node;
//定义链表的数据类型
typedef struct
{
	Node *head; //头指针
	int cnt;	//记录节点的个数
}List;
//向链表的头结点插入新结点
void push_head(List *,int);
//创建新节点的功能函数
Node *create_node(int data);
//遍历链表的操作
void travel(List *);
//判断链表是否为空
int empty(List *);
//清空链表中的所有节点
void clear(List *);
//计算链表中节点的个数 
int size(List *);
//判断链表是否为满
int full(List *);
//向指定的位置插入指定的新节点
void insert(List *,int,int);
//向链表的尾部插入新的节点
void push_tail(List *pl,int data);
//删除链表中指定下标的结点
void del(List *pl,int pos);
//删除链表中指定下标的结点
void del(List *pl,int pos)
{
	//判断坐标是否合法
	if(pos<0||pos>=pl->cnt)
		return;
	//当删除头结点时
	if(pos==0)
	{
		Node *pt=pl->head;
		pl->head=pl->head->next;
		free(pt);
		pl->cnt--;
		pt=NULL;
		return;
	}
	//当删除其他结点时
	Node *pt=pl->head;
	while(--pos)
		pt=pt->next;
	Node *q=pt->next;
	pt->next=pt->next->next;
	free(q);
	pl->cnt--;
	pt=NULL;
}
//向链表的尾部插入新的节点
void push_tail(List *pl,int data)
{
	insert(pl,pl->cnt,data);
}
//创建新节点的功能函数
Node *create_node(int data)
{
	Node *pt=(Node *)malloc(sizeof(Node));
	pt->data=data;
	pt->next=NULL;
	return pt;
}
//向指定的位置插入指定的新节点
void insert(List *pl,int pos,int num)
{
	//判断pos坐标是否合法
	if(pos<0||pos>pl->cnt)
	{
		//printf("插入坐标不合法,插入新节点失败\n");
		//return;
		//pos=0;  //默认头插
		pos=pl->cnt; //默认尾插
	}
	//创建新节点
	Node *pt=create_node(num);
	//当向头节点插入节点时
	if(0==pos)
	{
		pt->next=pl->head;
		pl->head=pt;
		pl->cnt++;
		return;
	}
	//当向其他位置插入新节点时
	Node *p=pl->head;
	while(--pos)
	{
		p=p->next;
	}
	pt->next=p->next;
	p->next=pt;
	pl->cnt++;
}
//判断链表是否为满
int full(List *pl)
{
	return  -1;
}
//计算链表中节点的个数 
int size(List *pl)
{
	return pl->cnt;
}
//清空链表中的所有节点
void clear(List *pl)
{
	Node *pt=pl->head;
	while(pt)
	{
		pl->head=pl->head->next;
		free(pt);
		pt=pl->head;
	}
	pl->cnt=0;
	pt=NULL;
}
//判断链表是否为空
int empty(List * pl)
{
	return pl->head?0:1;
}
//遍历链表的操作
void travel(List *pl)
{
	//判断是否为空
	if(empty(pl))
		return ;
	Node *pt=pl->head;
	while(pt)
	{
		printf("%d ",pt->data);
		pt=pt->next;
	}
	printf("\n");
	printf("链表内元素的个数为:%d\n",pl->cnt);
	pt=NULL;
}
//向链表的头结点插入新结点
void push_head(List * pl,int data)
{
	insert(pl,0,data);
}
int main()
{
	List list={}; //创建链表并且进行初始化
	push_head(&list,1);
	push_head(&list,2);
	printf("%s\n",empty(&list)?"链表是空的":"链表不是空的");
	push_head(&list,3);
	travel(&list);
	printf("元素的个数是:%d\n",size(&list));
	push_head(&list,4);
	push_head(&list,5);
	travel(&list);
	printf("----------------------------------------------------\n");
	travel(&list);
	insert(&list,-2,44);
	travel(&list);
	insert(&list,0,55);
	push_tail(&list,38);
	travel(&list);
	printf("删除后\n");
	del(&list,1);
	travel(&list);
	insert(&list,3,8);
	travel(&list);
	clear(&list);
	travel(&list);
	return 0;
}
