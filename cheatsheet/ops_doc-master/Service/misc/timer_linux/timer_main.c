/*************************************************************************
	> File Name: time_main.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Fri 28 Nov 2014 03:57:02 PM CST
 ************************************************************************/

#include <stdio.h>
#include <signal.h>
#include <errno.h>
#include <string.h>
#include <sys/time.h>

void PrintMsg(int Num)
{
    printf("%s\n", "Hello World");
    return;
}

int main(int argc,char *argv[])
{

	signal(SIGALRM, PrintMsg);

	struct itimerval tick;
	tick.it_value.tv_sec = 10;  //十秒钟后将启动定时器
	tick.it_value.tv_usec = 0;
	tick.it_interval.tv_sec = 1; //定时器启动后，每隔1秒将执行相应的函数
	tick.it_interval.tv_usec = 0;

	//setitimer将触发SIGALRM信号
	int ret = setitimer(ITIMER_REAL, &tick, NULL);
	if (ret != 0)
	{
		printf("Set timer error. %s \n", strerror(errno));
		return -1;
	}
	printf("Wait!\n");
	getchar();
	return 0;
}
