
#include <fcntl.h>
#include <sys/stat.h>
#include <semaphore.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>

void mutex_init(sem_t * sem)
{
	sem_init(sem, 0, 1);// 空闲
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
		sleep(10);//处理进程间临界数据（如数据库写操作，文件写操作）
		mutex_unlock(sem);
		printf("pid[%d] have remove lock\n", getpid());
		sleep(1);
    }

    sem_close(sem);
    sem_destroy(sem);
}

/*
 * 参考VOS_Mutex.cpp实现
 * */
int main()
{
	pid_t pid;

    /* 创建和打开信号量 */
    const char *name = "/test2"; /* 必须是这种格式/somename */

    /* 必须删除，因为ctrl+c终止进程时，这个未删除导致永远阻塞 */
    if (sem_unlink(name) != -1)
        printf("sem_unlink %s success\n", name);

    pid = fork(); //创建进程
	if(pid<0) //出错
	{
		perror("fork error");
	}
	else if(pid == 0) //子进程
	{
		handle_mutex_operator(name);
	}
	else //父进程
	{
		handle_mutex_operator(name);
	}

    if (sem_unlink(name) != -1)
        printf("sem_unlink %s success\n", name);

    return 0;
}

