//pthread_detach函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<pthread.h>
void *print(void *p)
{
	int i=1;
	for(i=1;i<21;i++)
		printf("子线程中:%d\n",i);
}
int main(void)
{
	//启动一个子线程,打印1~20之间的数
	pthread_t tid=0;
	pthread_create(&tid,NULL,print,NULL);
	//分享子线程
	pthread_detach(tid);
	//主线程进行等待,然后打印1~20之间的数
	pthread_join(tid,NULL);
	int i=1;
	for(i=1;i<21;i++)
		printf("主线程中:%d\n",i);
	return 0;
}
