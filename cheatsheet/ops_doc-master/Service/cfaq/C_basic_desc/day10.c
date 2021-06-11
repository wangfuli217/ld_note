关键字：pointer pointer_array 指针结合下标  const void* 字符串 字符串字面值  字符数组

/*指针做形参，被调用函数使用的是调用函数的存储区，
  在被调用函数里修改地址里的数据，（也不需返回值就可修改多个数据）
  这样在调用函数里用到这些存储区时数据已经被改过了 
  这样写的被调用函数就实现了独立性很强，
  其他函数在调用该函数时，使用地址做实参就可以了*/

/* 指针 */
指针变量用来记录地址数据
只有记录有效地址的指针才能使用
有效指针变量前加*可以表示捆绑的存储区

指针变量也分类型，不同类型的指针适合与不同类型的存储区捆绑

可以在一条语句里声明多个同类型指针
	每个指针变量名称前要单独加*

没有捆绑的指针分成两类
1. 空指针里记录固定地址
	(空指针，用 NULL 表示，这个地址的数值就是0)
2. 除了空指针以外的没有捆绑的指针都叫做野指针

程序中禁止出现野指针
所有指针变量必须初始化

/*指针变量初始化的时候*没有参与赋值过程*/
	int *p_num=&num  *没有参与赋值过程
	int num=0; int *p_num=NULL; p_num=&num;  这样就说明*没有参与赋值

指针变量和普通变量之间的捆绑关系可以随着程序的执行不断变化
可以把指针看作普通变量的某种身份，
	可以使用指针实现 针 对身份编程

/***************3个数从大到小排序************************************/
#include<stdio.h>
int main()
{
    int num=0,num1=0,num2=0,temp=0;
    int *p_num=&num,*p_num1=&num1,*p_num2=&num2,*p_temp=&temp;
    printf("输入三个数字:");
    scanf("%d%d%d",p_num,p_num1,p_num2);
    if(*p_num<*p_num1)
    {
        p_temp=p_num;
        p_num=p_num1;
        p_num1=p_temp;
    }
    if(*p_num<*p_num2)
    {
        p_temp=p_num;
        p_num=p_num2;
        p_num2=p_temp;
    }
    if(*p_num1<*p_num2)
    {
        p_temp=p_num1;
        p_num1=p_num2;
        p_num2=p_temp;
    }
    printf("%d  %d  %d\n",*p_num,*p_num1,*p_num2); //交换指针里存的地址 
    printf("%d  %d  %d\n",num,num1,num2);           //数并没有交换
    return 0;
}

结果：
	输入三个数字:7 8 9 
	9  8  7
	7  8  9

/**两个数交换时 交换函数需要用到* 中间变量要用int 因为交换的是数
               如果在交换时不带* 就需要用变量捆绑 中间变量要用int* 交换的是地址*/
#include<stdio.h>
void change();
int main()
{   
    int p=8,p1=9;
    change(&p,&p1);
    printf("%d %d\n",p,p1);
    return 0;
}
void change(int *p,int *p1)
{
    int temp;
    temp=*p;
    *p=*p1;    		//交换的数  
    *p1=temp;		//在被调用函数里无法交换指针里存放的地址 	因为没有这种类型的名称
}

/*交换的指针 交换指针里存的地址*/
#include<stdio.h>
int main()
{
    int p=0,p1=0,temp=0;
    int *p_p=&p,*p_p1=&p1,*p_temp=&temp;
    scanf("%d%d",&p,&p1);		//8 9
    
    printf("%p\n",&p);			//0xbfb74c58
    printf("%p\n",&p1);			//0xbfb74c5c
    printf("%p\n",p_p);			//0xbfb74c58
    printf("%p\n",p_p1);		//0xbfb74c5c
    printf("%d %d\n",*p_p,*p_p1);	//8 9
    printf("%d %d\n",p,p1);		//8 9
    printf("\n");
    
    p_temp=p_p;
    p_p=p_p1;
    p_p1=p_temp;
    
    printf("%p\n",&p);			//0xbfb74c58
    printf("%p\n",&p1);			//0xbfb74c5c
    printf("%p\n",p_p);			//0xbfb74c5c  //交换了
    printf("%p\n",p_p1);		//0xbfb74c58
    printf("%d %d\n",*p_p,*p_p1);	//9 8
    printf("%d %d\n",p,p1);		//8 9
}

