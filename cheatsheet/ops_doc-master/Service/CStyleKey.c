/*
 * c_learn.c
 *
 *  Created on: 2019年3月7日
 *      Author: Administrator
 */

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h> //提供malloc, system等接口函数
#include <time.h>	//提供时间相关操作接口
//#include "include\draw.h"

typedef char 				int8;
typedef unsigned char 		uint8;
typedef short 				int16;
typedef unsigned short 		uint16;
typedef int 				int32;
typedef unsigned int 		uint32;
typedef long long 			int64;
typedef unsigned long long 	uint64;
typedef float 				float32;
typedef double 				float64;

#define TRUE  1
#define FALSE 0


//定义打印宏，并在打印信息前加入文件名、行号、函数名
/*
这段代码中用到了这几个宏:
　　1) __VA_ARGS__   是一个可变参数的宏，这个可宏是新的C99规范中新增的，目前似乎gcc和VC6.0之后的都支持（VC6.0的编译器不支持）。
       宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用。
　　2) __FILE__    宏在预编译时会替换成当前的源文件名
　　3) __LINE__   宏在预编译时会替换成当前的行号
　　4) __FUNCTION__   宏在预编译时会替换成当前的函数名称
*/

//#define PRINT_ADV(fmt,...) printf("\n%s(%d)-<%s>: " fmt, __FILE__, __LINE__, __FUNCTION__, ##__VA_ARGS__)
//#define PRINT_ADV (printf("\n%s(%d)-<%s>: ",__FILE__, __LINE__, __FUNCTION__), printf) //不用__VA_ARGS__的另一种写法，效率不如上面高
//#define PRINT_ADV(fmt,...) printf("\n<%s>: " fmt, __FUNCTION__, ##__VA_ARGS__) #仅打印函数名
#define PRINT_ADV  printf

//关于可变参数宏__VA_ARGS__的例子
#define   MY_DEBUG_LOG(...)            (printf(__VA_ARGS__))
#define   MY_DEBUG_TRACE(format,...)   (printf(format,##__VA_ARGS__))
void mainVaArgs(void)
{
	MY_DEBUG_LOG("Hello, world! The value is:%d\n", 100);
	MY_DEBUG_TRACE("Hello, world! The value is:%d\n", -100);
	MY_DEBUG_LOG("Hello,world!");
	MY_DEBUG_TRACE("Hi,there!");

	MY_DEBUG_TRACE("Hi,there!");


}

//获取编译日期和编译时间
void mainCmpDateTime(void)
{
	printf("编译日期：%s", __DATE__); //__DATE__绑定编译日期
	printf("编译时间： %s", __TIME__); //__TIME__绑定编译时间
}


/* 数据类型 */
//1.强制转换	//2019-3-7
void mainValueTrans(void){
	float a = -1.2f;

	int b = a;
	printf("\n b = %d ", b);

	unsigned int c = a;			//转为无符号整形仍正确，比较奇怪？？？
	PRINT_ADV("\n c = %d ", c);

	unsigned short int d = a;	//浮点不能直接转无符号整形
	PRINT_ADV("\n d = %d ", d);

	unsigned short  e = a;		//浮点不能直接转无符号整形
	PRINT_ADV("\n e = %d ", e);

	unsigned short int f = (short int)a ;	//先转有符号整形，再转无符号整形，仍有问题？？？
	PRINT_ADV("\n f = %d ", f);
}

//2.整数除法
void mainIntDevide(void){
	int a = 7;
	int b = 3;
	int c = a / b;
	PRINT_ADV("\n c = %d ", c); //整数除法自动取整
}

#include <stdbool.h>
//3.变量定义 19-3-7
void mainBoolTest(void){
	/*C99还提供了一个头文件 <stdbool.h> 定义了 bool 代表 _Bool，
	true 代表 1，false 代表 0。只要导入 stdbool.h ，就能非常方便的操作布尔类型了。
	*/
	bool a = true;	//
	PRINT_ADV("\n a = %d ", a);
}

//4.变量地址
/*
全局变量保存在内存的全局存储区中，占用静态的存储单元；局部变量保存在栈中，只有在所在函数被调用时才动态地为变量分配存储单元。
C语言经过编译之后将内存分为以下几个区域：
（1）栈（stack）：由编译器进行管理，自动分配和释放，存放函数调用过程中的各种参数、局部变量、返回值以及函数返回地址。
操作方式类似数据结构中的栈。
（2）堆（heap）：用于程序动态申请分配和释放空间。C语言中的malloc和free，C++中的new和delete均是在堆中进行的。
正常情况下，程序员申请的空间在使用结束后应该释放，若程序员没有释放空间，则程序结束时系统自动回收。注意：这里的“堆”并不是数据结构中的“堆”。
（3）全局（静态）存储区：分为DATA段和BSS段。DATA段（全局初始化区）存放初始化的全局变量和静态变量；
BSS段（全局未初始化区）存放未初始化的全局变量和静态变量。程序运行结束时自动释放。其中BBS段在程序执行之前会被系统自动清0，
所以未初始化的全局变量和静态变量在程序执行之前已经为0。
（4）文字常量区：存放常量字符串。程序结束后由系统释放。
（5）程序代码区：存放程序的二进制代码。
显然，C语言中的全局变量和局部变量在内存中是有区别的。C语言中的全局变量包括外部变量和静态变量，均是保存在全局存储区中，占用永久性的存储单元
；局部变量，即自动变量，保存在栈中，只有在所在函数被调用时才由系统动态在栈中分配临时性的存储单元。
*/
int k1 = 1;
int k2;
static int k3 = 2;
static int k4;
void mainValueAdr(void)
{
    static int m1=2, m2;
    int i=1;
    char *p;
    char str[10] = "hello";
    char *q = "hello";
    p = (char *)malloc(100);
    free(p);
    PRINT_ADV("栈区-变量地址  i：%p\n", &i);
    PRINT_ADV("                p：%p\n", &p);
    PRINT_ADV("              str：%p\n", str);
    PRINT_ADV("                q：%p\n", &q);
    PRINT_ADV("堆区地址-动态申请：%p\n", p);
    PRINT_ADV("全局外部有初值 k1：%p\n", &k1);
    PRINT_ADV("    外部无初值 k2：%p\n", &k2);
    PRINT_ADV("静态外部有初值 k3：%p\n", &k3);
    PRINT_ADV("    外静无初值 k4：%p\n", &k4);
    PRINT_ADV("  内静态有初值 m1：%p\n", &m1);
    PRINT_ADV("  内静态无初值 m2：%p\n", &m2);
    PRINT_ADV("文字常量地址    ：%p, %s\n",q, q);
    PRINT_ADV("程序区地址      ：%p\n",&mainValueAdr);
}

//5.常量
/*
整数常量可以是十进制、八进制或十六进制的常量。前缀指定基数：0x 或 0X 表示十六进制，0 表示八进制，不带前缀则默认表示十进制。
整数常量也可以带一个后缀，后缀是 U 和 L 的组合，U 表示无符号整数（unsigned），L 表示长整数（long）。
后缀可以是大写，也可以是小写，U 和 L 的顺序任意。
整形常量：
212          合法的
215u         合法的
0xFeeL       合法的
078          非法的：8 不是八进制的数字
032UU        非法的：不能重复后缀
以下是各种类型的整数常量的实例：
85          十进制
0213        八进制
0x4b        十六进制
30          整数
30u         无符号整数
30l         长整数
30ul        无符号长整数
浮点常量：
3.14159        合法的
314159E-5L     合法的
510E           非法的：不完整的指数
210f           非法的：没有小数或指数
.e55           非法的：缺少整数或分数
字符常量
字符常量是括在单引号中，例如，'x' 可以存储在 char 类型的简单变量中。
字符常量可以是一个普通的字符（例如 'x'）、一个转义序列（例如 '\t'），或一个通用的字符（例如 '\u02C0'）。
在 C 中，有一些特定的字符，当它们前面有反斜杠时，它们就具有特殊的含义，被用来表示如换行符（\n）或制表符（\t）等。下表列出了一些这样的转义序列码：
反斜杠(\) 开头是叫转义序列(Escape Sequence)。
\ooo 是对用三位八进制数转义表示任意字符的形象化描述。
比如 char ch = '\101'; 等价于 char ch = 0101; (以0开头的表示八进制）。
\xhh 里面是 x 是固定的，表示十六进制(hexadecimal)，h 也表示十六进制。
举例，char ch = '\x41'; 就是用十六进制来表示，它与前面的 \101 是等价的。
可用如下代码证明它们等价：
printf("%c,%c,%c,%c", 0101, '\101', '\x41', 'A');
字符串常量
字符串字面值或常量是括在双引号 "" 中的
在 C 语言中，单引号与双引号是有很大区别的。
在 C 语言中没有专门的字符串类型，因此双引号内的字符串会被存储到一个数组中，这个字符串代表指向这个数组起始字符的指针；
而单引号中的内容是一个 char 类型，是一个字符，这个字符对应的是 ASCII 表中的序列值。
*/

/*
const 相比#define定义常量，可以节省空间，避免不必要的内存分配。 例如：
#define NUM 3.14159 //常量宏
const doulbe Num = 3.14159; //此时并未将Pi放入ROM中 ......
double i = Num; //此时为Pi分配内存，以后不再分配！
double I= NUM; //编译期间进行宏替换，分配内存
double j = Num; //没有内存分配
double J = NUM; //再进行宏替换，又一次分配内存！
const 定义常量从汇编的角度来看，只是给出了对应的内存地址，而不是象 #define 一样给出的是立即数，
所以，const 定义的常量在程序运行过程中只有一份拷贝（因为是全局的只读变量，存在静态区），而 #define 定义的常量在内存中有若干个拷贝。
编译器通常不为普通const常量分配存储空间，而是将它们保存在符号表中，这使得它成为一个编译期间的常量，没有了存储与读内存的操作，使得它的效率也很高。
 */

