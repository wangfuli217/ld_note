//父子进程之间的内存关系
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<unistd.h>
#include<string.h>
int i1=1;  //全局变量 全局区
int main(void)
{
	int i2=1;  //局部变量 栈区
	char *st=(char *)malloc(20); //指向堆区
	strcpy(st,"hello");
	//创建子进程
	pid_t pid=fork();
	if(-1==pid)
		perror("fork"),exit(-1);
	if(0==pid)   //子进程
	{
		i1=2;
		i2=2;
		st[0]='H';
		int i3=2;
		printf("子进程%d:i1=%d,i2=%d,i3=%d,st=%s\n",getpid(),i1,i2,i3,st);
		exit(0);
	}
	printf("父进程%d:i1=%d,i2=%d,st=%s\n",getpid(),i1,i2,st);
	return 0;
}
