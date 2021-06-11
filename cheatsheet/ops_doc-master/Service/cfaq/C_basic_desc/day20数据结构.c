关键字：list   画图找规律之后 再写代码

/*链表 list*/
链表：由若干个地址不连续的节点序列组成，
	不同的节点之间彼此通过指针连接组成的数据结构

链表基本分类
	1. 单项线性链表
		每个节点中除了存储数据元素本身之外，
		还需要保存下一个节点地址的指针，叫做后指针；
		
		链表中第一个节点叫做头节点，指向头节点的指针叫做头指针；

		链表中最后一个节点叫做尾节点，指向尾节点的指针叫做尾指针；

		尾节点中的后指针是一个空指针；
	
	2. 单向循环链表
		与单项线性链表类似，
		所不同的是让尾节点的后指针指向头节点，首尾相接构成环状结构；

	3. 双向线性链表
		每个节点中除了存储数据元素本身之外，还需要两个指针；
		其中一个用于记录下一个节点的地址，叫做后指针；next
		另外一个用于记录前一个节点的地址，叫做前指针；prev

		头节点中的前指针和尾节点中的后指针都是空指针；

	4. 双向循环链表
		与双向线性链表类似，
		所不同的是让尾节点的后指针指头节点，让头节点的前指针指向尾节点，
		首尾相接构成环状结构；

	5. 数组链表
		链表中的每一个元素都是一个数组，也就是由数组构成的链表；
	
	6. 链表数组
		字符数组：数组中的每一个元素都是一个字符；
		整型数组：数组中的每一个元素都是一个整数；
		结构体数组：数组中的每一个元素都是一个结构体；
		指针数组：数组中的每一个元素都是一个指针；
		链表数组；数组中的每一个元素都是一个链表；

	7. 二维链表
		二维数组：数组中的每一个元素都是一个一维数组
		int arr[2][3]={{1,2,3},{4,5,6}}
		
		二维链表：链表中的每个元素都是一个一维链表

扩展：
   a.实现返回单链表中中间节点的元素值；
   b.实现闭环/开环的基本操作；
   c.实现单链表中所有节点元素值的排序(从小到大)；
   d.实现将两个有序单链表合并成一个有序单链表；
   e.实现逆转单链表中所有节点的次序以及逆序打印所有节点元素

编程实现单向线性链表的各种基本操作（重中之重）
//编程实现单链表的各种基本操作
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

//定义节点的数据类型
typedef struct node
{
	int data;//记录数据元素本身
	struct node* next;//记录下一个节点的地址
}Node;

//定义单链表的数据类型
typedef struct
{
	Node* head;//记录头节点的地址
	Node* tail;//记录尾节点的地址
	int cnt;//记录有效元素的个数
}List;

//实现单链表的创建
List* list_create(void);
//实现单链表的销毁
void list_destroy(List* pl);
//实现判断单链表是否为空list_empty bool
bool list_empty(List* pl);
//实现判断单链表是否为满list_full  bool
bool list_full(List* pl);
//实现计算单链表中有效元素的个数list_size
int list_size(List* pl);
//实现插入新元素到单链表开头位置
void list_push_head(List* pl,int data);
//遍历单链表中所有有效元素
void list_travel(List* pl);
//实现新节点的创建
Node* node_create(int data);
//实现插入新元素到单链表末尾位置
void list_push_tail(List* pl,int data);
//实现插入新元素到指定坐标位置
void list_push_pos(List* pl,int data,int pos);
//实现查看头节点元素值 list_get_head
int list_get_head(List* pl);
//实现查看尾节点元素值 list_get_tail
int list_get_tail(List* pl);
//实现删除头节点的元素 list_pop_head
int list_pop_head(List* pl);
//实现删除尾节点的元素
int list_pop_tail(List* pl);
//实现删除指定编号的元素
int list_pop_pos(List* pl,int pos);
//实现清空单链表中的所有节点
void list_clear(List* pl);

