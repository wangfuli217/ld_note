//使用raise函数发送信号
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<signal.h>
void fa(int sign)
{
	printf("捕获到了信号%d\n",sign);
}
int main(void)
{
	signal(SIGINT,fa);
	int res=sleep(10);
	if(0==res)
		printf("总算美美的睡了个好觉\n");
	else
		printf("只睡了%d秒\n",10-res);
	raise(SIGINT);
	while(1);
	return 0;
}
