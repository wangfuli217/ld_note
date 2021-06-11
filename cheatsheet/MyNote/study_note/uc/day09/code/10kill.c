//使用kill函数发送信号
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<signal.h>
#include<sys/types.h>
void fa(int sign)
{
	printf("捕获到的信号是%d\n",sign);
}
int main(void)
{
	//使用fork函数创建一个子进程
	pid_t pid=fork();
	if(-1==pid)
		perror("fork"),exit(-1);
	if(0==pid)
	{
		//设置对信号50进行自定义处理
		signal(50,fa);
		while(1);
	}
	//判断子进程是否存在
	sleep(1);
	if(0==kill(pid,0))
	{
		printf("父进程发送信号50\n");
		kill(pid,50);
	}
	return 0;
}
