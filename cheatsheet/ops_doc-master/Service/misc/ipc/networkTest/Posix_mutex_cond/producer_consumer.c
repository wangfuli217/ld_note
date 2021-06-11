/*************************************************************************
	> File Name: producer_consumer.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Sun 20 Mar 2016 03:36:34 PM CST
 ************************************************************************/

#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <pthread.h>
#define PRODUCER_COUNT  (1)
#define CONSUMER_COUNT  (1)

#define ERR_EXIT(m)\
	do{\
		perror(m);\
		exit(EXIT_FAILURE);\
	}while(0)

int share_val = 0;
pthread_mutex_t g_mutex;
pthread_cond_t g_cond;
pthread_t g_threads[PRODUCER_COUNT+CONSUMER_COUNT];

void *consume(void * arg)
{
	int cosume_count =0;
	while(1)
	{
		if(cosume_count++ > 10)
		{
			break;
		}

/****************获取互斥锁*************************/
		pthread_mutex_lock(&g_mutex);
		while(share_val == 0)//无资源可消费
		{
			fprintf(stdout,"thread %d waiting for condition\n",(int)arg);
/****************等待条件变量*************************/
			pthread_cond_wait(&g_cond,&g_mutex);//此处会释放互斥锁
		}
		fprintf(stdout," thread %d end waiting for condition\n",(int)arg);
		fprintf(stdout," thread %d start consume\n",(int)arg);
		share_val--;
/****************释放互斥锁*************************/
		fprintf(stdout," thread %d end consume\n",(int)arg);

		pthread_mutex_unlock(&g_mutex);
		usleep(800);//sleeping for 800 ms


	}
	return NULL;
}

void *produce (void * arg)
{
	
	int produce_count =0;
	while(1)
	{
		if(produce_count++ > 10)
		{
			break;
		}
/****************获取互斥锁*************************/
		pthread_mutex_lock(&g_mutex);
		share_val++;

/****************发送条件变量信号*************************/
		pthread_cond_signal(&g_cond);
		printf("thread %d produce a product\n",(int)arg);
/****************释放互斥锁*************************/
		pthread_mutex_unlock(&g_mutex);
		usleep(2000);//sleeping for 2000 ms
	}
	return NULL;
}

int main(int argc , char * argv[])
{
	int i=0;
	int rslt;
	pthread_mutex_init(&g_mutex,NULL);
	pthread_cond_init(&g_cond,NULL);
	for(i=0;i<CONSUMER_COUNT; i++)
	{
		rslt = pthread_create(&g_threads[i],NULL,consume,(void *)i);
		if(rslt !=0 )
		{
			ERR_EXIT("comsumer pthread_create error\n");
		}
	}
	for(i=0;i<PRODUCER_COUNT; i++)
	{
		rslt = pthread_create(&g_threads[CONSUMER_COUNT+i],NULL,produce,(void*)(i+CONSUMER_COUNT));
		if(rslt !=0 )
		{
			ERR_EXIT("producer pthread_create error\n");
		}
	}
	for(i=0;i < PRODUCER_COUNT+CONSUMER_COUNT; i++)
	{
		pthread_join(g_threads[i],NULL);
	}
	pthread_mutex_destroy(&g_mutex);
	pthread_cond_destroy(&g_cond);
	
	return 0;
}
