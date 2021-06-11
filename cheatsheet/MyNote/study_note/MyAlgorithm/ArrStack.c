//使用顺序存储结构实现堆栈的基本操作
#include<stdio.h>

typedef int datatype;
//定义堆栈的数据类型
typedef struct
{
	datatype arr[5];	//存放具体的元素值
	int pos;	//记录数组的下标
}Stack;

//自定义函数实现入栈操作
void push(Stack *p_stack,int data)
{
	if(full(p_stack))
		printf("栈已满,入栈失败\n");
	else
		p_stack->arr[p_stack->pos++]=data;
}
void travel(Stack *p_stack)
{
	int i=0;
	if(empty(p_stack))
	{
		printf("栈是空的\n");
		return;
	}
	for(i=p_stack->pos-1;i>=0;i--)
		printf("%d ",p_stack->arr[i]);
	printf("\n");
}
int pop(Stack *p_stack)
{
	if(empty(p_stack))
	{
		printf("栈是空的\n");
		return -1;
	}
	return p_stack->arr[--p_stack->pos];
}
int peek(Stack *p_stack)
{
	if(empty(p_stack))
	{
		printf("栈是空的\n");
		return -1;
	}
	return p_stack->arr[p_stack->pos-1];
}
int full(Stack *p_stack)
{
	return 5==p_stack->pos;
}
int empty(Stack *p_stack)
{
	return 0==p_stack->pos;
}
int size(Stack *p_stack)
{
	return p_stack->pos;
}
int main(void)
{
	Stack stack={}; //创建一个栈
	push(&stack,1);
	push(&stack,2);
	push(&stack,3);
	push(&stack,4);
	push(&stack,5);
	printf("出栈的是%d\n",pop(&stack));
	printf("栈顶元素是%d\n",peek(&stack));
	printf("%s\n",full(&stack)?"堆栈已经满了":"堆栈没有满");
	printf("%s\n",empty(&stack)?"堆栈已经空了":"堆栈没有空");
	printf("堆栈中的元素个数是:%d\n",size(&stack));
	travel(&stack);
	return 0;
}