int main(void)
{
	//创建单链表，使用list_create函数
	List* pl = list_create();

	printf("%s\n",list_empty(pl)?"单链表已经空了":"单链表没有空"); // 单链表已经空了
	printf("%s\n",list_full(pl)?"单链表已经满了":"单链表没有满"); // 单链表没有满
	printf("单链表中有效元素的个数是：%d\n",list_size(pl)); // 0

	printf("----------------------------------\n");
	int i = 0;
	for(i = 1; i < 7; i++)
	{
		list_push_head(pl,i*10+i);
		// 66 55 44 33 22 11
		list_travel(pl);
	}
	printf("单链表中有效元素的个数是：%d\n",list_size(pl)); // 6

	printf("-----------------------------------\n");
	list_push_tail(pl,77);
	list_travel(pl);// 66 55 44 33 22 11 77
	printf("单链表中有效元素的个数是：%d\n",list_size(pl)); // 7

	printf("-----------------------------------\n");
	list_push_pos(pl,88,-2); // 插入元素88失败
	list_travel(pl);//66 55 44 33 22 11 77
	list_push_pos(pl,88,0);
	list_travel(pl);//88 66 55 44 33 22 11 77
	list_push_pos(pl,99,2);
	list_travel(pl);//88 66 99 55 44 33 22 11 77
	list_push_pos(pl,111,8);
	// 88 66 99 55 44 33 22 11 111 77
	list_travel(pl);
	list_push_pos(pl,222,10);
	// 88 66 99 55 44 33 22 11 111 77 222
	list_travel(pl);
	printf("单链表中有效元素的个数是：%d\n",list_size(pl));// 11

	printf("----------------------------------\n");
	printf("单链表中头节点的元素是：%d\n",list_get_head(pl)); // 88
	printf("单链表中尾节点的元素是：%d\n",list_get_tail(pl)); // 222
	printf("单链表中删除的头节点元素是：%d\n",list_pop_head(pl)); // 88
	printf("单链表中有效元素的个数是：%d\n",list_size(pl)); // 10
	// 66 99 55 44 33 22 11 111 77 222
	list_travel(pl);

	printf("--------------------------------\n");
	printf("单链表中删除的尾节点元素是：%d\n",list_pop_tail(pl)); // 222
	printf("单链表中尾节点的元素值是：%d\n",list_get_tail(pl)); // 77
	printf("单链表中有效元素的个数是：%d\n",list_size(pl)); // 9
	// 66 99 55 44 33 22 11 111 77
	list_travel(pl);

	printf("----------------------------------\n");
	printf("单链表中删除的节点元素是：%d\n",list_pop_pos(pl,-2)); // -1
	printf("单链表中删除的节点元素是：%d\n",list_pop_pos(pl,0)); // 66
	printf("单链表中删除的节点元素是：%d\n",list_pop_pos(pl,2)); // 44
	printf("单链表中删除的节点元素是：%d\n",list_pop_pos(pl,6)); // 77
	printf("单链表中头节点元素是：%d\n",list_get_head(pl)); // 99
	printf("单链表中尾节点元素是：%d\n",list_get_tail(pl)); // 111
	printf("单链表中有效元素的个数是：%d\n",list_size(pl)); // 6
	list_travel(pl); // 99 55 33 22 11 111
	
	printf("---------------------------------\n");
	list_clear(pl);
	list_travel(pl); // 啥也没有

	//销毁单链表，使用list_destroy函数
	list_destroy(pl);
	pl = NULL;
	return 0;
}

//实现清空单链表中的所有节点
void list_clear(List* pl)
{
	while(-1 != list_pop_head(pl));
}