//6.存储类
/*
auto 是局部变量的默认存储类, 限定变量只能在函数内部使用；
register ：这个关键字请求编译器尽可能的将变量存在CPU内部寄存器中，而不是通过内存寻址访问，以提高效率。注意是尽可能，不是绝对。
因为，如果定义了很多register变量，可能会超过CPU的寄存器个数，超过容量。所以只是可能。
register修饰符暗示编译程序相应的变量将被频繁地使用，如果可能的话，应将其保存在CPU的寄存器中，以加快其存储速度。
static是全局变量的默认存储类,表示变量在程序生命周期内可见；
extern 表示全局变量，即对程序内所有文件可见，类似于Java中的public关键字；
register修饰符有几点限制。
　　1.register变量必须是能被CPU所接受的类型。这通常意味着register变量必须是一个单个的值，
并且长度应该小于或者等于整型的长度。不过，有些机器的寄存器也能存放浮点数。
　　2.因为register变量可能不存放在内存中，所以不能用“&”来获取register变量的地址。
由于寄存器的数量有限，而且某些寄存器只能接受特定类型的数据（如指针和浮点数），因此真正起作用的register
修饰符的数目和类型都依赖于运行程序的机器，而任何多余的register修饰符都将被编译程序所忽略。在某些情况下，
把变量保存在寄存器中反而会降低程序的运行速度。因为被占用的寄存器不能再用于其它目的；或者变量被使用的次数不够多，
不足以装入和存储变量所带来的额外开销。
　3.早期的C编译程序不会把变量保存在寄存器中，除非你命令它这样做，这时register修饰符是C语言的一种很有价值的补充。
然而，随着编译程序设计技术的进步，在决定那些变量应该被存到寄存器中时，现在的C编译环境能比程序员做出更好的决定。
实际上，许多编译程序都会忽略register修饰符，因为尽管它完全合法，但它仅仅是暗示而不是命令。
 */

#define TIME 1000000000
int m, n = TIME; /* 全局变量 */

int mainStoreType(void)
{
    time_t start, stop;	//time_t 结构体需要包含<time.h>
    register int a, b = TIME; /* 寄存器变量 */
    int x, y = TIME;          /* 一般变量   */

    time(&start);
    for (a = 0; a < b; a++);
    time(&stop);
    PRINT_ADV("寄存器变量用时: %ld 秒\n", stop - start);

    time(&start);
    for (x = 0; x < y; x++);
    time(&stop);
    PRINT_ADV("一般变量用时: %ld 秒\n", stop - start);

    time(&start);
    for (m = 0; m < n; m++);
    time(&stop);
    PRINT_ADV("全局变量用时: %ld 秒\n", stop - start);

    return 0;
}

//7.运算符
//三目运算符可以用于函数：
void testPrint1(void) {
	PRINT_ADV("\n执行函数1");
}
void testPrint2(void) {
	PRINT_ADV("\n执行函数2");
}
void mainOper(void) {
	int i = 0;
	(i == 0) ? testPrint1():testPrint2();
	i = 1;
	(i == 0) ? testPrint1():testPrint2();
}

//8.函数
/*
 函数参数传递常用的三种方式
 1. 值传递
 2. 指针传递
 void swap(int *x, int *y)
{
    int temp;
    temp = *x;
    *x = *y;
    *y = temp;
}
 3. 引用传递
 void swap(int &x, int &y)
{
    int temp;
    temp = x;
    x = y;
    y = temp;
}
引用传递中，在调用swap(a, b);时函数会用a、b分别代替x、y，即x、y分别引用了a、b变量，
这样函数体中实际参与运算的其实就是实参a、b本身，因此也能达到交换数值的目的。
注：严格来说，C语言中是没有引用传递，这是C++中语言特性，因此在.c文件中使用引用传递会导致程序编译出错。
 */

/*
 函数声明和函数原型的参数名可以不一样，编译器他想知道的是函数参数的类型，与函数参数的名字没有关系
 甚至函数声明可以写成:
 int sum(int ,int );
 */

//函数形参改变：
int FUNC_FormalPramModule(int a,int b) // 形参
{
    a=a+b;
    return a; //改变了形参的值
}

void FUNC_FormalPram(void) {
	int a = 4,b = 5;
	PRINT_ADV("\n return value: s%d",FUNC_FormalPramModule(5,3)); // 实参，已赋值
	PRINT_ADV("\n a = %d", a); // 实参，已赋值
	PRINT_ADV("\n b = %d", b); // 实参，已赋值
}

//当函数需要返回多个参数时，可以以传指针的方式，将指针传入，然后函数对指针引用值进行修改，达到返回多个参数的目的；
//此例需要返回min和max两个参数，因此可以作为形参将指针传入；
void FUNC_MinMax(int a[], int len, int *min, int *max) {
    int i;
    *min = *max = a[0]; //假定最大值 最小值相等 为a[0]

    for(i = 0; i < len; i++) {
        if( a[i] < *min) {
          *min = a[i];
        }
        if(a[i] > *max) {
          *max = a[i];
        }
    }
}



void FUNC_ArrayMinMax(void) {
	int a[] = {1, 2, 3, 4, 5, 7, 8, 9, 15, 18, 25, 33};
	int min = 0, max = 0;
	FUNC_MinMax(a, sizeof(a)/ sizeof(a[0]), &min , &max );
	PRINT_ADV( "\n min of a = %d, max of a = %d \n",  min,  max);
}

void mainFuncTest(void) {
	FUNC_FormalPram();
	FUNC_ArrayMinMax();
}

//用C写批处理应用函数，调用system()接口



//9.数组  2019-3-10
//数组初始化
void ARRAY_InitialTest(void) {
	int B[10]={12, 19, 22 , 993, 344}; //可以只给部分元素赋值，当 { } 中值的个数少于元素个数时，只给前面部分元素赋值
	PRINT_ADV("\n B[9] = %d", B[9]);   //后面 5 个元素自动初始化为 0。
	/*
	不同类型剩余的元素自动初始化值说明如下：
	 对于 short、int、long，就是整数 0；
	 对于 char，就是字符 '\0'；
	 对于 float、double，就是小数 0.0。
	 */

	//我们可以通过下面的形式将数组的所有元素初始化为 0：
	int C[10] = {0};
	char D[10] = {0};
	float E[10] = {0.0};
}

//结构体数组初始化,不预先指定长度；
void ARRAY_StruArrayInit(void) {
	typedef struct {
		int key;
		int value;
	}StuTest;
	//类似于Python 字典键值对的结构
	StuTest StuArr[] = {
			{1,2},
			{3,4},
			{5,6},
	};
	int i,len;
	len = sizeof(StuArr)/sizeof(StuArr[0]);
	for (i=0; i < len; i++) {
		PRINT_ADV("\n StuArr[%d], key = %d, value = %d", i, StuArr[i].key, StuArr[i].value);
	}


}


//多维数组
void ARRAY_NdArray(void) {
	//多维数组
	int A[3][4] = {
	 {0, 1, 2, 3} ,   /*  初始化索引号为 0 的行 */
	 {4, 5, 6, 7} ,   /*  初始化索引号为 1 的行 */
	 {8, 9, 10, 11}   /*  初始化索引号为 2 的行 */
	};

	//内部嵌套的括号是可选的，下面的初始化与上面是等同的：
	int B[3][4] = {0,1,2,3,4,5,6,7,8,9,10,11};

	//定义多维数组时省略第一维长度，常用于编码扩展；
	int C[][4] = {		 //定义时省略第一维长度，会根据初始化长度自动确定第一维长度；但注意，只有一个维度参数能省略！！
		 {0, 1, 2, 3} ,   /*  初始化索引号为 0 的行 */
		 {4, 5, 6, 7} ,   /*  初始化索引号为 1 的行 */
		 {8, 9, 10, 11},   /*  初始化索引号为 2 的行 */
		};
	int dim0_C = sizeof(C)/sizeof(C[0]);	//第一维数组长度
	PRINT_ADV("\n 数组C第一维长度 ： %d", dim0_C);

	int D[][2][3] = {		 //定义时省略第一维长度，会根据初始化长度自动确定第一维长度；但注意，只有一个维度参数能省略！！
			{
				 {0, 1, 2},
				 {3, 4, 5},
			},
			{
				 {6, 7, 8},
				 {9, 10, 11},
			},
		};
	int dim0_D = sizeof(D)/sizeof(D[0]);	//第一维数组长度
	PRINT_ADV("\n 数组D第一维长度 ： %d", dim0_D);

	//如下缺省二维长度的定义是错误的：
	/*
	int E[][] = {		 //只有一个维度参数能省略！！， 此处会报错
		 {0, 1, 2, 3} ,
		 {4, 5, 6, 7} ,
		 {8, 9, 10, 11},
		};
	*/

	int F[][4] = {		 //只有一个维度参数能省略！！， 此处会报错
		 {0, 1, 2, 3} ,
		 {4, 5, } ,
		 {8, 9, 10,},
		};
	PRINT_ADV("\n 数组 F[1][2] =  %d", F[1][2]);	//不够长度的默认初始化为0； 而且没有告警

}

//字符串数组赋值区别：
void ARRAY_StringArray(void) {
	//字符串数组赋值区别：
	char F[]="runoob"; // 这样赋值之后在结尾会自动加上'\0'。
	char G[]={'r','u','n','o','o','b'};	//这样赋值结尾不会加上'\0'。
	PRINT_ADV("\n 字符串数组F长度为  %d , 数组G长度为 %d", sizeof(F),sizeof(G));	//注意长度的区别
}

