#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>

int number = -1;                 // 被保护的全局变量
int queue[1024] = {0};
pthread_mutex_t mutex;
sem_t sem_id;//模拟条件变量

void* thread_read_fun(void *arg)
{
    for(;;)
    {
		printf("thread_read_fun() sem wait\n");
		sem_wait(&sem_id);
		printf("thread_read_fun() sem wake up \n");
		pthread_mutex_lock(&mutex);
		for(;;)
		{
			if (-1 == number)
				break;
			printf("thread_read_fun() read the queue[%d] = %d\n", number, queue[number]);
			number--;
		}
		pthread_mutex_unlock(&mutex);
    }


    return NULL;
}

void* thread_write_fun(void *arg)
{
	for(int value = 0;;value++)
	{
		sleep(2);
		pthread_mutex_lock(&mutex);
		queue[++number] = value;
		pthread_mutex_unlock(&mutex);
		printf("thread_write_fun() sem post\n");
		sem_post(&sem_id);
	}

    return NULL;
}

/*
 * 参考VOS_PriMsgQueue.cpp实现
 * */
int main(int argc,char *argv[])
{
    pthread_t id1, id2;

    //初始化锁
    pthread_mutexattr_t attr = {0};
    if( 0 != pthread_mutexattr_init(&attr) )
    {
        perror("Error");
        return -1;
    }

//    if( 0 != pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE ) )
//    {
//        perror("Error");
//        return -1;
//    }

    if( pthread_mutex_init(&mutex, &attr) )
    {
        perror("Error");
        return -1;
    }

    sem_init(&sem_id, 0, 0);   // 繁忙
//    sem_init(&sem_id, 0, 1);   // 空闲

    pthread_create(&id1, NULL, thread_read_fun, NULL);
    pthread_create(&id2, NULL, thread_write_fun, NULL);

    pthread_join(id1, NULL);
    pthread_join(id2, NULL);

    printf("main...\n");


    return EXIT_SUCCESS;
}
