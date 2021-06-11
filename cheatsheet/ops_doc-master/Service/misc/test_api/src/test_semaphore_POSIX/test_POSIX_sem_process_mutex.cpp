
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>

void mutex_init(sem_t * sem)
{
	sem_init(sem, 0, 1);// ����
}

void mutex_lock(sem_t * sem)
{
//	sem_wait(sem);
	while( sem_wait(sem) != 0 )
	{
		perror("sem_wait Error");
	}
}

void mutex_unlock(sem_t * sem)
{
	sem_post(sem);
}

void handle_mutex_operator(const char * name)
{
    sem_t *sem = NULL;
    sem = sem_open(name, O_CREAT, 0666, 1);
    if (sem == SEM_FAILED) {
        perror("sem_open create failed");
    }
    printf("sem_open %s success\n", name);

    for (;;)
    {
    	printf("pid[%d] ready to get lock\n", getpid());
		mutex_lock(sem);
		printf("pid[%d] have got lock\n", getpid());
		sleep(10);//������̼��ٽ����ݣ������ݿ�д�������ļ�д������
		mutex_unlock(sem);
		printf("pid[%d] have remove lock\n", getpid());
		sleep(1);
    }

    sem_close(sem);
    sem_destroy(sem);
}

/*
 * �ο�VOS_Mutex.cppʵ��
 * */
int main()
{
	pid_t pid;

    /* �����ʹ��ź��� */
    const char *name = "/test2"; /* ���������ָ�ʽ/somename */

    /* ����ɾ������Ϊctrl+c��ֹ����ʱ�����δɾ��������Զ���� */
    if (sem_unlink(name) != -1)
        printf("sem_unlink %s success\n", name);

    pid = fork(); //��������
	if(pid<0) //����
	{
		perror("fork error");
	}
	else if(pid == 0) //�ӽ���
	{
		handle_mutex_operator(name);
	}
	else //������
	{
		handle_mutex_operator(name);
	}

    if (sem_unlink(name) != -1)
        printf("sem_unlink %s success\n", name);

    return 0;
}

