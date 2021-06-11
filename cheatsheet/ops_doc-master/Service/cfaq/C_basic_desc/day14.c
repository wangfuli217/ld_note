关键字：enum     union  二级指针 函数指针 回调函数 动态分配内存 malloc free

/* enum */
枚举也可以用来创建新的数据类型
枚举类型存储区就是一个整数类型存储区，
	这种存储区里应该只能记录几个有限的整数
声明枚举类型时需要提供一组名称，每个名称对应一个整数，
	这些整数才可以放到枚举类型存储区
声明枚举类型时需要使用 enum 关键字
枚举类型中第一个名字对应的整数是0，向后依次递增
可以在声明枚举类型时指定某个名称对应的数字，
	它后面的名称对应的数字也会随着改变
    enum /*season*/{SPRING,SUMMER,AUTUMN,WINTER};
                   

/* unino */
联合也可以用来创建新的数据类型
联合存储区可以当作多种不同类型存储区使用
声明联合的时候需要使用 union 关键字

	typedef union {
   	 char ch;
   	 int num;
	}un;
			定义一个联合变量 un un1；
联合中每个变量声明语句表示联合存储区的一种使用方法，
	所有子变量的存储区是互相重叠的
*联合存储区的大小是其中最大子变量存储区的大小

/* 二级指针 */
记录普通变量地址的指针叫做一级指针
二级指针可以记录一级指针的地址
二级指针声明的时候需要写两个*
	int num=0;
    	int *p_num=&num;
    	int **pp_num=&p_num;

二级指针变量名称前加**可以表示捆绑的
		普通变量存储区 		**pp_num=10;
二级指针变量名称前加*可以表示捆绑的		//一个* 抵一个p
		一级指针变量存储区   	*pp_num=NULL;
二级指针变量名称可以代表它自己的存储区


二级指针可以用来代表指针数组，但是不能代表二维数组
				二维数组名不占存储空间的

二级指针通常作为函数的形式参数使用，
	它可以让被调用函数修改调用函数的一级指针存储区内容
	(就像一级指针做形参，就是为了让被调用函数修改调用函数的普通变量)

#include<stdio.h>
void set_null(int **pp_num)
{
    *pp_num=NULL;
}
int main()
{
    int num=0;
    int *p_num=&num;
    set_null(&p_num);
    printf("p_num is %p\n",p_num);
    return 0;
}


无类型指针使用的时候有可能需要首先转换成二级指针然后再使用

/* 函数指针 */
C语言里函数也有地址
	函数指针用来记录函数的地址
	函数名称可以表示函数的地址
函数指针也需要先声明然后再使用

函数指针声明可以根据函数声明变化得到

函数指针也分类型，不同类型的函数指针适合与不同的函数捆绑

函数指针可以用来调用函数 （主要用法）

#include<stdio.h>
int add(int num,int num1)
{
    return num+num1;
}
int main()
{
    int (*p_func)(int,int)=NULL; // 函数指针声明
    printf("add is%p\n",add);   //函数名称可以表示函数地址
    p_func=add;  //就是属于地址给指针  捆绑了
    printf("结果是%d\n",p_func(4,9));
        
    return 0;
}

/* 函数指针做函数形参 回调函数 */
函数指针可以作为函数的形式参数使用

#include<stdio.h>
void print_cb(int *p_num)
{
    printf("%d ",*p_num);
}
void for_each(int *p_num,int size,void (*p_func)(int*))  //函数指针
{
    int num=0;
    for(num=0;num<=size-1;num++)
        p_func(p_num+num);
}
int main()
{
    int arr[]={1,2,3,4,5};
    for_each(arr,5,print_cb);	//回调函数
    printf("\n");
    return 0;
}

可以作为实际参数使用的函数叫做回调函数


/* 动态内存分配 */

malloc, free, calloc, realloc - Allocate and free dynamic memory

动态内存分配可以在程序运行的时候临时决定需要分配多少个存储区
为了使用动态分配内存需要使用一组标准函数
	为了使用这组标准函数需要包含stdlib.h头文件
malloc函数可以动态分配一组连续的字节
	这个函数需要一个整数类型参数表示要分配的字节个数（字节个数 不是存储区个数）
	返回值是分配好的第一个字节的地址
	如果分配失败返回的是 NULL
	这个函数的返回值存放在一个无类型指针存储区里，需要转换成有类型指针才能使用
