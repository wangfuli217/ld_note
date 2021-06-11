#include<stdio.h>
#include<stdlib.h>
typedef struct node
{
	int data;
	struct node *p_next;
}node;
typedef struct
{
	node *head;
}Stack;
void push(Stack *,int);
void travel(Stack *);
void Rea(Stack *);
int pop(Stack *);
int empty(Stack *);
int empty(Stack *p_stack)
{
	return p_stack->head?0:1;
}
int pop(Stack *p_stack)
{
	if(empty(p_stack))
		return -1;
	node *p_temp=p_stack->head;
	p_stack->head=p_stack->head->p_next;
	return p_temp->data;
}
void Rea(Stack *p_stack)
{
	node *p_temp=p_stack->head->p_next;
	free(p_stack->head);
	while(p_temp)
	{
		p_stack->head=p_temp;
		p_temp=p_temp->p_next;
		free(p_stack->head);
	}
	p_stack->head=NULL;
	p_temp=NULL;
}
void push(Stack *p_stack,int data)
{
	node *p_n=(node *)malloc(sizeof(node));
	p_n->data=data;
	p_n->p_next=NULL;
	p_n->p_next=p_stack->head;
	p_stack->head=p_n;
}

void travel(Stack *p_stack)
{
	node *p_temp=NULL;
	p_temp=p_stack->head;
	while(p_temp)
	{
		printf("%d ",p_temp->data);
		p_temp=p_temp->p_next;
	}
	printf("\n");
}
int main(void)
{
	Stack stack={};
	push(&stack,1);
	push(&stack,2);
	push(&stack,3);
	push(&stack,4);
	push(&stack,5);
	printf("出栈的是%d\n",pop(&stack));
	printf("%s\n",empty(&stack)?"栈是空的":"栈不是空的");
	travel(&stack);
	Rea(&stack);
	return 0;
}
