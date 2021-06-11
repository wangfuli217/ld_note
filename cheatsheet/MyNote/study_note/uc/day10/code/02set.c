//信号集的操作
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<signal.h>
int main(void)
{
	sigset_t set;
	printf("set=%ld\n",set);
	printf("sizeof(sigset_t)=%d\n",sizeof(sigset_t));
	//清空信号集
	sigemptyset(&set);
	printf("set=%ld\n",set);//0
	//增加信号到信号集中
	sigaddset(&set,2);
	printf("set=%ld\n",set);//2
	sigaddset(&set,3);
	printf("set=%ld\n",set);//6
	sigaddset(&set,7);
	printf("set=%ld\n",set);//70

	//从信号集中删除信号3
	sigdelset(&set,3);
	printf("set=%ld\n",set);
	if(sigismember(&set,2))
		printf("信号2存在\n");
	if(sigismember(&set,3))
		printf("信号3存在\n");
	if(sigismember(&set,7))
		printf("信号7存在\n");
	//填满信号集
	sigfillset(&set);
	printf("set=%ld\n",set);
	return 0;
}