void ARRAY_PtrIndexArray(void) {
	//用指针来索引结构体数组元素:
	typedef struct {
		int H[4];
	}struH;
	struH testStruArray[5] = {0};
	struH *ptr = testStruArray;
	(ptr + 2)->H[0] = 5; //注意可以通过指针增加偏移的方式来索引结构体数组,前提是指针的类型要与数组类型一致，且其值与数组头指针相同
	testStruArray[2].H[0] = 5;
	PRINT_ADV("\n testStruArray[2].H[0] = %d", testStruArray[2].H[0]);

	//再如多维数组：
	int A[3][4] = {
	 {0, 1, 2, 3} ,   /*  初始化索引号为 0 的行 */
	 {4, 5, 6, 7} ,   /*  初始化索引号为 1 的行 */
	 {8, 9, 10, 11},   /*  初始化索引号为 2 的行 */
	};

	PRINT_ADV("\n (A+2)[0] = %d", *(A+2)[0]);
	int *ptr1 = A;
	PRINT_ADV("\n (ptr1+2)[0] = %d", (ptr1+2)[0]);	//注意和上面的区别; 数组头赋值给指针后索引方式改变！
	ptr1 = &A[0][0];
	PRINT_ADV("\n (ptr1+2)[0] = %d", (ptr1+2)[0]);	//注意和上面的区别; 数组头赋值给指针后索引方式改变！


}

//数组长度测试
void ARRAY_LenTest(void) {
	int len = 0;
	double A[] = {1000.0, 2.0, 3.4, 7.0, 50.0};	//省略掉了数组的大小，则数组的大小则为初始化时元素的个数。
	//len = sizeof(A) / sizeof(double); // 获取数组长度方法
	len = sizeof(A) / sizeof(A[0]); // 获取数组长度方法2, 更通用
	PRINT_ADV("\n 数组A大小为  %d", sizeof(A));
	PRINT_ADV("\n 数组A长度为  %d", len); //
}

//数组作为形参传入函数后不能计算长度!!!
int ARRAY_CalcArrLen(int arr[]) {	//当把数组名作为函数实参时，它会自动被转换为指针。
	return(sizeof(arr)/sizeof(arr[0]));
}

//当把数组名作为函数实参时，它会自动被转换为指针。所以上面的声明等同于下面的声明：
int ARRAY_CalcArrLen2(int *arr) {
	return(sizeof(arr)/sizeof(arr[0]));
	//使用方括号 [] 声明函数数组参数的一个优点就是可读性好，它可以显著地标识出函数将该参数作为指向数组的指针，
}

void ARRAY_LenTest2(void) {
	//数组作为形参传入函数后不能计算长度!!!
	int K[5] = {0};
	PRINT_ADV("\n 数组K实际长度 = %d", sizeof(K)/sizeof(K[0]));
	PRINT_ADV("\n 数组K传入函数后计算的长度 = %d, 是错误的", ARRAY_CalcArrLen(K));

}

//传递数组给函数
//第一种，数组长度确定
int ARRAY_Maximum( int nrows, int ncols, int matrix[3][4] )
{
  int max = matrix[0][0];
  for ( int i = 0; i < nrows; ++i )
    for ( int j = 0; j < ncols; ++j )
      if ( max < matrix[i][j] )
        max = matrix[i][j];
  return max;
}

//第二种，数组长度不定，但允许传表示数组长度的变量
//C99 同时允许将数组参数声明成可变长度的数组。方法是将一个非常量的、且为正数的整数表达式放在方括号之间。
//在这种情况下，数组参数仍然是指向第一个数组元素的指针。不同之处在于，数组元素本身也允许长度可变。
int ARRAY_Maximum1( int nrows, int ncols, int matrix[nrows][ncols] )
{
  int max = matrix[0][0];
  for ( int i = 0; i < nrows; ++i )
    for ( int j = 0; j < ncols; ++j )
      if ( max < matrix[i][j] )
        max = matrix[i][j];
  return max;
}

//第三种，改用指针的方式，对比上个方案；利用数组是顺序存储的特性, 通过降维来访问原数组
int ARRAY_Maximum2( int nrows, int ncols, int *matrix )
{
  int max = *matrix;
  for ( int i = 0; i < nrows; ++i )
    for ( int j = 0; j < ncols; ++j )
      if ( max < *(matrix + ncols * i + j))	//注意若传指针，索引方式改变了；实际上是通过降维来访问原数组!
        max = *(matrix + ncols * i + j);
  return max;
}

//第一维的长度可以不指定，但必须指定第二维的长度,如下代码定义会报错：
/*
int ARRAY_Maximum3( int nrows, int ncols, int matrix[][])
{
  int max = matrix[0][0];
  for ( int i = 0; i < nrows; ++i )
    for ( int j = 0; j < ncols; ++j )
      if ( max < matrix[i][j] )
        max = matrix[i][j];
  return max;
}
*/

//第四种,第一维的长度可以不指定，但必须指定第二维的长度
int ARRAY_Maximum3( int nrows, int ncols, int matrix[][ncols])
{
  int max = matrix[0][0];
  for ( int i = 0; i < nrows; ++i )
    for ( int j = 0; j < ncols; ++j )
      if ( max < matrix[i][j] )
        max = matrix[i][j];
  return max;
}

void ARRAY_ParArray(void) {
	int A[3][4] = {
	 {0, 1, 2, 3} ,   /*  初始化索引号为 0 的行 */
	 {4, 5, 6, 7} ,   /*  初始化索引号为 1 的行 */
	 {8, 9, 10, 11},   /*  初始化索引号为 2 的行 */
	};

	PRINT_ADV("\n ARRAY_Maximum = %d",   ARRAY_Maximum(3,4,A));
	PRINT_ADV("\n ARRAY_Maximum2 = %d",  ARRAY_Maximum2(3,4,A));	//函数调用形式没变
	PRINT_ADV("\n ARRAY_Maximum3 = %d",  ARRAY_Maximum3(3,4,A));

}



void mainArray(void) {
	//ARRAY_InitialTest();
	ARRAY_StruArrayInit();
	//ARRAY_NdArray();
	//ARRAY_PtrIndexArray();
	//ARRAY_LenTest();
	//ARRAY_LenTest2();
	//ARRAY_ParArray();
}


//10.指针
void PTR_Basic(void) {
	int  var = 20;   /* 实际变量的声明 */
	int  *ip = NULL;        /* 指针变量的声明 */	//注意要初始化为NULL

	PRINT_ADV("指针ip指向的初始化地址为: %p\n", ip );

	/*
	 在大多数的操作系统上，程序不允许访问地址为 0 的内存，因为该内存是操作系统保留的。然而，内存地址 0 有特别重要的意义，
	它表明该指针不指向一个可访问的内存位置。但按照惯例，如果指针包含空值（零值），则假定它不指向任何东西。
	如需检查一个空指针，您可以使用 if 语句，如下所示
	if(ptr)      //如果 p 非空，则完成
	if(!ptr)     //如果 p 为空，则完成
	*/

	ip = &var;  /* 在指针变量中存储 var 的地址 */

	PRINT_ADV("变量var 的地址为: %p\n", &var  );	//注意指针的标准化输出为p%
	/* 在指针变量中存储的地址 */
	PRINT_ADV("指针ip指向的地址为: %p\n", ip );
	/* 使用指针访问值 */
	PRINT_ADV("指针ip指向的变量值为: %d\n", *ip );

}

//指针数组, 以字符串数组为例:
void PTR_PtrArray(void) {
	   const char *names[] = {
	                   "Zara Alia",
	                   "Hina Alifda",
	                   "Nuha Ali",
	                   "Sara Ali",
	   };
	   int len = sizeof(*names)/sizeof(*names[0]); //计算指针数组长度；注意虽然各字符串长度不等，但仍可以用sizeof(*names[0])获取最大成员长度；

	   int i = 0;
	   for ( i = 0; i < len; i++)
	   {
	      PRINT_ADV("Value of names[%d] = %s\n", i, names[i] );	//注意names[i]为指针，即为该字符串的数组头；
	   }
}

//双重指针, 指向指针的指针
void PTR_DupPtr(void) {
	typedef struct {
		int var1;
		float var2;
	}StuDef;	//结构体定义

	StuDef a, *ptr, **pptr;
	a.var1 = 1;
	a.var2 = 2.2f;

	ptr = &a;	/* 获取 a 的地址 */
	pptr = &ptr;	/* 使用运算符 & 获取 ptr 的地址 */

	PRINT_ADV("Value of a.var1 = %d, a.var2 = %.2f\n", a.var1,  a.var2);
	PRINT_ADV("Value of ptr->var1 = %d, ptr->var2 = %.2f\n", ptr->var1,  ptr->var2);
	PRINT_ADV("Value of (*pptr)->var1 = %d, (*pptr)->var2) = %.2f\n", (*pptr)->var1,  (*pptr)->var2);

}

//函数返回指针
int * PTR_CalcArrayMax(void)
{
	static int  a[10] = {0};	//C语言不支持在调用函数时返回局部变量的地址，除非定义局部变量为 static 变量。
	int i = 0;

	for ( i = 0; i < 10; i++)
	{
	  a[i] = rand();
	  //PRINT_ADV("%d\n", a[i] );
	}
	return a;
	/*
	因为局部变量是存储在内存的栈区内，当函数调用结束后，局部变量所占的内存地址便被释放了，因此当其函数执行完毕后，函数内的变量便不再拥有那个内存地址，所以不能返回其指针。
	除非将其变量定义为 static 变量，static 变量的值存放在内存中的静态数据区，不会随着函数执行的结束而被清除，故能返回其地址。
	*/
}

//注意，如下定义会报错； C语言不允许在程序运行的时候才决定数组的大小len;必须一开始编译时就确定数组的大小；
/*
int * PTR_CalcArrayMax(int len) {
	static int  a[len] = {0};
}
*/

void PTR_FuncRetPtr(void)
{
	int i = 0;
	int *ptr = NULL;
	ptr = PTR_CalcArrayMax();
	for ( i = 0; i < 10; i++)
	{
	  PRINT_ADV("生成数组 ptr[%d] = %d\n", i, ptr[i]);
	}
}

