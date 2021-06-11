algorithm
关键字：编写程序流程 先写**.h 再写**.c 最后写main.c  (先分析需要的数据结构体)
	数据结构基本概念	
	顺序结构实现栈的基本操作

马如忠  marz@tedu.cn

数据结构
	栈 队列 链表 二叉树 图
算法
	两种查找算法 四种排序算法

cp arr_stack.c arr_stack.h 	//把arr_stack.c 复制到 arr_stack.h
cp ../arr_stack.c ./     	//把别的目录下的arr_stack.c 复制到当前目录下
mv arr_stack.c main.c		//重命名 把arr_stack.c重命名为main.c
rm *.gch			//删除所有 .gch文件  
				//.gch 就是.h只进行预处理和编译不链接所产生的文件


/*数据结构*/
数据结构就是指数据在计算机中的存储和组织形式，
	也就是一种或者多种特定关系的数据集合
数据结构的选择会直接影响到
	程序的执行效率(时间复杂度)和存储效率(空间复杂度)；
程序 = 数据结构 + 算法

数据结构的三个层次
	1. 逻辑结构：描述数据元素之间的逻辑关系
	2. 物理结构：描述数据元素在计算机中的存储形式，也就是位置关系 
	3. 运算结构：描述数据结构的实现方式以及基本特征

逻辑结构的分类
	1. 集合结构：描述所有数据元素都属于一个整体，不强调数据元素之间的关系；
	2. 线性结构：描述数据元素之间存在一对一的前后关系；
			有且只有唯一的首元素；
			有且只有唯一的尾元素；
			除首元素之外，每一个元素有且只有一个前趋元素；
			除尾元素之外，每一个元素有且只有一个后继元素；
	3. 树形结构：描述结构中的数据元素之间存在一对多的父子关系；
			存在唯一的根元素，也就是起始元素；
			顶端的元素叫做叶元素；
			除了根元素之外，结构中的每个元素有且只有一个前趋元素；
			除了叶元素之外，结构中的每个元素可以拥有一个或多个后继元素；
	4. 图形结构/网状结构：描述数据元素之间存在多对多的交叉映射结构；
			每个元素都可以有多个前趋和多个后继元素；
			任意两个元素之间都可以建立关联；

物理结构的分类
	1. 顺序结构：描述采用一组连续的存储单元依次存储逻辑上相邻的各个元素，
		    如果每个元素都具有相同的属性，则每个元素占用的存储空间相同；
			可以采用C语言中数组类型加以描述；
	       *数组的优点及缺点：
		   优点	a.支持下标访问，实现随机访问也比较方便
			b.除了申请存储数据元素本身之外的存储空间之外，
			  不需要额外的存储空间来表达数据元素之间的逻辑关系，
			  因此比较节省内存；
		   缺点	a.申请连续的存储空间时，需要预知元素的个数来确定存储空间的大小，
			  若太小则可能不够，若太大则可能造成浪费；
			b.要求申请连续的存储空间，导致小块空闲区域无法有效利用，
			  因此整个内存空间的利用率比较低；
			c.当插入/删除元素时，可能会导致大量数据元素的移动，
			  因此执行效率比较低；
	2. 链式结构：描述采用一组地址不连续的存储单元来依次存放各个元素，
		    不保证逻辑上相邻的元素在物理位置上也相邻；
			
			为每个元素构造一个节点，节点中的内容包括两部分：
			存储数据元素本身 + 记录下一个节点的首地址；
			
			该结构无法使用C语言中的数据类型加以描述，
			因此需要程序员手动编码去实现该结构；

		*链表的优点及缺点：
		   优点	a.不需要预知元素的个数,
			  而是使用动态内存为每一个元素构造节点或释放节点;
			b.不需要申请连续的存储空间，因此空间利用率比较高；
			c.插入/删除元素时比较方便，不需要移动其他元素的位置；
		   缺点	a.不支持下标访问，实现随机访问也不方便；
			b.除了申请存放数据元素本身的存储空间之外，
			  还需要申请额外的存储空间表达数据元素之间的逻辑关系，
			  也就是记录下一个节点的地址，因此比较消耗内存空间；

逻辑结构和物理结构之间关系
	每种逻辑结构采用何种物理结构来实现并没有具体的规定，
	通常根据实现的难易程度，以及在时间复杂度和空间复杂度等方面的考虑，来选择合适的物理结构，
	也不排除同一种逻辑结构需要使用多种物理结构实现的可能；

运算结构
	描述数据结构的创建.销毁.增删改查以及相关的算法使用。


/* 栈 stack */
栈就是一种具有后进先出特性的数据结构，简称为LIFO（last in first out）
	栈是只能在一端进行增删操作的数据结构，该位置叫做栈顶；
	栈属于逻辑结构中的线性结构；