void *malloc(size_t size);

不使用的动态分配内存必须还给计算机，
	这叫做内存释放
free函数可以用来释放动态分配内存
	这个函数需要动态分配内存的首地址作为参数
void free(void *ptr);

*一起分配的内存必须一起释放
如果用指针作为参数调用free函数则函数结束后指针成为野指针，
	必须恢复成空指针

/* 动态分配内存框架 */
#include<stdio.h>
#include<stdlib.h>
int main()
{
    int *p_num = (int*)malloc(5 * sizeof(int));
    if(p_num)
    {   
        //.....
        free(p_num);
        p_num = NULL;
    }   
    return 0;
}

/*调用函数可以使用被调用函数动态分配的内存*/

#include<stdio.h>
#include<stdlib.h>
int *read(void)
{
    int *p_num=(int*)malloc(sizeof(int));
    if(p_num)
    {   
        printf("输入一个整数：");
        scanf("%d",p_num);
    }   
    return p_num;
}
int main()
{
    int *p_num=read();
    if(p_num)
    {   
        printf("%d\n",*p_num);
        free(p_num);
        p_num=NULL;
    }   
    return 0;
}

/* 用动态分配内存 中点*/
#include<stdio.h>
#include<stdlib.h>
typedef struct {
    int row,col;
}pt;
pt *midpt(const pt *p_pt1,const pt *p_pt2)
{
    pt *p_pt= (pt *)malloc(sizeof(pt));
    if(p_pt)
    {   
        p_pt->row=(p_pt1->row+p_pt2->row)/2;
        p_pt->col=(p_pt1->col+p_pt2->col)/2;
    }   
    return p_pt;
}
int main()
{
    pt pt1={0},pt2={0};
    pt *p_pt=NULL;
    printf("输入一个点：");
    scanf("%d%d",&pt1.row,&pt1.col);
    printf("输入另一个点：");
    scanf("%d%d",&pt2.row,&pt2.col);
    p_pt=midpt(&pt1,&pt2);
    if(p_pt)
    {   
        printf("mid is(%d,%d)\n",p_pt->row,p_pt->col);
        free(p_pt);
        p_pt=NULL;
    }   
    return 0;
}


预习文件操作
作业：编写字符串拷贝函数（新字符串记录在动态分配内存里）
函数把新字符串传递给调用函数并打印

/*自己写的*/
#include<stdio.h>
#include<stdlib.h>
char *cpy(const char *str)
{
    char *p_num=(char *)malloc(10*sizeof(char));
    int i=0;
    for(i=0;i<=9;i++)                        //忘写动态分配内存检验了
    {   
        *(p_num+i)=str[i];
    }    
    return p_num;
}
int main()
{
    char str[10]={0};        		//用数组大大降低了难度
    char *p_num=NULL;
    printf("输入一个字符串：");
    fgets(str,10,stdin);
    p_num=cpy(str);
    int i=0;			         //没有检验动态分配内存	
    for(i=0;i<=9;i++)
        printf("%c",*(p_num+i));
    printf("\n");
    free(p_num);
    p_num=NULL;
    return 0;
}

/* 老师写的 */
#include<stdio.h>
#include<stdlib.h>
char *mystrcpy(char *str)
{	
	char *p_tmp=str,*p_dest=NULL,*p_tmp1=NULL;
	int cnt=0;
	while(*p_tmp)
	{
		cnt++;			//先计算字符串的个数，为申请多少个动态内存做准备
		p_tmp++; //指针后移
	}
	cnt++;
	p_dest=(char*)malloc(cnt*sizeof(char));
	if(p_dest)
	{
		p_tmp=str;  //p_tmp指针和原有字符串第一个存储区捆绑
		p_tmp1=p_dest; //p_tmp1指针和动态分配内存第一个存储区捆绑
		while(*p_tmp)
		{
			*p_tmp1=*p_tmp;//拷贝一个字符
			p_tmp++;	//p_tmp指针和下一个存储区捆绑
			p_tmp1++;	//p_tmp1指针和下一个动态分配存储区捆绑
		}
		*p_tmp1=0;  // 在新字符串里加入'\0'字符
	}
	return p_dest;
}
int main()
{
	char *str=mystrcpy("abcdef");
	if(str)
	{
		printf("%s\n",str);
		free(str);
		str=NULL;
	}
	return 0;
}