/*
	int *p[3]; -- 首先从 p 处开始, 先与 [] 结合, 因为其优先级比 * 高,所以 p 是一个数组,
然后再与 * 结合, 说明数组里的元素是指针类型, 然后再与 int 结合, 说明指针所指向的内容的类型是整型的, 所以 p 是一个由返回整型数据的指针所组成的数组。
	int (*p)[3]; -- 首先从 p 处开始, 先与 * 结合,说明 p 是一个指针然后再与 [] 结合(与"()"这步可以忽略,只是为了改变优先级),
说明指针所指向的内容是一个数组, 然后再与int 结合, 说明数组里的元素是整型的。所以 p 是一个指向由整型数据组成的数组的指针。
	int (*p)(int); -- 从 p 处开始, 先与指针结合, 说明 p 是一个指针, 然后与()结合, 说明指针指向的是一个函数,
然后再与()里的 int 结合, 说明函数有一个int 型的参数, 再与最外层的 int 结合, 说明函数的返回类型是整型, 所以 p 是一个指向有一个整型参数且返回类型为整型的函数的指针。
	int *(*p(int))[3]; -- 可以先跳过, 不看这个类型, 过于复杂从 p 开始,先与 () 结合, 说明 p 是一个函数,
然后进入 () 里面, 与 int 结合, 说明函数有一个整型变量参数, 然后再与外面的 * 结合, 说明函数返回的是一个指针, 然后到最外面一层, 先与[]结合,
说明返回的指针指向的是一个数组, 然后再与 * 结合, 说明数组里的元素是指针, 然后再与 int 结合, 说明指针指向的内容是整型数据。
所以 p 是一个参数为一个整数据且返回一个指向由整型指针变量组成的数组的指针变量的函数。
*/

//指向指定长度数组的指针
void PTR_ArrayPtr(void)
{
	int A[5] = {0,1,2,3,4};
	int (*p)[5];	//p 是一个指向长度为5的数组的指针；p+1跨越的字节数是5*sizeof(int)
	p = A;
	PRINT_ADV("地址A = %p , 地址p+1 = %p, 地址A+5 = %p\n , ", A, p+1, A+5); //p+1和A+5地址相同！
}

/*
int board[8][8];     //int 数组的数组
int ** ptr;          //指向 int 指针的指针
int * risks[10];     //具有 10 个元素的数组, 每个元素是一个指向 int 的指针
int (* rusks) [10];   //一个指针, 指向具有 10 个元素的 int 数组
int * oof[3][4];     //一个 3 x 4 的数组, 每个元素是一个指向 int 的指针
int (* uuf) [3][4];  //一个指针, 指向 3 X 4 的 int 数组
int (* uof[3]) [4];  //一个具有 3 个元素的数组, 每个元素是一个指向具有 4 个元素的int 数组的指针
 */

void mainPtrTest(void)
{
	PTR_Basic();
	PTR_PtrArray();
	PTR_DupPtr();
	PTR_FuncRetPtr();
	PTR_ArrayPtr();
}

//11.函数指针 //19-3-12
/*
 小窍门： 知道这个道理后，我对C语言中定义类型这件小事立马就一通百通了。
这个道理就是：定义的样子，和使用的时候的样子是一样一样的。
例如，int *p 的意思就是让 *p 为整形。那么 p 自然是指向整数的指针了。
int (*p)(int); 解析： (*p)(int) 是个整数，所以， *p 是个 返回整数的函数。而p就是指向这种函数的指针啦。
int *(*p)(int); 解析：*(*p)(int) 是个整数，所以 (*p)(int) 是个整数的指针。 所以 *p 是个函数，返回一个整数指针，所以p是个函数指针。
int (**p)(int); 再来检验一下：(**p)(int)是个整数。 **p 是个函数，返回一个整数。于是 *p 是个函数的指针。 p 是个函数指针的指针。
int *(*p[3])(int *); 解析： *(*p[3])(int *)是个整数，则(*p[3])是个函数，返回一个整数指针；则p[3]是个函数指针；则p是个函数指针数组(数组长度为3)的头；
int (*(*p)[3])(int *);解析：(*(*p)[3])(int *)是个整数, 则(*(*p)[3])是个函数，返回一个整数；则(*p)[3]是个函数指针； 则(*p)是个函数指针数组(数组长度为3)的数组头；因此p是一个指向函数指针数组(数组长度为3)的指针；
int *(*(*p)[3])(int *);解析，与上例类似，只是函数返回值是整形指针；
*/

char * PTRFUNC_Func1(char *ptr)
{
	PRINT_ADV("\n调用Func1, 打印值： %s", ptr);
	return(ptr);
}

char * PTRFUNC_Func2(char *ptr)
{
	PRINT_ADV("\n调用Func2, 打印值： %s", ptr);
	return(ptr);
}

char * PTRFUNC_Func3(char *ptr)
{
	PRINT_ADV("\n调用Func3, 打印值： %s", ptr);
	return(ptr);
}

void PTRFUNC_BasicTest(void)
{
	char * (*func)(char *);	//定义函数指针, 指向一个返回值为char指针类型,且形参为char指针的函数
	//char * (*func)(char *ptr);	//形参名ptr可省略
	func = PTRFUNC_Func1; //等价于func = &PTRFUNC_Func1;
	func("abc");

	func = &PTRFUNC_Func2;	//注意， 加&取地址作用相同!! ; 等价于func = PTRFUNC_Func2
	func("def");			//等价于 *func("ghi")

	func = PTRFUNC_Func3;
	*func("ghi");		//加不加*号是一样的; 等价于 func("ghi")

	//编译器发现func是个函数指针，因此会调用它所指向的函数，也就是说，解引用函数指针时可以用*，也可以不用；
	//同样获取函数地址时可以用&,也可以不用


}

void PTRFUNC_ArrayTest(void)
{
	//定义函数指针数组, 且不事先制定大小；静态分配
	char * (*funcArray[])(char *ptr) = {PTRFUNC_Func1, PTRFUNC_Func2 , PTRFUNC_Func3 };
	funcArray[2]("你好");

	//定义函数指针数组, 且不事先制定大小；动态分配
	typedef char * (*FuncArrType)(char *);	//注意用typedef的方式！！
	//typedef char * (*FuncArrType)(char *ptr);	//形参名ptr可省略
	FuncArrType funcArrayDyn[3];
	funcArrayDyn[0] = PTRFUNC_Func1;
	funcArrayDyn[1] = PTRFUNC_Func2;
	funcArrayDyn[2] = PTRFUNC_Func3;
	funcArrayDyn[1]("hello!");

	FuncArrType (*SupPtr)[3];	//结合PTR_ArrayPtr()这个函数理解，定义了一个指向函数指针数组的指针
	//char (*(*SupPtr)[3])(char *);	//另一种写法，但上面的写法更好理解
	SupPtr = funcArrayDyn;
	SupPtr[0][0]("abc");	//注意调用方式
	SupPtr[0][1]("abc");
	SupPtr[0][2]("abc");

}

//3-21 用Typedef定义函数指针
void PTRFUNC_TypeDef(void)
{
	int *(*A[5])(int, char*);
	typedef int *(*pFun)(int, char*);
	pFun B[5];	//A声明的简化版

	void (*C[10]) (void (*)());	//C为一个函数指针数组，其入参是一个返回值为void，入参也为void的函数指针；
	typedef void (*pFunParam)();	//先替换右边部分括号里的，用pFunParam作为其入参函数指针的别名;
	typedef void (*pFunx)(pFunParam); //再替换函数指针部分，pFunx 作为函数指针的别名
	pFunx D[10];	//现在D即是C声明的简化版
}


typedef char * PtrFunc(char *); //定义函数指针
//回调函数: 函数指针作为函数入参
void PTRFUNC_CallBackDef(PtrFunc *arr[], size_t arrSize, PtrFunc ptrFunc)
{
	  for (size_t i=0; i<arrSize; i++)
		  arr[i] = ptrFunc;
}


void PTRFUNC_CallBackTest(void)
{
	PtrFunc *arr[5];	//定义函数指针数组
	char charTemp[20];
	PTRFUNC_CallBackDef(arr, 5 ,PTRFUNC_Func1);
	for(int i = 0; i < 5; i++) {
		itoa(i,charTemp, 10);
		/*itoa()函数有3个参数：第一个参数是要转换的数字，第二个参数是要写入转换结果的目标字符串，第三个参数是转移数字时所用 的基数。
		 在上例中，转换基数为10。10：十进制；2：二进制...
		 itoa并不是一个标准的C函数，它是Windows特有的，如果要写跨平台的程序，请用sprintf。
		 是Windows平台下扩展的，标准库中有sprintf，功能比这个更强，用法跟printf类似：
		 */

		PRINT_ADV("\n %s",charTemp);
		arr[i](charTemp);
	}


}

void mainPtrFunc(void)
{
	//PTRFUNC_BasicTest();
	//PTRFUNC_ArrayTest();
	PTRFUNC_CallBackTest();
	PTRFUNC_TypeDef();
}

//12.循环
void mainTestLoop(void)
{
	for (int i = 0 ; i < 10; i++) {	//C99新语法，允许在for loop里定义临时循环变量，仅在循环体内有效；
		if (i % 2 == 0)
			continue;	//仅打印奇数
		PRINT_ADV("\n打印 第 %d" , i);
	}
	//PRINT_ADV(i); //会报错! 定义临时循环变量，仅在循环体内有效；
}

//13.字符串 //2019-3-14
void STR_Basic(void)
{
	//正确定义
	char str1[6] = {'H', 'e', 'l', 'l', 'o', '\0'};	//字符数组的大小比单词 "Hello" 的字符数多一个。
	PRINT_ADV("\n str1 内容： %s, 数组长度为: %d ， 字符串长度为： %d ", str1, sizeof(str1), strlen(str1));	//注意字符串长度和数组长度的区别

	char str2[] = "Hello"; //与上面等效，更方便
	PRINT_ADV("\n str2 内容： %s, 数组长度为: %d ， 字符串长度为： %d ", str2, sizeof(str2), strlen(str2));

	char str3[10] = "Hello";	//正确
	PRINT_ADV("\n str3 内容： %s, 数组长度为: %d ， 字符串长度为： %d ", str3, sizeof(str3), strlen(str3));

	char *str4 = "Hello";	//正确
	PRINT_ADV("\n str4 内容： %s, 数组长度为: %d ， 字符串长度为： %d ", str4, sizeof(str4), strlen(str4)); //注意此处sizeof返回的是指针的大小，并不是字符串数组的大小！！

	//不正确的定义：
	char str5[5] = {'H', 'e', 'l', 'l', 'o'};	//3,4种写法应该是不正规的写法，但是能运行无告警
	PRINT_ADV("\n str5 内容： %s, 数组长度为: %d ， 字符串长度为： %d ", str5, sizeof(str5), strlen(str5));	//??? 内容变成了 HelloHello, 为何?? //TODO
	char str6[] = {'H', 'e', 'l', 'l', 'o'};
	PRINT_ADV("\n str6 内容： %s, 数组长度为: %d ， 字符串长度为： %d ", str6, sizeof(str6), strlen(str6));	//??? 内容变成了 HelloHelloHello, 为何?? //TODO
	//打印出不正常的字符串都是没有’\0‘的字符串，也就是没有字符串结束标志，于是将内存中的随机值当字符串打印了出来，直到遇到了下一个字符串的’\0‘。

}

