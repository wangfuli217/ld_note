#include <stdio.h>
#include <unistd.h>
//#include <sys/types.h>
//#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>

int daemon( int nochdir,  int noclose )
{
	pid_t pid;
	if ( !nochdir && chdir("/") != 0 ) //如果nochdir=0,那么改变到"/"根目录
		return -1;

	if ( !noclose ) //如果没有noclose标志
	{
		int fd = open("/dev/null", O_RDWR);
		if ( fd  <  0 )
		return -1;

		/* 重定向标准输入、输出、错误 到/dev/null，
			键盘的输入将对进程无任何影响，进程的输出也不会输出到终端
		*/
//		dup2(fd, 0);
//		dup2(fd, 1);
//		dup2(fd, 2);
//		close(fd);
	}

   pid = fork();  //创建子进程.
   if (pid  <  0)  //失败
	  return -1;

   if (pid > 0)
	   exit(0); //返回执行的是父进程,那么父进程退出,让子进程变成真正的孤儿进程.

	//创建的 daemon子进程执行到这里了
   if ( setsid()  < 0 )   //创建新的会话，并使得子进程成为新会话的领头进程
	  return -1;

   return 0;  //成功创建daemon子进程
}

int main()
{
	printf("start pgrp = %d, pgid = %d, pid = %d, sid = %d.\n", getpgrp(), getpgid(getpid()), getpid(), getsid(getpid()));

	daemon(0,0);

	printf("enddd pgrp = %d, pgid = %d, pid = %d, sid = %d.\n", getpgrp(), getpgid(getpid()), getpid(), getsid(getpid()));

	while(1)
	{
		printf("sleep...\n");
		sleep(10);
	}

	return 0;
}
