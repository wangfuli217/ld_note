//windows7中不可用，没有stty程序
#include <stdio.h>

main()
{
    int c;
    //终端驱动处于普通的一次一行模式
    system("stty raw");
    //现在终端驱动处于一次一字符模式
    c = getchar();

    system("stty cooked");
    //终端驱动又回到一次一行模式
}