//与字符型char变量的区别
void STR_CharTest(void)
{
	char a = 'H'; //注意字符串数组和char类型的区别； char类型为单引号
	PRINT_ADV("\n char字符 a的值为 :  %c",a );

	char b = 'HE'; //不正确，虽然可以编译通过，但是溢出了
	PRINT_ADV("\n char字符 b的值为 :  %c",b );	 // 注意打印值为E了

	char c = "K"; //定义非法，虽然可以编译通过 , 但是溢出，打印值错误
	PRINT_ADV("\n char字符 c的值为 :  %c",c );	 // 注意打印值错误

	//char d[] = 'HE'; //定义非法，字符串数组应该用双引号"" 编译不过

	a = 'Q';	//char类型可以修改值
	PRINT_ADV("\n char字符 a的值为 :  %c",a );

}

//字符串的修改
void STR_Modify(void)
{
	//第一种定义方式
	//1.存放的内存区域不同； 第一种存放在常量区，不可修改 ; 2.第一种存放的是一个地址 ， sizeof 为指针的大小4；
	char *str1 = "abcdef";	//此种定义法定义了一个字符串常量；
	PRINT_ADV("\n str1 内容： %s, 长度为: %d", str1, sizeof(str1));
	//str1[0] = 'A';	//不可修改，会报错
	PRINT_ADV("\n str1 内容： %s, 长度为: %d", str1, sizeof(str1));

	//第二种定义方式
	//1.存放在栈中，可以修改 。2.存放的是字符串"abcdef"，因此使用sizeof是字符串数组的长度7；
	char str2[]="abcdef";	//此种定义法定义了一个字符串数组
	PRINT_ADV("\n str2 内容： %s, 长度为: %d", str2, sizeof(str2));
	str2[0] = 'A';
	PRINT_ADV("\n str2 内容： %s, 长度为: %d", str2, sizeof(str2));

}

void STR_Func(void)
{
	char str1[12] = "Hello";
	char str2[12] = "World";
	char str3[12];
	int  len1,len2 ;

	/* 复制 str1 到 str3 */
	strcpy(str3, str1);		//	strcpy(s1, s2); 复制字符串 s2 到字符串 s1。
	printf("\nstrcpy( str3, str1) :  %s\n", str3 );

	/* 连接 str1 和 str2 */
	strcat( str1, str2);	//strcat(s1, s2);连接字符串 s2 到字符串 s1 的末尾。
	printf("strcat( str1, str2):   %s\n", str1 );

	/* 连接后，str1 的总长度 */
	/*strlen 是函数，sizeof 是运算操作符，二者得到的结果类型为 size_t，即 unsigned int 类型。
	sizeof 计算的是变量的大小，不受字符 \0 影响；而 strlen 计算的是字符串的长度，以 \0 作为长度判定依据。	*/
	len1 = strlen(str1);	//strlen(s1);返回字符串 s1 的长度。不包括结束符  '\0'
	len2 = sizeof(str1)/sizeof(str1[0]);
	printf("strlen(str1) :  %d\n", len1 );	//注意和sizeof(s1)/sizeof(s1[0])的区别
	printf("sizeof(str1)/sizeof(str1[0]) :  %d\n", len2 );

	//比较函数：strcmp(s1, s2); 如果 s1 和 s2 是相同的，则返回 0；如果 s1<s2 则返回小于 0；如果 s1>s2 则返回大于 0。
	//注意，不要用1和-1去和结果比较，而要判断正负！！
	char s1[] = "abc";
	char s2[] = "abc";
	printf("\n strcmp(%s, %s) : %d", s1,  s2 , strcmp(s1,s2));
	s2[0] = 'B';
	printf("\n strcmp(%s, %s) : %d", s1,  s2 , strcmp(s1,s2));
	s1[0] = 'A';
	printf("\n strcmp(%s, %s) : %d", s1,  s2 , strcmp(s1,s2));

	//搜索函数，strchr(s1, ch);返回一个指针，指向字符串 s1 中字符 ch 的第一次出现的位置。
	char s3[] = "abcde";
	char ch = 'd';
	char *ptr1 = strchr(s3,ch);
	if (ptr1)
		printf("\n在 %s 中找到字符: %c ，  位置为 %d" ,s3, ch, ptr1 - s3);
	else
		printf("\n未在 %s 中找到字符: %c!", s3, ch);
	ch = 'f';
	ptr1 = strchr(s3,ch);
	if (ptr1)
		printf("\n在 %s 中找到字符: %c ，  位置为 %d" ,s3, ch, ptr1 - s3);
	else
		printf("\n未在 %s 中找到字符: %c!", s3, ch);

	//搜索函数2， strstr(s1, s2);返回一个指针，指向字符串 s1 中字符串 s2 的第一次出现的位置。
	char s4[] = "abcdefgh";
	char s5[] = "de";
	char *ptr2 = strstr(s3,s5);
	if (ptr2)
		printf("\n在 %s 中找到字符: %s ，  子串为: %s" ,s4, s5, ptr2);
	else
		printf("\n未在 %s 中找到字符: %s!", s4, s5);
	s5[1] = 'a';
	ptr2 = strstr(s4,s5);
	if (ptr2)
		printf("\n在 %s 中找到字符: %s ，  子串为: %s" ,s4, s5, ptr2);
	else
		printf("\n未在 %s 中找到字符: %s!", s4, s5);

}

void mainTestString(void)
{
	//STR_Basic();
	//STR_CharTest();
	//STR_Modify();
	STR_Func();
}

//14.结构体 19-3-17

void STRU_BasicDef(void)
{
	//1.用Stru1标签的结构体，同时又声明了结构体变量st1,st2;
	struct Stru1 {
		int a;
		float b;
	}st1,st2;

	//2.如下并没有标明其结构体标签, 声明了结构体变量st3,st4; 之后无法再声明相同类型的接头体变量；
	struct {
			int a;
			float b;
	}st3,st4;

	//3.定义标签为Stru2的结构体，后面再声明结构体变量st5,st6;
	struct Stru2 {
			int a;
			float b;
	};
	struct Stru2 st5,st6;

	//4.用typedef创建新类型Stru3, ,可以直接用Stru3作为类型声明新的结构体变量，用的最广泛
	typedef struct  {
				int a;
				float b;
	}Stru3;

	Stru3  st8 = {5, 4.2f};	//结构体成员初始化可以类似数组，但这种格式只能在定义的时候；定义之后只能挨个赋值或者用循环，不能再用大括号方式赋值
	Stru3 *ptr = &st8;
	//st8 = {6, 4.2f};	//这样会报错！
	printf("\n st8->a: %d", st8.a);
	printf("\n ptr->a: %d", ptr->a);	//注意结构体指针访问成员要用->
	printf("\n *ptr.a: %d", (*ptr).a);	//也可以对指针解引用再访问，如：*struct_pointer.title;


	//注意，以上四个结构体定义，虽然成员列表一模一样，但是都是不同的类型；如果另ptr = &st1是非法的

	//此结构体的声明包含了指向自己类型的指针,通常这种指针的应用是为了实现一些更高级的数据结构如链表和树等。
	typedef struct
	{
	    char string[10];
	    struct NODE *front_node;
	    struct NODE *rear_node;

	}NODE;

}

//结构体循环包含成员，需要对其中一个结构体进行不完整声明
void STRU_LoopDef(void)
{
	struct B;    //对结构体B进行不完整声明

	//结构体A中包含指向结构体B的指针
	struct A
	{
	    struct B *partner;
	    //other members;
	};

	//结构体B中包含指向结构体A的指针，在A声明完后，B也随之进行声明
	struct B
	{
	    struct A *partner;
	    //other members;
	};

}

//较复杂定义；嵌套结构体数组；
void STRU_DrawDef(void)
{
	//定义坐标
	typedef struct  {
		int posX;
		int posY;
	}StruPos;
	//定义颜色
	typedef struct  {
			int r;
			int g;
			int b;
	}StruColor;
	//定义画图结构体
	typedef struct  {
			int size;
			StruPos pos;
			StruColor color;
	}StruDraw;
	//声明结构体数组
	StruDraw draw[] = {		//元素个数可以不指定;编译时，系统会根据给出初值的结构体常量的个数来确定数组元素的个数
			//size大小  	//pos坐标		//color颜色
			{1,			{10,10},	{19,98,252}},
			{2,			{15,18},	{33,32,200}},
			{1,			{22,36},	{16,51,198}},
			{2,			{45,80},	{6,157,77}},
	};
	printf("\n draw[3].size : %d",draw[3].size);
	printf("\n draw[2].color.b : %d",draw[2].color.b);

	//用指针对结构体数组索引: 对于指针，ptr+i等效于ptr[i]
	StruDraw *ptr = draw;
	printf("\n (ptr+3)->size : %d",(ptr+3)->size);	//注意此处指针加法进行索引！ptr+i等效于ptr[i]
	printf("\n (ptr+2)->color. : %d",(ptr+2)->color.b);
	printf("\n ptr[3].size : %d",ptr[3].size);
	printf("\n ptr[2].color.b : %d",ptr[2].color.b);
}