结果：	8 9 
	0xbfb74c58
	0xbfb74c5c
	0xbfb74c58
	0xbfb74c5c
	8 9
	8 9

	0xbfb74c58
	0xbfb74c5c
	0xbfb74c5c
	0xbfb74c58
	9 8
	8 9
/*****************************************************************/

/*指针与数组*/
如果用一个指针和数组里第一个存储区捆绑
	就可以通过这个指针找到数组里每个存储区
	这个时候可以认为指针间接捆绑了数组里的所有存储区

/*指针结合下标就是取数组里的元素*/
#include<stdio.h>
int main()
{   
    int arr[] = {1,2,3,4,5};
    int *p_arr = arr, num = 0;

    for (num = 0; num <= 4; num++) {   
        printf("%d ", arr[num]); 	//1
        printf("%p ", &arr[num]);	//0xbf8394a4

        printf("%d ", p_arr[num]);  //指针结合下标就是取数组里的元素 	//1
        printf("%p ", &p_arr[num]);  // &（p_arr[num]） 取数组的地址	//0xbf8394a4
	
	/* 一级指针放变量 二级指针放地址 */
	printf("%p ",&p_arr+num);   //去掉下标就是可以取指针的地址：二级指针//0xbf8394b8
	    //&(p_arr+num)  这样是错误的 &是左值不是右值
        printf("\n");
    }   
    printf("\n");
    return 0;
}
结果：
	1 0xbf8394a4 1 0xbf8394a4 0xbf8394b8 
	2 0xbf8394a8 2 0xbf8394a8 0xbf8394bc 
	3 0xbf8394ac 3 0xbf8394ac 0xbf8394c0 
	4 0xbf8394b0 4 0xbf8394b0 0xbf8394c4 
	5 0xbf8394b4 5 0xbf8394b4 0xbf8394c8 


地址数据可以参与如下计算
地址 + 整数	地址 - 整数	地址 - 地址

地址加减整数n实际加减的是n个捆绑存储区的大小
地址减地址的结果是一个整数，
	这个结果表示两个地址之间捆绑存储区的个数
/************************************************
**所有跨函数使用存储区都是通过指针实现的	       **
**数组做形式参数的时候真正的形式参数是一个指针变量**
*************************************************/

指针存储区可以用来存放函数的返回值
这样可以让调用函数使用被调用函数提供的存储区

/*不可以把非静态局部变量的地址作为返回值*/
#include<stdio.h>
int* read();
int main()
{
    int *p_num=read();
    printf("%d\n",*p_num);
    return 0;
}
int* read(void)
{
    static int num;
    printf("输入数字：");
    scanf("%d",&num);
    return &num;  
}          
/* 因为声明的变量是 int类型 
   所以return 要加& 变成地址 
   如果声明的是地址 return时就不用加取址符 */



/* const */
const 关键字可以用来声明变量，多数情况下用来声明指针
	声明指针变量时可以把 const 关键字写在类型名称前，
	这表示不可以通过指针对捆绑存储区进行赋值和修改，
	但可以对指针本身的存储区进行赋值
	int num=0;
 	const int* p_num=&num;
      	// *p_num=10;       	//不能通过指针对捆绑存储区赋值 （不能通过指针改变存储区里的值，但是可以通过其他方式改变里面的值，不是说里面的值永远不能改）
		  //不能这样赋值
	p_num=NULL;   		//可以对指针本身的存储区进行赋值

指针形式参数要尽量采用上面的方式 加 const 关键字

（/*很少用*/）可以在声明指针变量的时候把 const 关键字写在指针变量名称前，
	可以通过这种指针对捆绑存储区做赋值，
	但是不可以对指针本身做赋值
	int num=0;
        int* const p_num1=&num;
        *p_num1=10;
	//p_num1=NULL；     不可以对指针本身做赋值

//指针和const
	int age = 39;
	const int* pt=&age;
	pt指向const int(这里为39)，因此不能使用pt来修改这个值。*pt的值为const

	pt的声明并不意味着它指向的值实际上就是一个常量，而只是意味着对pt而言，这个值是常量。
	pt指向age，而age不是const，可以通过age变量来修改age的值，但不能通过pt指针来修改它。


	将const变量的地址赋给指向const的指针， 一级指针到二级指针也是如此
	不能将const的地址赋给常规指针。 一级指针到二级指针也是如此
	const float g_earth=9.80;
	const float* pe = &g_earth;	//VALID

	const float g_moon=1.63;
	float* pm = &g_moon;		//INVALID  注意这一点  所以指针尽量用const修饰 这样既能接收const型数据，也能接收非const型数据


	int sloth=3;
	const int* ps=&sloth;		//a pointer to const int   **************
	int* const finger=&sloth;	//a const pointer to int   **************
	最后一个声明使用const的方式使得无法修改指针的值
	finger只能指向sloth，但允许通过finger来修改sloth的值


	double trouble=2.0E30;
	const double* const stick=&trouble;
	stick只能指向trouble，而stick不能用来修改trouble的值。stick和*stick都是const


