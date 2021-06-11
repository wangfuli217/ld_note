#include <stdio.h>


///----------------------------------------------------
///		该函数主要用来解析命令
///		这样的处理一般在函数的入口处有作用
///		其实可以通过输入参数来对程序进行不同的
///		调试，通过不同的参数打开不同的开关
///		这样的调试有利于现场的快速调试
///----------------------------------------------------

int main(int argc, char *argv[])
{
    int arg;

    for(arg = 0; arg < argc; arg++)
	{
        if(argv[arg][0] == '-')
            printf("option: %s\n", argv[arg]+1);
        else
            printf("argument %d: %s\n", arg, argv[arg]);
    }
    exit(0);
}