//位域
void STRU_BitDef(void)
{
	// data1 为 bs 变量，共占两个字节。其中位域 a 占 8 位，位域 b 占 2 位，位域 c 占 4位, 一共为14bit,但short最小为16bit
	struct Data1{
	    short a:8;	//注意相应的bit位表示的10进制数的范围；这里为short是有符号型，有一个符号位；则表达范围为-64~63, 而不是0~127
	    short b:2;
	    short c:4;
	}data1 = {50,0,20};	//注意20超出了c的表达范围，会被截断！！
	printf("\n data1.a : %d , data1.b : %d ,data1.c : %d ", data1.a, data1.b, data1.c);
	printf("\n data1.a : %d , data1.b : %d ,data1.c : %d ", data1.a, data1.b, data1.c);
	printf("\n sizeof(data1) = %d", sizeof(data1));	//short int为2字节

	//注意short改为int类型后，结构体长度的变化
	struct Data2{
		int a:8;
		int b:2;
		int c:4;
	}data2 = {50,1,20};
	printf("\n data2.a : %d , data2.b : %d ,data2.c : %d ", data2.a, data2.b, data2.c);
	printf("\n sizeof(data2) = %d", sizeof(data2));	//注意与上面的区别，类型int为4字节

	//跨越单字节
	struct Data3{
		unsigned short a:4;	//unsighed short是无符号型，无符号位；则表达范围为0~15
		short 		   b:5;	//short是无符号型，有符号位；则表达范围为-16~15
		unsigned short c:4;
	}data3 = {15,-16,15};
	printf("\n data3.a : %d , data3.b : %d ,data3.c : %d ", data3.a, data3.b, data3.c);
	printf("\n sizeof(data3) = %d", sizeof(data3));	//注意位域可以跨单字节，但不可以跨越双字节,此处跨域了单字节，所以长度仍为2字节

	//不可跨越双字节
	struct Data4{
			unsigned short a:9;	//不可以跨越双字节
			unsigned short b:9;
			unsigned short c:9;
	}data4 = {15,20,15};
	printf("\n data4.a : %d , data4.b : %d ,data4.c : %d ", data4.a, data4.b, data4.c);
	printf("\n sizeof(data4) = %d", sizeof(data4));	//不可以跨越双字节，因此总大小为6个字节

	//有意使某位域从下一单元开始;位域可以是无名位域，这时它只用来作填充或调整位置。无名的位域是不能使用的。
	struct Data5{
			unsigned short a:4;
			unsigned short  :4;	//该4位不可使用
			unsigned short b:4; //* 从下一单元开始存放 */
	}data5 = {15,15}; //注意初始化参数的个数，中间无名位域不应初始化，否则会告警,也会使得后面的成员初始化不正确
	printf("\n data5.a : %d , data5.b : %d , ", data5.a, data5.b);
	printf("\n sizeof(data5) = %d", sizeof(data5));	//不可以跨越双字节，因此总大小为6个字节

}

//四字节对齐
void STRU_FourBitsAlign(void)
{
	//结构体内存大小对齐原则:
	//1.结构体变量的首地址能够被其最宽基本类型成员的大小所整除。
	//2.结构体每个成员相对于结构体首地址的偏移量(offset)都是成员大小的整数倍，如有需要编译器会在成员之间加上填充字节(internal adding)。即结构体成员的末地址减去结构体首地址(第一个结构体成员的首地址)得到的偏移量都要是对应成员大小的整数倍。
	//3.结构体的总大小为结构体最宽基本类型成员大小的整数倍，如有需要编译器会在成员末尾加上填充字节。
	typedef struct
	{
	    unsigned char a; 	//第1个字节存放a
	    unsigned int  b;	//int 占4个字节，因此上面空闲3个字节开始存放b
	    unsigned char c;	//第9个字节开始存放c;
	} debug_size1_t;
	typedef struct
	{
	    unsigned char a;	//第1个字节存放a
	    unsigned char b;	//第2个字节存放b;
	    unsigned int  c;	//空闲2个字节后存放c;
	} debug_size2_t;

	//1.debug_size1_t 存储空间分布为a(1byte)+空闲(3byte)+b(4byte)+c(1byte)+空闲(3byte)=12(byte)。
	//2.debug_size2_t 存储空间分布为a(1byte)+b(1byte)+空闲(2byte)+c(4byte)=8(byte)。
	printf("\n debug_size1_t size=%lu,debug_size2_t size=%lu\r\n", sizeof(debug_size1_t), sizeof(debug_size2_t));
}

void STRU_FourBitsAlign2(void)
{
	typedef struct {
		uint8 	a;		//存于第1~2字节,由于4字节对齐，第3~4字节填充FF;
		int32 	b[4];	//数组成员，占16字节，存于第5~20字节
		uint16 	c;		//存于第21~22字节，由于4字节对齐，后面第23~24填充FF:

	}Stru1;
	printf("\n Stru1大小为：%d 字节",sizeof(Stru1));	//大小为24
	typedef struct {
		uint8 	a;		//存于第1字节，第2字节填充FF;
		uint16 	b;		//存于第3~4字节:
		int32 	c[4];	//数组成员，占16字节，存于第5~20字节
	}Stru2;
	printf("\n Stru2大小为：%d 字节",sizeof(Stru2));	//大小为20,比上面要省空间
	typedef struct {
		uint8 	a;	//占4
		Stru1 	b;	//结构体占24
		uint16 	c;	//占4
	}Stru3;
	printf("\n Stru3大小为：%d 字节",sizeof(Stru3));
}

void mainStru(void)
{
	STRU_BasicDef();
	//STRU_LoopDef();
	//STRU_DrawDef();
	//STRU_IndexStruArray();
	//STRU_BitDef();
	STRU_FourBitsAlign();
	STRU_FourBitsAlign2();
}

//15.共用体(联合体)union
void UNI_BasicDef(void)
{
	//基本定义
	union Data1
	{
	   int i;
	   float f;
	   char  str[20];
	} data1;

	//共用体占用的内存应足够存储共用体中最大的成员。Data占20个字节（因为char str[20]变量占20个字节）,而不是各占4+4+20=28个字节。
	printf( "\n union 类型变量data1空间占用 : %d\n", sizeof(data1));

	//类似结构体，共用体也有内存对齐原则；共用体总大小为其最宽基本类型成员大小的整数倍，如有需要编译器会在成员末尾加上填充字节
	typedef union
		{
		   int i;
		   double f;	//double为8字节，因此该共用体总大小要为8的整数倍;
		   char  str[20];
	} Data2;
	Data2 data2;
	printf( "\n union 类型变量data2空间占用 : %d\n", sizeof(data2)); //注意大小不再为20，而是24，(8的整数倍)

	//类似结构体，共用体也可以定义位域！！
	union Data3{
			unsigned short a:8;	//不可以跨越双字节
			unsigned short b:8;
			unsigned short d:8;
			unsigned short e:8;
			unsigned short f:8;
			unsigned short g:8;
	}data3 = {15,20,15};
	printf("\n data4.a : %d , data4.b : %d ,data4.g : %d ", data3.a, data3.b, data3.g);
	printf("\n sizeof(data3) = %d", sizeof(data3));	//不可以跨越双字节，因此总大小为6个字节
}

void mainUnion(void)
{
	UNI_BasicDef();
}

//16.typedef
void mainTypedef(void)
{

	//基本用法
	typedef unsigned short uint16;
	uint16 x;
	printf("uint16 类型变量x长度为： %d", sizeof(x));

	//各个数据类型用typedef重新定以后的大小
	printf("\n sizeof(int8): 	%d", sizeof(int8));
	printf("\n sizeof(uint8): 	%d", sizeof(uint8));
	printf("\n sizeof(int16): 	%d", sizeof(int16));
	printf("\n sizeof(uint16): 	%d", sizeof(uint16));
	printf("\n sizeof(int32): 	%d", sizeof(int32));
	printf("\n sizeof(uint32): 	%d", sizeof(uint32));
	printf("\n sizeof(int64): 	%d", sizeof(int64));
	printf("\n sizeof(uint64): 	%d", sizeof(uint64));
	printf("\n sizeof(float32): %d", sizeof(float32));
	printf("\n sizeof(float64): %d", sizeof(float64));

	//数组也可以定义类型：
	typedef int Arr[6];
	Arr a;	//相当于 int a[6];
	printf("\n sizeof(a) = %d ", sizeof(a));

	/*
	//typedef vs #define
	//1.typedef 仅限于为类型定义符号名称，#define 不仅可以为类型定义别名，也能为数值定义别名，比如您可以定义 1 为 ONE。
	#define TRUE  1
	#define FALSE 0
	//2.typedef 是由编译器执行解释的，#define 语句是由预编译器进行处理的。
	//3.#define可以使用其他类型说明符对宏类型名进行扩展，但对 typedef 所定义的类型名却不能这样做。
	//如：
	#define INTERGE int;
	unsigned INTERGE n;  //没问题
	typedef int INTERGE;
	unsigned INTERGE n;  //错误，不能在 INTERGE 前面添加 unsigned
	//4.在连续定义几个变量的时候，typedef 能够保证定义的所有变量均为同一类型，而 #define 则无法保证。
	#define PTR_INT int *
	PTR_INT p1, p2;        //p1、p2 类型不相同，宏展开后变为int *p1, p2;
	typedef int * PTR_INT
	PTR_INT p1, p2;        //p1、p2 类型相同，它们都是指向 int 类型的指针。
	*/

}

//17.输入&输出
void IO_BasicFormat(void)
{
	float a = 16.32341;
	printf("\n a = %10.2f",a); //  %m.nf,右对齐，限定小数点为2位, 指定输出为10列，小数占其中的2列, 小数点占1列；因此输出16.32前面有5个空格;可以用来对齐
	printf("\n a = %-10.2f",a);	// %-m.nf,与上面类似，但是负号表明是左对齐；上面是右对齐; %-m.nf
}

void IO_Scanf(void)
{
	char str[100] = "";
	int i;

	int result = scanf("\n Enter a value : %s %d", str, &i);	//result返回值
	printf( "\n You entered: %s %d %d\n", str, i,result);
}

