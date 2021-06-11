#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
/*			通过信号量实现线程之间的互斥，其实它经常用在进程之间的互斥*/
void *thread_function(void *arg);
sem_t bin_sem;

#define WORK_SIZE 1024
char work_area[WORK_SIZE];

int main(void) 
{
    int res;
    pthread_t a_thread;
    void *thread_result;

    res = sem_init(&bin_sem, 0, 0);
    if (res != 0) 
	{
        perror("Semaphore initialization failed");
        exit(EXIT_FAILURE);
    }
    res = pthread_create(&a_thread, NULL, thread_function, NULL);
    if (res != 0)
	{
        perror("Thread creation failed");
        exit(EXIT_FAILURE);
    }

    printf("Input some text. Enter 'end' to finish\n");
    while(strncmp("end", work_area, 3) != 0) 
	{
		printf(">>>>>>>>>>>>>>>>d\n",bin_sem);
		if (strncmp(work_area, "fast",4 ) == 0) 
		{
		  sem_post(&bin_sem);
		  strcpy(work_area, "Wheeee...");
			printf("------------------%d\n",bin_sem);
		} 
		else 
		{
			printf("++++++++++++++++%d\n",bin_sem);
			//fgets会等待，知道界面输入数据，
			//当fgets接收到回车的时候，表示结束
		 	 fgets(work_area, WORK_SIZE, stdin);
			printf("++++++++++++++++%d\n",bin_sem);
		}
		printf("<<<<<<<<<<<<<<<<%d\n",bin_sem);
		sem_post(&bin_sem);
    }

    printf("\nWaiting for thread to finish...\n");
    res = pthread_join(a_thread, &thread_result);
    if (res != 0) 
	{
        perror("Thread join failed");
        exit(EXIT_FAILURE);
    }
    printf("Thread joined\n");
    sem_destroy(&bin_sem);
    exit(EXIT_SUCCESS);
}

void *thread_function(void *arg) 
{
	int icnt;
	
	printf("$$$$$$$$$$$$$$$$$$$%d\n",bin_sem);
    sem_wait(&bin_sem);
	printf("@@@@@@@@@@@@@@%d\n",bin_sem);
    while(strncmp("end", work_area, 3) != 0) 
	{
        printf("You input %d characters\n", strlen(work_area) -1);
		for(icnt=0;icnt<strlen(work_area) -1;icnt++)
		{
			printf("%c",work_area[icnt]);
		}
		printf("\n");
        sem_wait(&bin_sem);
    }
    pthread_exit(NULL);
}
