/*************************************************************************
	> File Name: thread_pool_test.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Mon 21 Mar 2016 10:28:38 AM CST
 ************************************************************************/
#include "thread_pool.h"
void *mytask(void *arg)
{
	int i = *(int*)arg;
	free(arg);
	//sleep(1);
	printf("thread 0x%x ,task %d is runing\n",pthread_self(),i);
}
int main(int argc, char *argv[])
{
	int i=0;
	int *arg;
	thread_pool_t pool;
	thread_pool_init(&pool,5);
	for(i=0;i<3;i++)
	{
		arg = (int *)malloc(sizeof(int));
		*arg = i;
		thread_pool_add_task(&pool,mytask,arg);
		//sleep(2);
	}
//	while(1);
	//sleep(5);
	thread_pool_destroy(&pool);
	return 0;

}

