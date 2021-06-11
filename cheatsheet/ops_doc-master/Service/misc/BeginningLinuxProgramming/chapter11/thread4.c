#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

/*通过信号量实现线程之间的互斥，其实它经常用在进程之间的互斥*/
void *thread_function(void *arg);
sem_t bin_sem;
/*
fgets
getchar
getline
*/
//  sem_init    sem_post     sem_wait   sem_destroy
#define WORK_SIZE 1024
char work_area[WORK_SIZE];

/*
通过信号量来实现线程之间的互斥操作，
主线程首先创建信号量，然后创建线程。

*/
int main(void)
{
    int res;
    pthread_t a_thread;
    void *thread_result;

	//信号量初始化
    res = sem_init(&bin_sem, 0, 0);
    if (res != 0) 
	{
        perror("Semaphore initialization failed");
        exit(EXIT_FAILURE);
    }
	//创建线程
    res = pthread_create(&a_thread, NULL, thread_function, NULL);
    if (res != 0) 
	{
        perror("Thread creation failed");
        exit(EXIT_FAILURE);
    }
	printf("````````````%d\n",bin_sem);
    printf("Input some text. Enter 'end' to finish\n");
	//比较全局变量的值
    while(strncmp("end", work_area, 3) != 0) 
    {//从界面获取参数
        fgets(work_area, WORK_SIZE, stdin);
        sem_post(&bin_sem);
		printf("send semaphore \n");
    }
	//等待线程结束
    printf("\nWaiting for thread to finish...\n");
    res = pthread_join(a_thread, &thread_result);
    if (res != 0)
	{
        perror("Thread join failed");
        exit(EXIT_FAILURE);
    }
	printf("@@@@@@@@@@@@@@%d\n",bin_sem);
    printf("Thread joined\n");
	//注销信号量
    sem_destroy(&bin_sem);
    exit(EXIT_SUCCESS);
}

void *thread_function(void *arg) 
{
	//等待信号量

    sem_wait(&bin_sem);
	printf("------------------%d\n",bin_sem);
	//判断全局变量
	printf("wait semaphore \n");
    while(strncmp("end", work_area, 3) != 0)
	{
        printf("You input %d characters\n", strlen(work_area) -1);
        sem_wait(&bin_sem);
    }
	printf("++++++++++++++%d\n",bin_sem);
    pthread_exit(NULL);
}
