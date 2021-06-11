/**
 * @file sem1.c
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/sem.h>
#include <unistd.h>
#include <pthread.h>

union semun {
    int              val;    /* Value for SETVAL */
    struct semid_ds *buf;    /* Buffer for IPC_STAT, IPC_SET */
    unsigned short  *array;  /* Array for GETALL, SETALL */
    struct seminfo  *__buf;  /* Buffer for IPC_INFO
                                (Linux-specific) */
};

#define SEM_KEY 7788

int number = -1;                 // 被保护的全局变量
int queue[1024] = {0};
pthread_mutex_t mutex;
int sem_id;

/* 设置信号量 */
int sem_init(int * sem_id)
{
	static union semun sem_union;
    sem_union.val = 1;
    if (semctl(*sem_id, 0, SETVAL, sem_union) == -1)
        return -1;
    return 0;
}

/* 信号量减1 */
int sem_wait(int * sem_id)
{
	struct sembuf sem_buf;
    sem_buf.sem_num = 0;
    sem_buf.sem_flg = SEM_UNDO;
    sem_buf.sem_op = -1;
    if (semop(*sem_id, &sem_buf, 1) == -1)
        return -1;
    return 0;
}

/* 改变信号量为1 */
int sem_post(int * sem_id)
{
	struct sembuf sem_buf;
    sem_buf.sem_num = 0;
    sem_buf.sem_flg = SEM_UNDO;
    sem_buf.sem_op = 1;
    if (semop(*sem_id, &sem_buf, 1) == -1)
        return -1;
    return 0;
}

/* 删除信号量 */
int sem_destroy(int * sem_id)
{
	static union semun sem_union;
	sem_union.val = 1;
    if (semctl(*sem_id, 0, IPC_RMID, sem_union) == -1)
        return -1;
    return 0;
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


int main(int argc,char *argv[])
{
    pthread_t id1, id2;

    //初始化锁
    pthread_mutexattr_t attr = {0};
    if( 0 != pthread_mutexattr_init(&attr) )
    {
        perror("pthread_mutexattr_init Error");
        return -1;
    }

    if( 0 != pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE ) )
    {
        perror("pthread_mutexattr_settype Error");
        return -1;
    }

    if( pthread_mutex_init(&mutex, &attr) )
    {
        perror("pthread_mutex_init Error");
        return -1;
    }

    /* 创建信号 */
    if ((sem_id = semget(SEM_KEY, 1, 0666 | IPC_CREAT)) == -1)
    {
        perror("semget Error");
        return -1;
    }

    if (sem_init(&sem_id) == -1)//信号量为1
    {
        perror("sem_init Error");
        return -1;
    }

    pthread_create(&id1, NULL, thread_read_fun, NULL);
    pthread_create(&id2, NULL, thread_write_fun, NULL);

    pthread_join(id1, NULL);
    pthread_join(id2, NULL);

    printf("main...\n");


    return EXIT_SUCCESS;
}
