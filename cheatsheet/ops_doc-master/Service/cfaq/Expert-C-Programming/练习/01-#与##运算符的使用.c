####与##运算符的使用

####1.#运算符

    作用：进行字符串的转换
    作用域：只能在宏定义中使用
    示例：

#define fun(x) #x  //将x转化成为字符串

//逗号表达式是从左往右进行计算
#define CALL(f, p) (printf("Call function %s\n", #f), f(p))

int square(int n)
{
    return n * n;
}

int f1(int x)
{
    return x;
}

int main()
{
	//对上面的宏进行测试
    printf("%s\n", fun(hello world!));
    printf("%s\n", fun(100));
    printf("%s\n", fun(while));  //可以使用系统的命名
    printf("%s\n", fun(return));

    putchar(10);
    printf("%d\n", CALL(square, 4));
    printf("%d\n", CALL(f1, 10));

    return 0;
}

    使用gcc -E filename.c -o filename.i进行查看编译过程

int square(int n)
{
    return n * n;
}

int f1(int x)
{
    return x;
}

int main()
{
    printf("%s\n", "hello world!");
    printf("%s\n", "100");
    printf("%s\n", "while");
    printf("%s\n", "return");

    putchar(10);
    printf("%d\n", (printf("Call function %s\n", "square"), square(4)));
    printf("%d\n", (printf("Call function %s\n", "f1"), f1(10)));

    return 0;
}

    注：上面的程序的要求使用函数无法实现(#只能在宏定义中使用)，使用宏以及#可以很好的达到目的

####2.##运算符

    作用：在预编译期粘连两个符号
    作用域：只能在宏定义中使用
    示例：

#define NAME(n) name##n

//对于结构体的定义且重命名以简化使用
#if 0
typedef struct TEST
{
    int i;
    int j;
}test;

//typedef TEST test;
#endif

//用宏定义来执行上述操作，可以简化操作且更普遍的适用
#define STRUCT(type) typedef struct TEST##type type;\
struct TEST##type

STRUCT(student)
{
    char *name;
    int id;
};

int main()
{
	int NAME(1);
    int NAME(2);

    NAME(1) = 1;
    NAME(2) = 2;

    printf("%d\n", NAME(1));
    printf("%d\n", NAME(2));

    putchar(10);
    student s1, s2;

    s1.name = "s1";
    s1.id = 0;

    s2.name = "s2";
    s2.id = 1;

    printf("%s\n", s1.name);
    printf("%d\n", s1.id);
    printf("%s\n", s2.name);
    printf("%d\n", s2.id);
	return 0;
}

    使用gcc -E filename.c -o filename.i进行查看编译过程

typedef struct TESTstudent student;struct TESTstudent
{
    char *name;
    int id;
};
//可以在任何时候对结构体进行重命名，只要结构体被定义完成

int main()
{
	int name1;
    int name2;

    name1 = 1;
    name2 = 2;

    printf("%d\n", name1);
    printf("%d\n", name2);

    putchar(10);
    student s1, s2;

    s1.name = "s1";
    s1.id = 0;

    s2.name = "s2";
    s2.id = 1;

    printf("%s\n", s1.name);
    printf("%d\n", s1.id);
    printf("%s\n", s2.name);
    printf("%d\n", s2.id);
	return 0;
}