栈的基本操作
	创建（stack_create）
	销毁（stack_destroy）
	判断是否为空（stack_empty）
	判断是否为满（stack_full）
	入栈（stack_push）
	出栈（stack_pop）
	查看栈顶元素值（stack_peek）
	计算栈中有效元素的个数（stack_size）
	遍历栈中所有元素（stack_travel）

使用顺序结构实现栈的基本操作

/*顺序结构实现栈的基本操作*/
#include<stdio.h>
#include<stdlib.h>

typedef struct {
	//int arr[5];//记录数据元素
	int *arr;//记录数据的首地址
	int len;//记录数组中可以存放的元素个数
	int pos;//记录数组的下标
}Stack;

//实现栈的创建
Stack *stack_create(int len);
//实现栈的销毁
void stack_destroy(Stack *ps);
//判断栈是否为空
int stack_empty(Stack *ps);
//判断栈是否为满
int stack_full(Stack *ps);
//入栈
void stack_push(Stack *ps,int i);
//出栈
void stack_pop(Stack *ps);
//查看栈顶元素值
void stack_peek(Stack *ps);
//计算栈中有效元素的个数
void stack_size(Stack *ps);
//遍历栈中所有元素
void stack_travel(Stack *ps);
//清空栈中元素
void stack_clean(Stack *ps);
int main()
{
	//创建栈，调用stack_create函数
	Stack *ps=stack_create(5);
	printf("%s\n",stack_empty(ps)?"栈已经空里":"栈没有空");
	printf("%s\n",stack_full(ps)?"栈已经满了":"栈没有满");
	printf("----------------------------------------------\n");
	int i = 0;
	for(i=1;i<7;i++)
	{
		stack_push(ps,i*10+i);
		stack_travel(ps);
	}
	printf("-----------------------------------------------\n");
	stack_peek(ps);
	stack_size(ps);
	printf("--------------------------------------------------\n");
	stack_pop(ps);
	stack_peek(ps);
	stack_size(ps);
	stack_travel(ps);
	printf("-------------------------------------------------------\n");
	stack_clean(ps);
	stack_travel(ps);
	/*stack_push(ps,53);
	stack_push(ps,20);
	stack_travel(ps);
	stack_pop(ps);
	stack_travel(ps);
	stack_push(ps,99);
	stack_travel(ps);
	stack_peek(ps);
	stack_size(ps);*/
	

	//销毁栈，调用stack_destroy函数
	stack_destroy(ps);
	ps=NULL;
	
	return 0;
}

Stack *stack_create(int len)
{
	//1.创建栈
	//Stack stack;//局部变量
	//return &stack;//永远不要返回局部变量的地址 (局部变量可以返回存储到其他地址)
	//使用static关键字进行修饰//无法手动释放
	Stack *ps=(Stack*)malloc(sizeof(Stack));
	if(NULL==ps)
	{
		printf("创建栈失败，程序结束\n");
		exit(-1);//异常终止整个程序
	}
	//2.初始化栈中的所有成员
	ps->arr=(int*)malloc(sizeof(int)*len);
	if(ps->arr==NULL)
	{
		printf("准备数组失败，程序结束\n");
		exit(-1);
	}
	ps->len=len;
	ps->pos=0;
	//3.返回栈的首地址
	return ps;
}

void stack_destroy(Stack *ps)
{
	free(ps->arr);
	ps->arr=NULL;
	free(ps);
	ps=NULL;
}

int stack_empty(Stack *ps)
{
	return ps->pos==0;
}

int stack_full(Stack *ps)
{
	return ps->pos==ps->len;
}
//入栈
void stack_push(Stack *ps,int i)
{
	if(stack_full(ps))
	{
		printf("栈已满，无法入栈,元素%d入栈失败\n",i);
		return;
		//exit(0); 结束整个程序
	}
	int j=0;
	j=ps->pos;
	*(ps->arr+j)=i; // ps->arr[ps->pos]=i; 这样也可以
	ps->pos++;
	printf("入栈成功\n");
}
//出栈
void stack_pop(Stack *ps)
{
	if(ps->pos==0)
	{
		printf("栈已空，无法出栈\n");
		return;
	}
	printf("出栈成功,%d已出栈\n",ps->arr[--ps->pos]);
}
//查看栈顶元素值
void stack_peek(Stack *ps)
{
	if(ps->pos==0)
	{
		printf("栈为空，无法查看栈顶元素\n");
		return;
	}
	printf("栈顶元素为%d\n",ps->arr[ps->pos-1]);
}
//计算栈中有效元素的个数
void stack_size(Stack *ps)
{
	printf("有效元素的个数为%d\n",ps->pos);
}

//遍历栈中所有元素
void stack_travel(Stack *ps)
{
	int i=0;
	for(i=0;i<ps->pos;i++)
	{
		printf("第%d个元素为%d ",i+1,*(ps->arr+i));//ps-arr[i]这样也行
	}
	printf("\n");
}
//清空栈中元素
void stack_clean(Stack *ps)
{
	ps->pos=0;
	printf("栈已清空\n");
}

	