void IO_Scanf2(void)
{
	int a,b,c;
	printf("请输入三个整数：");
	int x=scanf("%d%d%d",&a,&b,&c);
	printf("%\n%d\n",a,x);
}


void mainCIO(void)
{

	//IO_BasicFormat();
	//IO_Scanf();
	IO_Scanf2();

}


//18.文件读写
//文件写入
void FILE_Write(void)
{
	// fopen( ) 函数来创建一个新的文件或者打开一个已有的文件
	//这个调用会初始化类型 FILE 的一个对象，类型 FILE 包含了所有用来控制流的必要的信息。
	/*
		模式	描述
		r	打开一个已有的文本文件，允许读取文件。
		w	打开一个文本文件，允许写入文件。如果文件不存在，则会创建一个新文件。在这里，您的程序会从文件的开头写入内容。如果文件存在，则该会被截断为零长度，重新写入。
		a	打开一个文本文件，以追加模式写入文件。如果文件不存在，则会创建一个新文件。在这里，您的程序会在已有的文件内容中追加内容。
		r+	打开一个文本文件，允许读写文件。
		w+	打开一个文本文件，允许读写文件。如果文件已存在，则文件会被截断为零长度，如果文件不存在，则会创建一个新文件。
		a+	打开一个文本文件，允许读写文件。如果文件不存在，则会创建一个新文件。读取会从文件的开头开始，写入则只能是追加模式。
	*/
	/*
	 如果处理的是二进制文件，则需使用下面的访问模式来取代上面的访问模式：
	"rb", "wb", "ab", "rb+", "r+b", "wb+", "w+b", "ab+", "a+b"
	*/
	/*
	注意！！
	只有用 r+ 模式打开文件才能插入内容，w 或 w+ 模式都会清空掉原来文件的内容再来写，
	a 或 a+ 模式即总会在文件最尾添加内容，哪怕用 fseek() 移动了文件指针位置。
	*/

	FILE *fp = NULL;

	//注意文件路径，必须是正斜杠即除号；复制路径时要注意反过来！！ 反斜杠被C用做转义符号
	fp = fopen("E:/_Projects/Personal/SVN/_Projects/Python/Study/C_Cpp_Learn/test.txt", "w+");//追加模式
	//对应目录中创建一个新的文件 test.txt，并使用两个不同的函数写入两行。注意两个函数效果相同，用法格式不同
	fprintf(fp, "This is testing for fprintf...\n");
	fputs("This is testing for fputs...\n", fp);
	fclose(fp);
}

//文件读取
void FILE_Read(void)
{
	FILE *fp = NULL;
	char buff[255];	//缓冲区大小

	/*
	 函数 fgets() 从 fp 所指向的输入流中读取 n - 1 个字符。它会把读取的字符串复制到缓冲区 buf，并在最后追加一个 null 字符来终止字符串。
	如果这个函数在读取最后一个字符之前就遇到一个换行符 '\n' 或文件的末尾 EOF，则只会返回读取到的字符，包括换行符。
	您也可以使用 int fscanf(FILE *fp, const char *format, ...) 函数来从文件中读取字符串，但是在遇到第一个空格字符时，它会停止读取。
	 */

	fp = fopen("E:/_Projects/Personal/SVN/_Projects/Python/Study/C_Cpp_Learn/test.txt", "r");
	fscanf(fp, "%s", buff);	//fscanf() 方法只读取了 This，因为它在后边遇到了一个空格。文件指针会向后移动；
	printf("1: %s\n", buff );

	fgets(buff, 255, (FILE*)fp);	//调用 fgets() 读取剩余的部分，直到行尾。文件指针会向后移动；
	printf("2: %s\n", buff );

	fgets(buff, 255, (FILE*)fp);	//最后，调用 fgets() 完整地读取第二行。
	printf("3: %s\n", buff );
	fclose(fp);
}

//fseek移动文件位置指针,同时利用r+模式用来插入内容
void FILE_Seek(void)
{
	/*
	fseek 可以移动文件指针到指定位置读,或插入写:
	int fseek(FILE *stream, long offset, int whence);
	fseek 设置当前读写点到 offset 处, whence 可以是 SEEK_SET,SEEK_CUR,SEEK_END 这些值决定是从文件头、当前点和文件尾计算偏移量 offset。
	你可以定义一个文件指针 FILE *fp,当你打开一个文件时，文件指针指向开头，你要指到多少个字节，只要控制偏移量就好，
	例如, 相对当前位置往后移动一个字节：fseek(fp,1,SEEK_CUR); 中间的值就是偏移量。
	如果你要往前移动一个字节，直接改为负值就可以：fseek(fp,-1,SEEK_CUR)
	*/
	FILE *fp = NULL;
	fp = fopen("E:/_Projects/Personal/SVN/_Projects/Python/Study/C_Cpp_Learn/test1.txt", "r+");  // 确保 test1.txt 文件已创建
	fprintf(fp, "This is testing for fprintf...\n");
	fseek(fp, 10, SEEK_SET);	//移动文件指针到开头偏移10个字节处
	if (fputc(65,fp) == EOF) {	//插入accii码为65的字符，即A
		printf("fputc fail");	//打开test1文件，结果为： This is teAting for fprintf... 即s被替换为A
	}

	fclose(fp);
	/*
	注意！！
	只有用 r+ 模式打开文件才能插入内容，w 或 w+ 模式都会清空掉原来文件的内容再来写，
	a 或 a+ 模式即总会在文件最尾添加内容，哪怕用 fseek() 移动了文件指针位置。
	*/
}

//二进制文件读写: fread和fwrite
//这两个函数都是用于存储块的读写 - 通常是数组或结构体。
void FILE_Binary(void)
{
	//如下演示了结构体数组的二进制文件读写
	//定义坐标
	typedef struct  {
		int posX;
		int posY;
	}StruPos;
	//定义颜色
	typedef struct  {
			int r;
			int g;
			int b;
	}StruColor;
	//定义画图结构体
	typedef struct  {
			int size;
			StruPos pos;
			StruColor color;
	}StruDraw;
	//声明结构体数组
	StruDraw draw[] = {		//元素个数可以不指定;编译时，系统会根据给出初值的结构体常量的个数来确定数组元素的个数
			//size大小  	//pos坐标		//color颜色
			{1,			{10,10},	{19,98,252}},
			{2,			{15,18},	{33,32,200}},
			{1,			{22,36},	{16,51,198}},
			{2,			{45,80},	{6,157,77}},
	};

	FILE * pFile;
	if((pFile = fopen ("myfile.txt", "wb+"))==NULL)
	{
		printf("cant open the file");
		exit(0);
	}

	//写入二进制文件，注意结构体只能一条一条数据写，不能一起写
	for(int i=0; i < (sizeof(draw)/sizeof(StruDraw));i++) {
		if(fwrite(&draw[i],sizeof(StruDraw),1,pFile)!=1)
			printf("file write error\n");
	}

	//如下将整个结构体数组一起写入二进制文件的方法会报错
	/*
	if(fwrite(draw,sizeof(StruDraw),(sizeof(draw)/sizeof(StruDraw)),pFile)!=1)
			printf("file write error\n");
	*/
	fclose (pFile);

	//读取刚才写入的二进制文件
	FILE * fp;
	StruDraw DrawTemp;
	if((fp=fopen("myfile.txt","rb"))==NULL) {
		printf("cant open the file");
		exit(0);
	}

	while(fread(&DrawTemp,sizeof(StruDraw),1,fp)==1) {   //如果读到数据，就显示；否则退出
		printf("\n {%d,			{%d,%d},	{%d,%d,%d}},",DrawTemp.size,DrawTemp.pos.posX,DrawTemp.pos.posY,
				DrawTemp.color.r,DrawTemp.color.g,DrawTemp.color.b);
	}
	fclose (fp);

}

void mainFile(void)
{
	FILE_Write();
	FILE_Read();
	FILE_Seek();
	FILE_Binary();
}

//19.预编译指令
void PRE_Basic(void)
{
	#define FILE_SIZE 50
	printf("\n FILE_SIZE is: %d",FILE_SIZE);

	//#undef: 在一个程序块中用完宏定义后，为防止后面标识符冲突需要取消其宏定义：
	//更多用法见https://blog.csdn.net/u014170067/article/details/53561821
	#undef  FILE_SIZE	//取消已定义的 FILE_SIZE
	#define FILE_SIZE 80	//重新定义为80
	printf("\n FILE_SIZE is: %d",FILE_SIZE);

	//如下代码展示#undef作用： 这样就只有在common.h中才能使用宏MAX
	/*
	#define MAX 50
	#include "common.h"
	#undef  MAX
	*/

	#define FILE_SIZE 100	//也可以直接重新定义
	printf("\n FILE_SIZE is: %d",FILE_SIZE);

	#ifdef DEBUG	//用于调试,可以在编译期间随时开启或关闭调试。
	   /* Your debugging statements here */
	#endif

	#ifndef MESSAGE	//只有当 MESSAGE 未定义时，才定义 MESSAGE。用于防止头文件重复包含
	   #define MESSAGE "You wish!"
	#endif
}

//#和##运算符; # 和 ## 运算符只在宏定义中有效
//#运算符：
// #运算符用于在预处理期将宏参数转换为字符串(它可以把语言符号（token）转化为字符串)
//它的转换作用是在预处理期完成的，因此只在宏定义中有效。编译器不知道 # 的转换作用
//可以将#操作理解为“stringization（字符串化）

//#运算符用途1：打印当前调用函数和参数
#define CALL(f, p) (printf("Call function %s(%s),\n", #f,#p), f(p))
int PRE_Square(int n)
{
    return n * n;
}

int PRE_Double(int x)
{
    return x * 2;
}

void PRE_SharpOpr(void)
{
	//#运算符实现了打印出它调用的函数名及运行参数
	int result = 0;
	int val = 4;
	result = CALL(PRE_Square, val);
	printf("result = %d\n", result);

	result = (printf("Call function %s\n", "PRE_Square"), PRE_Square(val));	//上面的展开，与上面等效，注意此种写法！
	printf("result = %d\n", result);

	result = CALL(PRE_Double, 5+5);
	printf("result = %d\n", result);
}

