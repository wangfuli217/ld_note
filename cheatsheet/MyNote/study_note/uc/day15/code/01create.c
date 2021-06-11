//使用pthread_create函数实现线程的创建
#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
void* task(void *p)
{
	while(1)
		printf("我是子线程\n");
}
int main(void)
{
	//启动一个新的线程
	pthread_t tid;
	pthread_create(&tid,NULL,task,NULL);
	usleep(100000);
	return 0;
}
