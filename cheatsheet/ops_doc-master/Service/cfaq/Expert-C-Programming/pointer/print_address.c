#include <stdio.h>
#include <stdlib.h>

int             global_variable;
static int      file_static_variable;

void func1(void)
{
int func1_variable;
static int func1_static_variable;

 printf("&func1_variable..%p\n", &func1_variable);
 printf("&func1_static_variable..%p\n", &func1_static_variable);
}

void func2(void)
{
 int func2_variable;

 printf("&func2_variable..%p\n", &func2_variable);
}

int main(void)
{
    int *p;

    /*输出指向函数的指针*/
    printf("&func1..%p\n", func1);
    printf("&func2..%p\n", func2);

    /*输出字符串常量的地址*/
    printf("string literal..%p\n", "abc");

    /*输出全局变量*/
    printf("&global_variable..%p\n", &global_variable);

    /*输出文件内的static 变量的地址*/
    printf("&file_static_variable..%p\n", &file_static_variable);

    /*输出局部变量*/
    func1();
    func2();

    /*通过malloc 申请的内存区域的地址*/
    p = malloc(sizeof(int));
    printf("malloc address..%p\n", p);

    return 0;
}

/*
> cc -c print_address.c
> nm print_address.o
0000000000000000 b file_static_variable
0000000000000000 T func1
0000000000000004 b func1_static_variable.2552
000000000000003a T func2
0000000000000004 C global_variable
000000000000005d T main
                 U malloc
                 U printf
                 
局部 static 变量 func1_static_variable 的后面被追加了.2552这样的标记，这是因为在
  同一个.o文件中，局部static变量的名称有可能会发生重复，所以在它后面追加了识别标记。
如果函数是在当前文件中定义的，就在其函数名后加 T；
如果函数定义在当前文件之外，只是在当前文件内部调用此函数，就在此函数后面加 U。       
*/

/*
 地　　址 	 内　　容 
 0x8048414 	 函数func1() 的地址
 0x8048440 	 函数func2() 的地址
 0x8048551 	 字符串常量 
 0x8049650 	 函数内的static 变量
 0x8049654 	 文件内static 变量
 0x804965c 	 全局变量 
 0x805b030 	 利用malloc() 分配的内存区域
 0xbfbfd9d8 	 func1() 中的自动变量
 0xbfbfd9d8 	 func2() 中的自动变量
 
 “指向函数的指针”和“字符串常量”被配置在非常近的内存区域。此外，函数内 static 变量、
 文件内 static 变量、全局变量等这些静态变量，也是被配置在非常近的内存区域。
 接下来就是 malloc() 分配的内存区域，它看上去和自动变量的区域离得很远。
 最后你可以发现，func1()和 func2()的自动变量被分配了完全相同的内存地址。
*/