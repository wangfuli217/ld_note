//pthread_join函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<pthread.h>
void *task(void *p)
{
	char *ps="周俊华是SB";
	return ps;
}
int main(void)
{
	//启动一个线程
	pthread_t tid=0;
	pthread_create(&tid,NULL,task,NULL);
	//主线程等待子线程的处理,并且获取返回值
	char *pc=NULL;
	pthread_join(tid,(void**)&pc);
	printf("%s\n",pc);
	return 0;
}
