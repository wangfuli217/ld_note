#include<stdio.h>
#include<stdlib.h>
#include<signal.h>
#include<sys/types.h>
#include<unistd.h>
void fa(int sign)
{
	printf("捕获到信号%d\n",sign);
}
int main(void)
{
	signal(SIGINT,fa);
	signal(SIGQUIT,SIG_IGN);
	pid_t pid=fork();
	if(pid==-1)
		perror("fork"),exit(-1);
	if(pid==0)
	{
		printf("子进程%d开始执行\n",getpid());
		while(1);
	}
	printf("父进程结束\n");
	return 0;
}
