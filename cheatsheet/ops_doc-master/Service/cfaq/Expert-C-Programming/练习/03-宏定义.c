###宏定义

####1.define特点 1.#define表达式给有函数调用的假象，却不是函数 2.#define表达式可以比函数更强大 3.#define表达式比函数更容易出错

####2.宏定义函数

#define SWAP(a, b)  \
{                   \
    int temp = a;   \
    a = b;          \
    b = temp;       \
}

    上面的语句会对变量直接进行覆盖 函数不是真正意义上的交换，只是复制了一份

####3.宏定义表达式

    与函数的对比

    1.在于编译器被处理，编译器不知道宏表达式的存在 2.用“实参”完全替代形参，不进行任何计算 3.没有任何“调用”的开销 4.不能出现递归定义

#define SUM(a, b) (a)+(b)
#define MIN(a, b) ((a < b) ? a : b)

int main()
{
    int a = 2,
        b = 5;
    SWAP(a, b);
    printf("%d %d\n", a, b);
    printf("%d\n", SUM(a, b));  //是期望的值
    printf("%d\n", MIN(a, b));  //是期望的值
    printf("%d\n", SUM(a, b) * SUM(a, b));  //不是期望的值
    printf("%d\n", MIN(a++, b));  //不是期望的值
    return 0;
}

    问题：

    问什么上面的例子中最后的printf没有出现预想的值

    解决：

    编译器只是对宏定义进行了替换，替换后的结果如下：

#define SUM(a, b) (a)+(b)
#define MIN(a, b) ((a < b) ? (a) : (b))

int main()
{
    int a = 2,
        b = 5;
    SWAP(a, b);
    printf("%d %d\n", a, b);
    printf("%d\n", (2)+(5));  //是期望的值
    printf("%d\n", ((2<5) ? (2) : (5)));  //是期望的值
    printf("%d\n", (2)+(5) * (2)+(5));  //不是期望的值
    printf("%d\n", ((2++<5) ? (2++) : (5)));  //不是期望的值
    return 0;
}

    看了上面的预编译的程序后恍然大悟

    注意：

        避免在宏里面写表达式，而应该写计算数组的大小，因为函数无法做到

####4.系统宏定义和范围 1.系统的宏

1.__FILE__ 被编译的文件名
2.__LINE__ 当前行号
3.__DATE__ 编译时的日期
4.__TIME__ 编译时的时间
5.__STDC__ 编译是否遵循标准c规范

2.作用：

1.可以通过宏来使用上面的系统的宏定义日志追踪
2.如果使用函数会出现行号不匹配

3.扩展：

可以使用循环语句(do{}while(0))定义宏，do里面使用接续符链接语句，把多行语句接到一行里面

//#define LOG(s) printf("%s:%d %s\n", __FILE__, __LINE__, s);

/*
需要调用time.h
localtime:将时间转化为本地时间
asctime:将时间转换为正常(原本为毫秒)
*/
#define LOG(s) do{	\
	time_t t;		\
	struct tm* ti;	\
	time(&t);		\
	ti = localtime(&t);		\
	printf("%s[%s:%d] %s\n", asctime(ti), __FILE__, __LINE__, s);	\
}while(0)

/*
int f1(int a, int b)
{
	//#define 没有作用域的限制，需要#undef来结束，限制作用域
    #define _MIN_(a, b) ((a) < (b) ? a : b)
    return _MIN_(a, b);
    #undef
}

int f2(int a, int b, int c)
{
    return _MIN_(_MIN_(a, b), c);
}
*/
void f()
{
    LOG("Enter f()...\n");
    LOG("Exit f()...\n");
}

int main()
{
    LOG("Enter main...\n");
    f();
    LOG("Exit main...\n");
    return 0;
}

####5.注意：

    宏定义对空格比较敏感 #define f (x) ((x)-1)
    说明：上式宏定义了个f，他的需要被替换为x，但是后面又有个((x)-1)没有任何定义，所以会报错。