/* void* */
可以在声明指针变量时使用void作为类型名称
	这种指针叫做无类型指针
	这种指针可以和任意类型存储区捆绑
不能通过这种指针知道捆绑存储区的类型
	这种指针前面不可以直接加*来使用
这种指针必须首先强制类型转换成有类型指针，
	然后才可以在前面加*表示捆绑存储区
	
#include<stdio.h>
int main()
{
    char ch ='a';
    int num=20;
    float fnum=5.4f;
    void *p_v=NULL;
    p_v=&ch;
    *(char*)p_v='b';
    printf("%c\n",*(char*)p_v);		//b

    p_v=&num;
    printf("%d\n",*(int*)p_v);		//20
    p_v=&fnum;
    printf("%g\n",*(float*)p_v);	//5.4
    return 0;
}
无类型指针通常作为形式参数使用，
	可以通过它把任意类型的存储区传递给被调用函数

/* 字符串 */
C语言里所有文字信息必须存储在一组连续的字符类型存储区里
所有文字信息必须以'\0'字符作为结尾
	这个字符的ASCII码就是数字 0
符合这两个特征的内容叫做字符串
字符串里'\0'字符前面的部分是有效字符
所有字符串一定可以采用字符类型指针表示

/* 字符串字面值 */
字符串字面值是一种字符串，
	用两个双引号中间的一组字符表示，"abc" , "^&*%"
编译器在编译的时候会自动在字符串字面值后面加上'\0'字符
*编译器编译时会把字符串字面值替换成第一个字符所在存储区的地址

#include<stdio.h>
int main()
{
    printf("%p\n","abc");
    printf("%d\n",*("abc"+3));
    printf("%c\n",*("abc"+3));	//空格 看不见
    printf("%d\n",*("abc"+2));
    return 0;
}
结果：	0x8048504
      	0
	
	c

字符串字面值的内容在程序执行过程中不可以改变
	//  *"abc"='X';     编译不报错  执行错误
程序中多个内容一样的字符串字面值在程序执行的时候其实是同一个
并列写在一起的多个字符串字面值会被编译器合并成一个 
		"abc""def" 合并成"abcdef"

/* 字符数组 */
字符数组也可以用来表示字符串
只有包含'\0'字符的字符数组才可以代表字符串
可以采用字符串字面值对字符数组进行初始化，
	这个时候字符串字面值里'\0'字符也会被初始化到字符数组里
    	char str[]="xyz";
  	printf("sizeof(str)is %d\n",sizeof(str));
  	结果：sizeof(str)is 4 //包含了'\0' 所以是4

字符数组里的字符串内容可以修改
	char str[]="xyz";	
	str[0]='a';
    	printf("%s\n",str);
	// ayz

可以用%s 作为占位符把字符串里的所有字符显示在屏幕上

/* 将12345 反转成54321  用指针方式*/
/* 多注意什么时候应该加* 什么时候应该加& 什么时候不加 要对应类型一样*/
/* 定义的int 需要传地址就要加&  定义的是地址 需要传数就要加*
   定义的是* 需要传地址就什么都不用加     切记！！！                  */
/* 多动脑子想 不要在那没有依据的试，得有理有据知道是什么道理再用*/
	
#include<stdio.h>
int* reverse();
int main()
{
    int arr[] = {1,2,3,4,5}, num = 0;
    int *p_num = reverse(arr,5);
    for(num=0;num<=4;num++)
        printf("%d",*(p_num + num));
    printf("\n");
    return 0;
}
int* reverse(int *p_num,int size)
{
    int temp = 0;
    int *p_start = p_num;
    int *p_end = p_num + size-1;
    while( p_start < p_end)
    {
        temp = *p_start;
        *p_start = *p_end;    //运用里离散傅里叶变化转换为快速傅里叶变化
        *p_end = temp;        //效率提升一倍 采集点变成一半
        p_start++;
        p_end--;
    }
    return p_num;
}

结果：54321

