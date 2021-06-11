#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>

int number = -1;
int queue[1024] = {0};
sem_t sem_mutex;//Ä£Äâ»¥³âËø
sem_t sem_id;//Ä£ÄâÌõ¼þ±äÁ¿

void mutex_init(sem_t * sem)
{
	sem_init(sem, 0, 1);// ¿ÕÏÐ
}

void mutex_lock(sem_t * sem)
{
	sem_wait(sem);
}

void mutex_unlock(sem_t * sem)
{
	sem_post(sem);
}

void* thread_read_fun(void *arg)
{
    for(;;)
    {
		printf("thread_read_fun() sem wait\n");
		sem_wait(&sem_id);
		printf("thread_read_fun() sem wake up \n");
		mutex_lock(&sem_mutex);
		for(;;)
		{
			if (-1 == number)
				break;
			printf("thread_read_fun() read the queue[%d] = %d\n", number, queue[number]);
			number--;
		}
		mutex_unlock(&sem_mutex);
    }


    return NULL;
}

void* thread_write_fun(void *arg)
{
	for(int value = 0;;value++)
	{
		sleep(2);
		mutex_lock(&sem_mutex);
		queue[++number] = value;
		mutex_unlock(&sem_mutex);
		printf("thread_write_fun() sem post\n");
		sem_post(&sem_id);
	}

    return NULL;
}


int main(int argc,char *argv[])
{
    pthread_t id1, id2;

    sem_init(&sem_id, 0, 0);   // ·±Ã¦
//    sem_init(&sem_id, 0, 1);   // ¿ÕÏÐ

    mutex_init(&sem_mutex); // ¿ÕÏÐ

    pthread_create(&id1, NULL, thread_read_fun, NULL);
    pthread_create(&id2, NULL, thread_write_fun, NULL);

    pthread_join(id1, NULL);
    pthread_join(id2, NULL);

    printf("main...\n");


    return EXIT_SUCCESS;
}
