//各种exit函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
void show(void)
{
	printf("我就是被注册的函数\n");
}
int main(void)
{
	printf("main函数开始执行\n");
	//使用atexit函数注册
	atexit(show);
	//终止进程
	//exit(100);
	_Exit(100);
	printf("main函数结束\n");
	return 0;
}
