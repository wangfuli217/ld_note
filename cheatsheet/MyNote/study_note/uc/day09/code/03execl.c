//vfork函数和execl函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
int main(void)
{
	pid_t pid=vfork();
	if(-1==pid)
		perror("vfork"),exit(-1);
	if(0==pid)
	{
		printf("子进程%d开始执行\n",getpid());
		sleep(3);
		execl("./test","./test",NULL);
		printf("子进程结束\n");
		_exit(100);
	}
	printf("父进程%d开始执行\n",getpid());
	printf("父进程结束\n");
	return 0;
}
