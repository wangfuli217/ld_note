#include "m2.h"
#include "m1.h"
/**
 * macro 的输出值觉得gcc预编译的顺序，这个项目也就是include 头文件的顺序
 */

#define macro 999 /* 宏的定义作用域到main.c文件尾 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	printf("macro: %d\n", macro);
	
	show();
	
	system("pause");
	
	return 0;
}
