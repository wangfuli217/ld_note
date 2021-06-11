//waitpid的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/wait.h>
int main(void)
{
	pid_t pid1=0,pid2=0;
	pid1=fork();
	if(-1==pid1)
		perror("fork"),exit(-1);
	if(0!=pid1)
		pid2=fork();
	//printf("一共有几个进程呢?\n");
	if(0==pid1)
	{
		printf("子进程一%d开始运行\n",getpid());
		sleep(5);
		printf("子进程一终止\n");
		exit(100);
	}
	if(0==pid2)
	{
		printf("子进程二%d开始运行\n",getpid());
		sleep(10);
		printf("子进程二结束\n");
		exit(200);
	}
	printf("父进程开始等待\n");
	int status=0;
	int res=waitpid(pid1,&status,0);
	if(res==-1)
		perror("waitpid"),exit(-1);
	printf("父进程等待结束\n");
	if(WIFEXITED(status))
	{
		printf("等到的子进程是%d,子进程的退出码是%d\n",res,WEXITSTATUS(status));
	}
	return 0;
}
