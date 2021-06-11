#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>

#define QUEUE_MAX 1024
int number = -1;                 // 被保护的全局变量
int queue[QUEUE_MAX] = {0};
pthread_mutex_t mutex;
sem_t sem_id;//模拟条件变量
sem_t sem_free;

void Sleep(long millseconds)
{
    struct timespec ts;
    ts.tv_sec  = millseconds / 1000;
    ts.tv_nsec = (millseconds % 1000) * 1000000;
    nanosleep( &ts, NULL );
}
int sem_wait_time(sem_t * sem, long millseconds)
{
	int ret = 0;
    timespec ts;
    if ( (ret = clock_gettime(CLOCK_REALTIME, &ts)) != -1)
    {
        ts.tv_sec  += (millseconds / 1000);
        ts.tv_nsec += 1 + (millseconds % 1000) * 1000;
        while(( ret = sem_timedwait(sem, &ts)) != 0 && errno == EINTR);
    }
    return (0 == ret);
}

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

        while( !(0 == sem_post(&sem_free)) )
        {
        	//printf("thread_read_fun() sem post free \n");
        	Sleep(1);
        }
        sleep(1);
    }


    return NULL;
}

void* thread_write_fun(void *arg)
{
	for(int value = 0;;value++)
	{
		//每次发送消息都会减1，直至负数时产生阻塞
		//等待超时可以打印信息来提示
#if 0
		while( !sem_wait_time(&sem_free, 1000) )
		{
			//printf("thread_write_fun() sem wait free \n");
			Sleep(1);
		}
#else
		sem_wait(&sem_free);
#endif
//		sleep(2);
		pthread_mutex_lock(&mutex);
		queue[++number] = value;
		pthread_mutex_unlock(&mutex);
		printf("thread_write_fun() sem post\n");
		sem_post(&sem_id);
	}

    return NULL;
}

/*
 * 参考VOS_MsgQueue.cpp实现
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

    //当发送远远 快于 接收处理时，消息队列会特别长，这就是控制消息队列长度
    //当消息队列中已近存在QUEUE_MAX值了，write接口会阻塞。
    sem_init(&sem_free, 0, QUEUE_MAX);

    pthread_create(&id1, NULL, thread_read_fun, NULL);
    pthread_create(&id2, NULL, thread_write_fun, NULL);

    pthread_join(id1, NULL);
    pthread_join(id2, NULL);

    printf("main...\n");


    return EXIT_SUCCESS;
}
