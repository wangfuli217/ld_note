//alarm函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<signal.h>
#include<sys/types.h>
void fa(int signo)
{
	printf("捕获到了信号%d\n",signo);
	//设置1秒后发送信号
	alarm(1);
}
int main(void)
{
	//设置SIGALRM信号进行自定义处理
	signal(SIGALRM,fa);
	//设置5秒后发送SIGALRM信号
	int res=alarm(5);
	printf("res=%d\n",res);
	sleep(2);
	//重新修改为10秒后发送SIGALRM信号
	res=alarm(10);
	printf("res=%d\n",res);//3
	/*
	sleep(3);
	//重新设置为0秒后,取消之前的闹钟
	res=alarm(0);
	printf("res=%d\n",res); //7*/
	while(1);
	return 0;
}
