//计时器的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/time.h>
#include<signal.h>
void fa(int signo)
{
	printf("贪吃蛇移动了一步\n");
}
int main(void)
{
	//设置SIGALRM进行自定义处理
	signal(SIGALRM,fa);
	//定义结构体变量进行初始化
	struct itimerval timer;
	//设置启动时间
	timer.it_value.tv_sec=5;
	timer.it_value.tv_usec=0;
	//设置间隔时间
	timer.it_interval.tv_sec=1;
	timer.it_interval.tv_usec=300000;
	//设置真实计时器开始工作
	setitimer(ITIMER_REAL,&timer,NULL);
	while(1);
	return 0;
}