//实现删除指定编号的元素
int list_pop_pos(List* pl,int pos)
{
	//1.判断坐标的合法性
	if(pos < 0 || pos >= list_size(pl))
	{
		//printf("坐标不合法，元素删除失败\n");
		return -1;
	}
	//2.当pos=0时，相当于删除头节点
	if(0 == pos)
	{
		return list_pop_head(pl);
	}
	//3.当pos=list_size(pl)-1时，相当于删除尾节点
	else if(list_size(pl)-1 == pos)
	{
		return list_pop_tail(pl);
	}
	//4.当pos=pos时，采用归纳法来删除指定节点
	else
	{
		//使用临时指针作为head的替身
		Node* pt = pl->head;
		//使用循环将相对于pos=1时多出来的next执行完
		int i = 0;
		for(i = 1; i < pos; i++)
		{
			pt = pt->next;
		}
		//编写pos = 1时的具体操作代码
		Node* pm = pt->next;
		pt->next = pm->next;
		//使用临时变量记录要删除节点的元素值
		int temp = pm->data;
		//释放节点的动态内存
		free(pm);
		pm = NULL;
		//节点个数减1
		pl->cnt--;
		//返回已经删除的节点元素值
		return temp;
	}
}

//实现删除尾节点的元素
int list_pop_tail(List* pl)
{
	//当单链表为空时，删除节点失败
	if(list_empty(pl))
	{
		return -1;//表示删除节点失败
	}
	//当单链表中只有一个节点时的处理
	else if(1 == list_size(pl))
	{
		//指定临时变量记录要删除节点的地址
		int temp = pl->head->data;
		//释放节点的动态内存
		free(pl->head);
		pl->head = NULL;
		//将tail指针也置为空指针
		pl->tail = NULL;
		//节点个数 为0
		pl->cnt = 0;
		//返回已经删除的节点元素值
		return temp;
	}
	//当单链表中至少有两个节点时的处理
	else
	{
		//指定临时指针作为head的替身
		Node* pt = pl->head;
		//使用循环找到倒数第二个节点的地址
		while(pt->next->next != NULL)
		{
			//指向下一个节点
			pt = pt->next;
		}
		//使用临时变量记录要删除的节点元素
		int temp = pl->tail->data;
		//让tail指针指向倒数第二个节点
		pl->tail = pt;
		//释放尾节点，并置为空指针
		free(pt->next);
		pt->next = NULL;
		//节点个数减 1
		pl->cnt--;
		//返回已经删除节点的元素值
		return temp;
	}
}

//实现查看头节点元素值 list_get_head
int list_get_head(List* pl)
{
	//判断单链表是否为空
	if(list_empty(pl))
	{
		return -1;//表示查看失败
	}
	return pl->head->data;
}

//实现查看尾节点元素值 list_get_tail
int list_get_tail(List* pl)
{
	//判断单链表是否为空
	if(list_empty(pl))
	{
		return -1;//表示查看失败
	}
	return pl->tail->data;
}

//实现删除头节点的元素 list_pop_head
int list_pop_head(List* pl)
{
	//判断单链表是否为空
	if(list_empty(pl))
	{
		return -1;//表示删除失败
	}
	//使用临时指针记录要删除节点的地址
	Node* pt = pl->head;
	//让head指针指向下一个节点
	pl->head = pt->next;
	//处理当单链表中只有一个节点的情况
	if(NULL == pl->head)
	{
		pl->tail = NULL;
	}
	//使用临时变量记录要删除节点的元素值
	int temp = pt->data;
	//释放节点的动态内存
	free(pt);
	pt = NULL;
	//节点个数减1
	pl->cnt--;
	//返回删除节点中的元素值
	return temp;
}

