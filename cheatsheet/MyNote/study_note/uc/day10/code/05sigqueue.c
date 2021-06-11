//sigqueue函数和sigaction函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<signal.h>
void fa(int signo,siginfo_t *info,void *p)
{
	printf("进程%d发送来了信号%d,附加数据是:%d\n",info->si_pid,signo,info->si_value);
}
int main(void)
{
	//定义结构体变量进行初始化
	struct sigaction action={};
	//给第二个函数指针进行初始化
	action.sa_sigaction=fa;
	//给处理标志进行赋值
	//表示采用结构体中第二个函数指针处理
	action.sa_flags=SA_SIGINFO;
	//使用sigaction对信号40自定义处理
	sigaction(40,&action,NULL);
	//创建子进程给父进程发送信号和数据
	pid_t pid=fork();
	if(-1==pid)
		perror("fork"),exit(-1);
	if(0==pid)
	{
		int i=0;
		for(i=0;i<100;i++)
		{
			//定义联合进行初始化
			union sigval v;
			v.sival_int =i;
			//发送信号和附加数据
			sigqueue(getppid(),40,v);
		}
		sleep(1);
		_exit(100);//	终止子进程
	}
	while(1); //父进程等待处理信号和附加数据
	return 0;
}
