关键字：函数 volatile 返回值  形参 实参  数组形参 可变长函数参数(内容不足)  函数声明

/*
    谨记：函数就是函数 就在函数里写函数的功能 不要把该在主函数写的功能放到函数里
	这样 以后要用这个功能还得再写 
	或是再写一个子函数实现 实现复用率更高

	extern函数 static化
	采用注册制添加链表形式 使用函数指针
							*/

/*函数*/
C语言中可以采用分组方式管理语句
每个语句分组叫做一个函数

多函数程序执行模式
1. 整个程序的执行时间被划分成几段，
	不同时间段被分配给不同函数使用
2. 所有时间段不能互相重叠并且是连续的
3. 如果函数A在工作过程中把一段时间分配给函数B则函数B在完成所有工作之后
	必须把后面的时间再还给函数A 

如果函数A在工作过程中把一段时间分配给函数B则它们之间存在函数调用关系
	在这个关系中函数A叫做调用函数，函数B叫做被调用函数
函数调用关系有时间范围，只要被调用函数已经开始工作
	但还没有结束则函数调用关系存在

函数调用语句可以在程序执行过程中产生函数调用关系

变量不可以跨函数使用
不同函数内部变量可以重名
一个函数如果多次运行它内部的变量每次对应的存储区都可能不同

/* volatile */
*volatile 关键字可以用来声明变量，
	如果变量对应的存储区可能被多个程序同时使用
	就应该在声明变量的时候使用这个关键字
	volatile 影响编译器编译的结果，
	volatile 变量是随时可能发生变化的，
	与 volatile 变量有关的运算，不要进行编译优化，以免出错

volatile 告诉编译器i是随时可能发生变化的，每次使用它的时候必须从i的地址中读取，
	因而编译器生成的可执行码会重新从i的地址读取数据

volatile unsigned char i;


函数调用过程中通常伴随着两个函数之间的数字传递
数字传递存在两个完全相反的方向，可以从调用函数传递给被调用函数，
	也可以从被调用函数传递给调用函数
不论哪个方向的数据传递都需要使用被调用函数提供的存储区

/*返回值*/
从被调用函数只能向调用函数传递一个数据
	这个数据叫做被调用函数的返回值
	被调用函数只能在函数结束的时候才能传递返回值
传递返回值的时候需要使用被调用函数提供的一个存储区，
	应该把这个存储区的类型名称写在函数名称前
被调用函数里使用 return 关键字指定返回值的数值
调用函数可以把函数调用语句当作数字使用，这个数字就是函数的返回值

如果函数提供存储区用来记录返回值
	但没有使用return关键字指定返回值的数值
	则调用函数从这个存储区里获得的就是随机数
这个存储区不能用来长期存放数字，	
	调用函数获得返回值以后或者立刻使用或者转存到其他存储区
函数名称前写void表示函数不提供存储区存放返回值
如果函数名称前什么都没有在C89规范里
	表示函数提供一个整数类型存储区存放返回值
	在C99规范里不允许

函数不可以采用数组存放返回值

/* 形参 */
*为了从调用函数向被调用函数传递数据
	也需要被调用函数提供一组存储区，
	这些存储区的类型和个数任意
可以在函数名称后的小括号里写一组变量声明语句
	用这些变量代表这些存储区
这些变量叫做函数的形式参数，小括号里的内容
	叫做函数的形式参数列表
每个形式参数的类型名称都不可以省略
不同形式参数声明之间用逗号分开

/* 实参 */
*调用函数应该在函数调用语句的小括号里
	为每个形式参数提供一个对应的数字，
	这些数字叫做实际参数
能当作数字使用的内容都可以作为实际参数使用（右值）
如果函数不提供形式参数就应该在函数名称后面的小括号里写void
	如果函数名称后面的小括号内容是空的,
	就表示函数可以提供任意多个 任意类型的形式参数

/* 数组形参 */ /* 可以返回多个值 不仅仅是一个 就是相当于指针 */
**数组是可以作为形式参数使用
数组作为形式参数的时候仅仅是把形式参数写成数组的样子，
	真正形式参数并不是数组，而是一个当作数组使用的变量
*数组形式参数里包含的存储区都不是被调用函数提供的（非常重要 跟形参指针类似）
数组形式参数可以让被调用函数使用其他函数提供的存储区
使用数组形式参数可以实现双向数据传递，
	这种参数叫做输入输出参数
声明数组形式参数的时候可以省略其中包含的存储区个数
如果省略数组形式参数中的存储区个数就需要另外提供一个整数类型形式参数
	表示数组里的存储区个数

/*数组形参 编写函数产生一张彩票，在主函数里把彩票内容打印在屏幕上
	数组形参是主函数提供的存储区，所以改变数组里的元素
	其实就是相当于指针，改变地址里内容，这样主函数从地址里取数据的时候，
	内容已经被改变，也就不需要返回值才能改变数据*/
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
static void lottery();
int main()
{
    int arr[7]={0},i=0;
    lottery(arr,7);
    for(i=0;i<=6;i++)
    {
        printf("%d ",arr[i]);
    }
    printf("\n");
    return 0;
}

void lottery(int arr[],int size)   
{
    int i=0;
    srand(time(0));
    for(i=0;i<=6;i++)
    {
        arr[i]=rand()%36+1;
    }
}  
                                                     

/*一个函数实现数组的相反数，一个函数实现打印数据
	reverse和print函数的独立性强，因为用的是主函数提供的存储区
	只要改变存储区里的内容就可以，不需返回值
	这样每个想用这个函数的调用函数提供一个数组即可*/
#include<stdio.h>
void reverse(int arr[],int size)
{
    int num=0;
    for(num=0;num<=size-1;num++)
        arr[num]=0-arr[num]; 
}

void print(int arr[],int size)
{
    int num=0;
    for(num=0;num<=size-1;num++)
        printf("%d ",arr[num]);
}

int main()
{
    int arr[]={1,2,3,4,5}；
    reverse(arr,5);
    print(arr,5);
    return 0;
}


/* 可变长函数参数 */
*C语言中函数形式参数的数量可以是不确定的
	这种参数叫做变长参数
变长参数不能事先命名，只能在被调用函数里通过特殊的方式得到它们

/* 函数声明 */
如果编译器首先遇到函数调用语句会猜测函数格式
	这个猜测结果叫做函数的隐式声明
函数隐式声明中包含一个整数类型存储区用来存放返回值，
	还包含任意多个不确定类型的形式参数
隐式声明中的形式参数只能是int类型或double类型
如果函数隐式声明格式和真实格式不一致 在编译阶段就会出错
函数内容可以分成两个部分，大括号前面的部分叫做函数声明
	大括号里面的部分叫做函数体
可以把函数声明单独写成一条语句，这个时候可以省略形式参数名称
把函数声明语句单独写在文件开头叫做函数的显式声明
函数显式声明可以避免隐式声明
除了主函数以外的所有函数都应该显式声明

