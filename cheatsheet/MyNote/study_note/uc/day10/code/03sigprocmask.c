//sigprocmask函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<signal.h>
#include<unistd.h>
#include<sys/types.h>

void fa(int sig)
{
	printf("捕获到了信号是:%d\n",sig);
}
int main(void)
{
	//打印PID,设置信号2,3,50自定义处理
	printf("PID=%d\n",getpid());
	signal(2,fa);
	signal(3,fa);
	signal(50,fa);
	int res=sleep(20);
	if(0==res)
		printf("虽然没有信号屏蔽,但是没有人打扰到我\n");
	else
	{
		printf("没有信号屏蔽,睡眠被打断\n");
		printf("睡了%d秒\n",20-res);
	}
	printf("开始屏蔽信号...\n");
	//使用sigprocmask屏蔽信号2,3,50
	sigset_t set,old;
	//清空信号集
	sigemptyset(&set);
	sigemptyset(&old);
	//把信号2 3 50放入set集合中
	sigaddset(&set,2);
	sigaddset(&set,3);
	sigaddset(&set,50);
    res=sigprocmask(SIG_SETMASK,&set,&old);
	if(-1==res)
		perror("sigprocmask"),exit(-1);
	//查看设置之前默认屏蔽的信号
	printf("old=%ld\n",old);
	res=sleep(20);
	if(0==res)
		printf("设置信号的屏蔽后,美美的睡了一个好觉\n");
	sigset_t pend;
	//获取在信号屏蔽期间来过的信号
	sigpending(&pend);
	printf("pend=%ld\n",pend);
	if(sigismember(&pend,2))
		printf("信号2来过\n");
	if(sigismember(&pend,3))
		printf("信号3来过\n");
	if(sigismember(&pend,50))
		printf("信号50来过\n");
	printf("信号屏蔽被解除\n");
	sigprocmask(SIG_SETMASK,&old,NULL);
	return 0;
}
