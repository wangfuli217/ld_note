//使用互斥量解决多线程抢占资源的问题
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<pthread.h>
char *buf[5];  //字符指针数组,全局变量
int pos;	//指定上面数组的下标
//定义互斥量
pthread_mutex_t  mutex;
void *task(void *p)
{
	//使用互斥量进行加锁
	pthread_mutex_lock(&mutex);
	buf[pos]=(char *)p;
	sleep(1);
	pos++;
	//使用互斥量进行解锁
	pthread_mutex_unlock(&mutex);
}
int main(void)
{
	//初始化互斥量
	pthread_mutex_init(&mutex,0);
	//启动一个线程,向数组中存储内容
	pthread_t tid,tid2;
	pthread_create(&tid,NULL,task,"zhangfei");
	pthread_create(&tid2,NULL,task,"guanyu");
	//主线程进程开始等待,并且打印最终的结果
	pthread_join(tid,NULL);
	pthread_join(tid2,NULL);
	int i=0;
	printf("字符指针数组中的内容是:");
	//销毁互斥量
	pthread_mutex_destroy(&mutex);
	for(i=0;i<pos;i++)
		printf("%s ",buf[i]);
	printf("\n");
	return 0;
}
