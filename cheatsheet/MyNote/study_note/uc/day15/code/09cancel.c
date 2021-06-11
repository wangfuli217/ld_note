//线程取消函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>

void *task(void *p)
{
	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE,NULL);
//	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS,NULL);
	while(1)
	{
		printf("I am superman!\n");
		usleep(100000);
//		usleep(100000);
	}
}
void *task2(void *p)
{
	printf("开始取消线程...\n");
	usleep(300000);
	pthread_cancel(*(pthread_t*)p);
	printf("取消线程结束\n");
}
int main(void)
{
	pthread_t tid=0;
	//启动一个线程,不断进行打印
	pthread_create(&tid,NULL,task,NULL);
	//启动别外一个新线程,负责取消上述线程
	pthread_t tid2=0;
	pthread_create(&tid2,NULL,task2,&tid);
	//主线程等待子线程结束
	pthread_join(tid,NULL);
	pthread_join(tid2,NULL);
	return 0;
}
