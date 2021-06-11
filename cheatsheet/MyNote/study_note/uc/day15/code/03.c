#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<pthread.h>
void *task(void *p)
{
	*(int *)p=200;
}
int main(void)
{
	int num=100;   //局部变量,栈区
	//启动子线程修改num的值
	pthread_t tid;
	pthread_create(&tid,NULL,task,&num);
	//主线程打印num的值
	sleep(1);
	printf("主线程中:num= %d\n",num);
	return 0;
}
