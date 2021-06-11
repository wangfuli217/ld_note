//使用fork函数创建子进程
#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<sys/types.h>
int main(void)
{
	printf("main函数开始执行\n");
	pid_t pid=fork();
	if(-1==pid)
		perror("fork"),exit(-1);
	if(0==pid)  //子进程
	{
		printf("我是子进程%d,我的父进程是%d\n",getpid(),getppid());
		sleep(1);
		printf("我是子进程%d,我的父进程是%d\n",getpid(),getppid());
	}
	else
	{
		printf("我是父进程%d,我的子进程是%d\n",getpid(),pid);
	}
	return 0;
}
