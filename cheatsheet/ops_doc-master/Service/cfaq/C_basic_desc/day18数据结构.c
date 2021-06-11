关键字：链式结构实现栈的基本操作  实际应用

/*栈*/
使用链式结构实现栈的基本操作
/*链式结构实现栈的基本操作*/
#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

typedef struct node{
	int data;//记录数据元素本身
	struct node *next;//记录下一个节点的地址
}Node;

typedef struct{
	Node *top;//记录第一个节点的地址
	int cnt;//记录有效元素的个数
}Stack;

//创建栈
Stack* stack_create(void);
//销毁栈
void stack_destroy(Stack *ps);
//入栈
void stack_push(Stack *ps,int data);
//遍历栈中的所有元素
void stack_travel(Stack *ps);
//判断栈是否为空
bool stack_empty(Stack *ps);
//判断栈是否为满
bool stack_full(Stack *ps);
//查看栈顶元素值
void stack_peek(Stack *ps);
//实现计算栈中有效元素的个数
void stack_size(Stack *ps);
//出栈
int stack_pop(Stack *ps);
//清空栈
void stack_clean(Stack *ps);
int main(void)
{
	//创建栈 使用stack_create
	Stack *ps=stack_create();
	
	int i=0;
	for(i=1;i<7;i++)
	{
		stack_push(ps,i*10+i);
		stack_travel(ps);
	}
	printf("----------------------------------------\n");
	printf("%s\n",stack_empty(ps)?"栈已经空里":"栈没有空");
	printf("%s\n",stack_full(ps)?"栈已经满了":"栈没有满");
	stack_peek(ps);
	stack_size(ps);
	printf("------------------------------------------\n");
	printf("出栈的元素是%d\n",stack_pop(ps));
	stack_peek(ps);
	stack_size(ps);
	stack_travel(ps);
	printf("----------------------------------------------\n");
	stack_clean(ps);
	stack_size(ps);
	//stack_travel(ps);
	//销毁栈 使用stack_create
	stack_destroy(ps);
	ps=NULL;
	return 0;
}

Stack* stack_create(void)
{
	//1.创建栈
	Stack *ps=(Stack*)malloc(sizeof(Stack));
	if(NULL==ps)
	{
		printf("创建栈失败，程序结束\n");
		exit(-1);
	}
	//2.初始化栈中的成员
	ps->top=NULL;
	ps->cnt=0;
	//3.返回栈中的首地址
	return ps;
}

void stack_destroy(Stack *ps)
{
	free(ps);
	ps=NULL;
}

//入栈
void stack_push(Stack *ps,int data)
{
	//1.创建新节点，进行初始化
	Node *pn=(Node*)malloc(sizeof(Node));
	if(NULL==pn)
	{
		printf("创建新节点失败，程序结束\n");
		exit(-1);
	}
	pn->data=data;
	pn->next=NULL;
	//2.将节点插入到合适的位置
	pn->next=ps->top;
	ps->top=pn;
	//3.有效元素的个数加1
	ps->cnt++;
}
//遍历栈中的所有元素
void stack_travel(Stack *ps)
{
	Node *pt=ps->top; //指定临时指针代替top进行遍历
	printf("栈中元素有：");
	while(pt!=NULL)
	{
		printf("%d ",pt->data);
		pt=pt->next;
	}
	printf("\n");
}
//判断栈是否为空
bool stack_empty(Stack *ps)
{
	return NULL==ps->top;
}
//判断栈是否为满
bool stack_full(Stack *ps)
{
	return false;
}
//查看栈顶元素值
void stack_peek(Stack *ps)
{
	if(stack_empty(ps))
	{
		printf("查看栈顶元素失败\n");
		return;
	}
	printf("栈顶元素为%d\n",ps->top->data);
}
//实现计算栈中有效元素的个数
void stack_size(Stack *ps)
{
	/*Node *pn=ps->top;
	int i=0;
	while(pn!=NULL)
	{
		pn=pn->next;
		i++;
	}*/
	printf("有效元素的个数%d\n",ps->cnt);
}
//出栈
int stack_pop(Stack *ps)
{
	if(stack_empty(ps))
	{
		printf("栈已经空了，出栈失败");
		return -1;
	}
	Node *pt=ps->top;//使用临时指针记录要删除的节点地址
	int temp=ps->top->data;//使用临时变量记录要删除的节点元素值
	ps->top=ps->top->next;//使用top指向下一个节点
	free(pt);//释放节点的动态内存
	pt=NULL;
	ps->cnt--;//节点个数-1
	return temp;
}

//清空栈
void stack_clean(Stack *ps)
{
	while(-1!=stack_pop(ps));
}

 实际应用：
	主要用于小鼠走迷宫的游戏中
	用于后进先出的模式  用栈

