//实现插入新元素到指定坐标位置
void list_push_pos(List* pl,int data,int pos)
{
	//1.判断坐标的合法性
	if(pos < 0 || pos > list_size(pl))
	{
		printf("坐标不合法，插入元素%d失败\n",data);
		return;//结束当前函数
		// pos = 0; //默认插入到开头位置
		// pos = list_size(pl); //默认插入到末尾
	}
	//2.当pos=0时，新元素插入到开头位置
	if(0 == pos)
	{
		list_push_head(pl,data);
	}
	//3.当pos=cnt时，新元素插入到末尾位置
	else if(list_size(pl) == pos)
	{
		list_push_tail(pl,data);
	}
	//4.当pos=pos时，采用归纳法插入到中间位置
	else
	{
		//创建新节点，并且进行初始化
		Node* pn = node_create(data);
		if(NULL == pn)
		{
			printf("创建新节点失败，函数结束\n");
			return;
		}
		//使用循环将相对于pos=1时多出来的next执行完
		Node* pt = pl->head;
		int i = 0;
		for(i = 1; i < pos; i++)
		{
			pt = pt->next;//指向下一个节点
		}
		//编写pos=1时的处理代码即可
		pn->next = pt->next;
		pt->next = pn;
		//节点个数 加1
		pl->cnt++;
	}
}

//实现插入新元素到单链表末尾位置
void list_push_tail(List* pl,int data)
{
	//1.创建新节点，并初始化
	Node* pn = node_create(data);
	if(NULL == pn)
	{
		printf("创建新节点失败，函数结束\n");
		return;
	}
	//2.插入新节点到合适位置上
	if(list_empty(pl))
	{
		pl->head = pn;
	}
	else
	{
		pl->tail->next = pn;
	}
	pl->tail = pn;
	//3.节点个数加 1
	pl->cnt++;
}

//实现新节点的创建
Node* node_create(int data)
{
	Node* pn = (Node*)malloc(sizeof(Node));
	if(NULL == pn)
	{
		return NULL;//表示创建节点失败
	}
	pn->data = data;
	pn->next = NULL;
	return pn;
}

//实现插入新元素到单链表开头位置
void list_push_head(List* pl,int data)
{
	//1.创建新节点，并且进行初始化 node_create
	/*
	Node* pn = (Node*)malloc(sizeof(Node));
	if(NULL == pn)
	{
		printf("创建新节点失败，函数结束\n");
		return;
	}
	pn->data = data;
	pn->next = NULL;
	*/
	Node* pn = node_create(data);
	if(NULL == pn)
	{
		printf("创建新节点失败，函数结束\n");
		return;//结束当前函数
	}
	//2.插入新节点到合适的位置
	//2.1 当链表为空时，head和tail都指向新节点
	if(list_empty(pl))
	{
		pl->tail = pn;
	}
	//2.2 当链表不为空时，新节点指向原来头节点，head指向新节点
	else
	{
		pn->next = pl->head;
	}
	pl->head = pn;
	//3.节点个数 加1
	pl->cnt++;
}

//遍历单链表中所有有效元素
void list_travel(List* pl)
{
	printf("单链表中有效元素有：");
	Node* pt = pl->head;
	while(pt != NULL)
	{
		printf("%d ",pt->data);
		pt = pt->next;
	}
	printf("\n");
	
}

//实现判断单链表是否为空list_empty bool
bool list_empty(List* pl)
{
	return NULL == pl->head;
	//return 0 == pl->cnt;
	//return NULL == pl->tail;
}

//实现判断单链表是否为满list_full  bool
bool list_full(List* pl)
{
	return false;
}

//实现计算单链表中有效元素的个数list_size
int list_size(List* pl)
{
	return pl->cnt;
}

//实现单链表的创建
List* list_create(void)
{
	//1.创建单链表
	List* pl = (List*)malloc(sizeof(List));
	if(NULL == pl)
	{
		printf("创建单链表失败，程序结束\n");
		exit(-1);
	}
	//2.初始化单链表中的成员
	pl->head = NULL;
	pl->tail = NULL;
	pl->cnt = 0;
	//3.返回单链表的首地址
	return pl;
}

//实现单链表的销毁
void list_destroy(List* pl)
{
	free(pl);
	pl = NULL;
}



实际应用
	主要用于需要进行大量增删操作的场合中






