//#运算符用途2：填充结构
#define	FILL(a) {a, #a}
enum IDD { OPEN, CLOSE };
typedef struct MSG {
	enum IDD id;
	const char * msg;
}MSG;
void PRE_SharpOpr2(void)
{
	MSG _msg[] = { FILL(OPEN), FILL(CLOSE) };	//相当于： MSG _msg[] = { { OPEN, "OPEN" },{ CLOSE, "CLOSE" } };
}

//##运算符：将两个记号（例如标识符，Token）“粘”在一起，成为一个记号;
//如果其中一个操作数是宏参数，“粘合”会在当形式参数被相应的实际参数替换后发生。
//注意:无法通过##将函数名的字符串转换为函数执行
//注意2:凡宏定义里有用'#'或'##'的地方宏参数是不会再展开.

//##用途1:函数生成器
/*
 当MAX的参数有副作用时会无法正常工作。一种解决方法是用MAX宏来写一个max函数。
 遗憾的是，往往一个max函数是不够的。我们可能需要一个实际参数是int值的max函数，还需要参数为float值的max函数，等等。
 除了实际参数的类型和返回值的类型之外，这些函数都一样。因此，这样定义每一个函数似乎是个很蠢的做法。
 解决的办法是定义一个宏，并使它展开后成为max函数的定义。宏会有唯一的参数type，它表示形式参数和返回值的类型。
 这里还有个问题，如果我们是用宏来创建多个max函数，程序将无法编译。（C语言不允许在同一文件中出现两个同名的函数。）
 为了解决这个问题，我们是用##运算符为每个版本的max函数构造不同的名字。下面是宏的显示形式：
 */

#define GENERIC_MAX(type) \
type type##_max(type x, type y) \
{ \
	return x > y ? x : y; \
}
GENERIC_MAX(float)	//定义float_max函数,相当于float float_max(float x, float y) { return x > y ? x : y; }
GENERIC_MAX(int)	//定义float_int函数,相当于float int_max(int x, int y) { return x > y ? x : y; }
void PRE_Sharp2Opr(void)
{
	printf("Max of 2.3f and 3.2f is: %.2f\n", float_max(2.3f,3.2f));
}

//##用途2: 合并匿名变量名
#define	___ANONYMOUS1(type, var, line)   type	var##line
#define	__ANONYMOUS0(type, line)   ___ANONYMOUS1(type, _anonymous, line)
#define	ANONYMOUS(type)   __ANONYMOUS0(type, __LINE__)
void PRE_Sharp2Opr2(void)
{
	//问题：如何使用匿名变量？
	ANONYMOUS(static int);		//即: static int _anonymous1585;   1585表示该行行号；
}
//第一层：ANONYMOUS(static int);   -->   __ANONYMOUS0(static int, __LINE__);
//第二层：                        -->   ___ANONYMOUS1(static int, _anonymous, 70);
//第三层：                        -->   static int   _anonymous70;


#define COMBINE(a,b) a##b
void PRE_Sharp2Opr3(void)
{

	printf("2 and 3 is: %d\n", COMBINE(2,3));
	printf("ABC and DEF is: %X\n", COMBINE(0x2F,3D));	//16进制的组合,注意第二个参数不能带0x
	//printf("ABC and DEF is: %s\n", COMBINE("AB"));
}



void mainPre(void)
{
	//PRE_Basic();
	//PRE_SharpOpr();
	PRE_SharpOpr2();
	PRE_Sharp2Opr();
	PRE_Sharp2Opr2();
	PRE_Sharp2Opr3();
}

//20. 强制转换
//类型转换可以是隐式的，由编译器自动执行，也可以是显式的，通过使用强制类型转换运算符来指定。
//在编程时，有需要类型转换的时候都用上强制类型转换运算符，是一种良好的编程习惯。 这样，至少从程序上可以看出想干什么。
//无论是强制转换或是自动转换，都只是为了本次运算的需要而对变量的数据长度进行的临时性转换，而不改变数据说明时对该变量定义的类型。
void TRANS_Basic(void)
{
	//1.浮点转整型：将浮点数(单双精度)转换为整数时，将舍弃浮点数的小数部分， 只保留整数部分。
	float a = 3.22;
	int a_trans = (int) a;
	printf("\n 1.float转int: 转换前：%.2f, 转换后: %d ", a, a_trans);

	//2.浮点转无符号整型,实际上是先转为有符号整型截断小数，再将有符号整型转为无符号整型；
	float b = -3.22;
	uint16 b_trans = (uint16)b;	//先转为-3,再转为补码:65533
	printf("\n float转uint16: 转换前：%.2f, 转换后: %d ", b, b_trans);

	//3.整型值赋给浮点型变量，数值不变，只将形式改为浮点形式， 即小数点后带若干个0。注意：赋值时的类型转换实际上是强制的。
	uint8 c = 201;
	float c_trans = c;
	printf("\n uint8转float 转换前：%d, 转换后: %.2f ", c, c_trans);

	//4.有符号整型转为无符号整形
	//高位整型转低位整型时，多余高位会被截掉，保留低位；
	//将一个非unsigned整型数据赋给长度相同的unsigned型变量时， 内部存储形式不变，但外部表示时总是无符号的。
	int32 d = 0xAB12CDEF;
	uint16 d_trans = d;	//截断为0xCDEF, 按无符号整型解释；
	printf("\n int32转uint16 转换前：%d, 转换后: %d ", d, d_trans);

	//5.将char转为int
	//一些编译程序不管其值大小都作正数处理，而另一些编译程序在转换时，若char型数据值大于127，就作为负数处理。
	//对于使用者来讲，如果原来char型数据取正值，转换后仍为正值;如果原来char型值可正可负，则转换后也仍然保持原值， 只是数据的内部表示形式有所不同。
	char e = 211;	//若char型数据值大于127，则强转时就作为负数处理
	int e_trans = e;
	printf("\n char转int , 转换前：%d, 转换后: %d ", e, e_trans);


	/*
	有符号整型和无符号整形互转：
	计算机中数据用补码表示，int型量最高位是符号位，为1时表示负值，为0时表示正值。
	如果一个无符号数的值小于32768则最高位为0，赋给 int型变量后、得到正值。
	如果无符号数大于等于32768，则最高位为1， 赋给整型变量后就得到一个负整数值。
	反之，当一个负整数赋给unsigned 型变量时，得到的无符号值是一个大于32768的值。
	*/
	/*
	当较低类型的数据转换为较高类型时，一般只是形式上有所改变， 而不影响数据的实质内容，
	而较高类型的数据转换为较低类型时则可能有些数据丢失。
	*/
}

//运算时的类型转换
/*
如果一个运算符两边的运算数类型不同，先要将其转换为相同的类型，即较低类型转换为较高类型，然后再参加运算，转换规则如下图所示
double ← float 高
↑
long
↑
unsigned
↑
int ← char,short 低
图中横向箭头表示必须的转换，如两个float型数参加运算，虽然它们类型相同，但仍要先转成double型再进行运算，
结果亦为double型。 纵向箭头表示当运算符两边的运算数为不同类型时的转换，如一个long 型数据与一个int型数据一起运算，
需要先将int型数据转换为long型， 然后两者再进行运算，结果为long型。所有这些转换都是由系统自动进行的，
使用时你只需从中了解结果的类型即可。这些转换可以说是自动的，当然，C语言也提供了以显式的形式强制转换类型的机制。
*/
void TRANS_Promote(void)
{
	int16  a = -50;
	uint8 b = 245; /* ascii 值是 99 */
	printf("\n a+b = %d",a+b);

	float c = -50.5f;
	uint8 d = 250;
	printf("\n c+d = %.2f",c+d);
	printf("\n c+d = %d", c+d);	//注意！！，此处未显式强转。结果等于0！！ 为什么？
	printf("\n c+d = %d", (int)(c+d));	//应该显式强转
}

//结构体指针的强制转换;不能直接强转，需要通过指针实现
void TRANS_STRU(void)
{
	typedef struct{
		int8 a;
		int16 b;
	}Stru1;
	typedef struct{
		int16 a;
		int8 b;
	}Stru2;
	Stru1 st1 = {0xAB,0xCDEF};	//大端模式，存储为0xFFAB,0xCDEF (对齐原则，a的高位字节填充FF)
	Stru2 *ptr = (Stru2 *)&st1;	//ptr按照Stru2解释，分别为0xFFAB,0xEF
	printf("\n ptr->a: %d ", ptr->a);	//0xFFAB, -85
	printf("\n ptr->b: %d ", ptr->b);	//0xEF： -17
}
void mainEnforceTrans(void)
{
	TRANS_Basic();
	//TRANS_STRU();
	TRANS_Promote();
}

int main( int argc, char *argv[] ){
	//mainVaArgs();
	//mainCmpDateTime();
	//mainValueTrans();
	//mainIntDevide();
	//mainBoolTest();
	//mainValueAdr();
	//mainStoreType();
	//mainOper();
	//mainFuncTest();
	//mainArray();
	//mainPtrTest();
	//mainPtrFunc();
	//mainTestLoop();
	//mainTestString();
	//mainStru();
	//mainUnion();
	//mainTypedef();
	//mainCIO();
	//mainFile();
	//mainPre();
	mainEnforceTrans();
}

/*
 关于 main 函数的参数
 int main( int argc, char *argv[] )
 C程序在编译和链接后，都生成一个exe文件，执行该exe文件时，可以直接执行；也可以在命令行下带参数执行，命令行执行的形式为：
 可执行文件名称 参数1 参数2 ... ... 参数n。可执行文件名称和参数、参数之间均使用空格隔开。
如果按照这种方法执行，命令行字符串将作为实际参数传递给main函数。具体为：
 (1) 可执行文件名称和所有参数的个数之和传递给 argc；
 (2) 可执行文件名称（包括路径名称）作为一个字符串，首地址被赋给 argv[0]，参数1也作为一个字符串，首地址被赋给 argv[1]，... ...依次类推。
 */