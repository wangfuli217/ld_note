#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

/*ͨ���ź���ʵ���߳�֮��Ļ��⣬��ʵ���������ڽ���֮��Ļ���*/
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
ͨ���ź�����ʵ���߳�֮��Ļ��������
���߳����ȴ����ź�����Ȼ�󴴽��̡߳�

*/
int main(void)
{
    int res;
    pthread_t a_thread;
    void *thread_result;

	//�ź�����ʼ��
    res = sem_init(&bin_sem, 0, 0);
    if (res != 0) 
	{
        perror("Semaphore initialization failed");
        exit(EXIT_FAILURE);
    }
	//�����߳�
    res = pthread_create(&a_thread, NULL, thread_function, NULL);
    if (res != 0) 
	{
        perror("Thread creation failed");
        exit(EXIT_FAILURE);
    }
	printf("````````````%d\n",bin_sem);
    printf("Input some text. Enter 'end' to finish\n");
	//�Ƚ�ȫ�ֱ�����ֵ
    while(strncmp("end", work_area, 3) != 0) 
    {//�ӽ����ȡ����
        fgets(work_area, WORK_SIZE, stdin);
        sem_post(&bin_sem);
		printf("send semaphore \n");
    }
	//�ȴ��߳̽���
    printf("\nWaiting for thread to finish...\n");
    res = pthread_join(a_thread, &thread_result);
    if (res != 0)
	{
        perror("Thread join failed");
        exit(EXIT_FAILURE);
    }
	printf("@@@@@@@@@@@@@@%d\n",bin_sem);
    printf("Thread joined\n");
	//ע���ź���
    sem_destroy(&bin_sem);
    exit(EXIT_SUCCESS);
}

void *thread_function(void *arg) 
{
	//�ȴ��ź���

    sem_wait(&bin_sem);
	printf("------------------%d\n",bin_sem);
	//�ж�ȫ�ֱ���
	printf("wait semaphore \n");
    while(strncmp("end", work_area, 3) != 0)
	{
        printf("You input %d characters\n", strlen(work_area) -1);
        sem_wait(&bin_sem);
    }
	printf("++++++++++++++%d\n",bin_sem);
    pthread_exit(NULL);
}
