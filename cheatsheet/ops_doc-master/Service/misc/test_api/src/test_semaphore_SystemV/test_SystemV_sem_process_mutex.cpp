/**
 * @file sem1.c
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/sem.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/stat.h>
#include <errno.h>

union semun
{
	int val;
	struct semid_ds *buf;
	ushort *array;
};

#define SEM_KEY 7788

int number = -1;                 // 被保护的全局变量
int queue[1024] = {0};
pthread_mutex_t mutex;
int sem_id;

/* 设置信号量 */
int sem_init(int * sem_id)
{
	static union semun sem_union = {0};
    sem_union.val = 1;
    if (semctl(*sem_id, 0, SETVAL, sem_union) == -1)
    {
    	perror("semctl Error");
    	exit(0);
        return -1;
    }
    return 0;
}

/* 信号量减1 */
int sem_wait(int * sem_id)
{
	struct sembuf sem_buf = {0};
    sem_buf.sem_num = 0;
    sem_buf.sem_flg = SEM_UNDO;
    sem_buf.sem_op = -1;
    if (semop(*sem_id, &sem_buf, 1) == -1)
    {
    	perror("semop Error");
    	exit(0);
        return -1;
    }
    return 0;
}

/* 改变信号量为1 */
int sem_post(int * sem_id)
{
	struct sembuf sem_buf = {0};
    sem_buf.sem_num = 0;
    sem_buf.sem_flg = SEM_UNDO;
    sem_buf.sem_op = 1;
    if (semop(*sem_id, &sem_buf, 1) == -1)
    {
    	perror("semop Error");
    	exit(0);
        return -1;
    }
    return 0;
}

/* 删除信号量 */
int sem_destroy(int * sem_id)
{
	static union semun sem_union = {0};
	sem_union.val = 1;
    if (semctl(*sem_id, 0, IPC_RMID, sem_union) == -1)
    {
    	perror("semctl Error");
    	exit(0);
        return -1;
    }
    return 0;
}

void mutex_init(int * sem)
{
	sem_init(sem);// 空闲
}

void mutex_lock(int * sem)
{
	while( sem_wait(sem) != 0 )
	{
		perror("sem_wait Error");
	}
}

void mutex_unlock(int * sem)
{
	sem_post(sem);
}

void handle_purge(key_t key)
{
    int sem_id = semget(key, 1, 0);
    if( -1 == sem_id )
    {
    	perror("semget Error");
    }

    if ( semctl(sem_id, 1, IPC_RMID) < 0)
    {
    	perror("semctl Error");
    }
}

int handle_mutex_operator(key_t key)
{
    /* 创建信号 */
	sem_id = semget(key, 1, IPC_CREAT | IPC_EXCL | 0666);
    if (sem_id < 0)
    {
        perror("semget Error");
    	if(EEXIST == errno)
    	{
    		sem_id = semget(key, 1, 0);//第二次走该流程，获取信号量
    		if(sem_id < 0 )
    		{
    			perror("semget Error");
    			return -1;
    		}
    	}
    	else
    		return -1;
    }
    else
    {
    	mutex_init(&sem_id);//第一次走该流程，创建信号量，必须初始化值为1
    }
    printf("semget sem_id = %d\n", sem_id);

    for (;;)
    {
    	printf("pid[%d] ready to get lock\n", getpid());
		mutex_lock(&sem_id);
		printf("pid[%d] have got lock\n", getpid());
		sleep(10);//处理进程间临界数据（如数据库写操作，文件写操作）
		mutex_unlock(&sem_id);
		printf("pid[%d] have remove lock\n", getpid());
    }

    if ( semctl(sem_id, 1, IPC_RMID) < 0)
    {
    	perror("semctl Error");
    }
}

/*
 * 参考VOS_Mutex.cpp实现
 * */
int main(int argc,char *argv[])
{
	pid_t pid;
	key_t key;

#if 1
	const char * path = "./test.mutex";

	if (-1 == access(path,F_OK))
	{
		if ( 0 != mkdir(path, S_IRWXU) )
		{
			perror("mkdir Error");
			return -1;
		}
	}

	key = ftok(path, 'x');
	if ( key == -1 )
	{
		perror("ftok Error");
		return -1;
	}
#else
	key = SEM_KEY;
#endif

	handle_purge(key);//将过去遗留的信号量信息删除

    pid = fork(); //创建进程
	if(pid<0) //出错
	{
		perror("fork error");
	}
	else if(pid == 0) //子进程
	{
		handle_mutex_operator(key);
	}
	else //父进程
	{
		handle_mutex_operator(key);
	}

    printf("main...\n");


    return EXIT_SUCCESS;
}
