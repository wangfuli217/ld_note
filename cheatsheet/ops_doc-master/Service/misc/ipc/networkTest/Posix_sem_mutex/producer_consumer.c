/*************************************************************************
	> File Name: producer_consumer.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Sun 20 Mar 2016 09:16:57 PM CST
 ************************************************************************/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <error.h>
#include <semaphore.h>
#include <sys/types.h>
#include <pthread.h>

#define ERR_EXIT(m) \
	do{\
		perror(m);\
		exit(EXIT_FAILURE);\
	}while(0)

#define PRODUCER_COUNT	(1)
#define CONSUMER_COUNT	(2)
#define STORE_MAX_SIZE	(20)
struct store 
{
	char buf[STORE_MAX_SIZE];
	int in;
	int	out;
	int store_max_size;
}Store;
pthread_t g_threads[PRODUCER_COUNT+CONSUMER_COUNT];

//匿名信号量
sem_t sem_full;
sem_t sem_empty;
//静态分配的pthread_mutex变量，以及初始化方法
pthread_mutex_t cp_mutex = PTHREAD_MUTEX_INITIALIZER;

void * produce(void *arg)
{
	char product = 'A';
	unsigned char i=0;
	while(1)
	{
		product ='A'+((i++)%26);
		

		sem_wait(&sem_empty);
		
		pthread_mutex_lock(&cp_mutex);
		Store.buf[Store.in] = product;
		Store.in = (Store.in +1)%Store.store_max_size;
		printf("producer %2d produce a product :%c\n",(int)arg,product);
		pthread_mutex_unlock(&cp_mutex);

		sem_post(&sem_full);
		usleep(500);

	}
}
void * consume(void * arg)
{
	char product;
	while(1)
	{
		sem_wait(&sem_full);
		pthread_mutex_lock(&cp_mutex);
		product = Store.buf[Store.out];
		Store.out = (Store.out +1)%Store.store_max_size;
		printf("consumer %d consumed a product %c\n",(int)arg,product);
		pthread_mutex_unlock(&cp_mutex);
		sem_post(&sem_empty);
		sleep(1);
	}
}
int main(int argc, char *argv[])
{
	int rslt;
	int i=0;

	Store.in = Store.out = 0;
	Store.store_max_size = STORE_MAX_SIZE;

	sem_init(&sem_full,0,0);
	sem_init(&sem_empty,0,STORE_MAX_SIZE);
	printf("*************************\n");
	for(i=0;i<PRODUCER_COUNT;i++)
	{
		rslt =pthread_create(&g_threads[i],NULL,produce,(void*)i);
		if(rslt != 0)
		{
			printf("thread producer creat error :%s\n",strerror(rslt));
			exit(EXIT_FAILURE);
		}
	}
	for(i=0;i<CONSUMER_COUNT;i++)
	{
		rslt = pthread_create(&g_threads[i+PRODUCER_COUNT],NULL,consume,(void *) (i+PRODUCER_COUNT));
		if(rslt != 0)
		{
			printf("thread producer creat error :%s\n",strerror(rslt));
			exit(EXIT_FAILURE);
		}
		
	}
	for(i=0;i< PRODUCER_COUNT+CONSUMER_COUNT;i++)
	{
		pthread_join(g_threads[i],NULL);
	}

	sem_destroy(&sem_full);
	sem_destroy(&sem_empty);
	pthread_mutex_destroy(&cp_mutex);
	return 0;
}
