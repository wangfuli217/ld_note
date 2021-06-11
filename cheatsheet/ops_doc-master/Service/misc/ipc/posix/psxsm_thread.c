#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <time.h>
#include <assert.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>
#include <string.h>

#define MAXSIZE 10
void *produce(void *); 
void *consume(void *);

typedef void *(*handler_t)(void *);//线程函数指针

struct _shared 
{
    int buff[MAXSIZE];

    sem_t *nempty;
    sem_t *nstored;
};//共享缓冲
typedef struct _shared shared;
shared shared_;

int nitems;//生产和消费的数目

int main(int argc,char **argv)
{
    if (argc !=2)
    {
        printf("usage:namedsem <#items>\r\n");
        exit(-1);
    }
    nitems=atoi(argv[1]);
    const char *const SEM_NEMPTY = "nempty";//信号量的“名字”
    const char *const SEM_NSTORED = "nstored";//信号量的“名字”
    pthread_t tid_produce;//生产者线程 id
    pthread_t tid_consume;//消费者线程 id
    //初始化信号量和互斥锁

    shared_.nstored=sem_open(SEM_NSTORED,O_CREAT|O_EXCL,0644,0);
    shared_.nempty=sem_open(SEM_NEMPTY,O_CREAT|O_EXCL,0644,MAXSIZE);
    memset(shared_.buff,0x00,MAXSIZE);

    //线程创建
    handler_t handler=produce;
    pthread_setconcurrency(2);
    if((pthread_create(&tid_produce,NULL,handler,NULL))<0)
    {
        printf("pthread_create error\r\n");
        exit(-1);
    }
//    sleep(30);
    handler=consume;
    if((pthread_create(&tid_consume,NULL,handler,NULL))<0)
    {
        printf("pthread_create error\r\n");
        exit(-1);
    }

    //线程回收
    pthread_join(tid_produce,NULL);
    pthread_join(tid_consume,NULL);

    //信号量锁销毁
    sem_unlink(SEM_NEMPTY);
    sem_unlink(SEM_NSTORED);

    exit(0);
}



void *produce(void *args)
{
    int i;
    for(i=0;i<nitems;i++)
    {
        sem_wait(shared_.nempty);

        shared_.buff[i%MAXSIZE]=i;
        printf("add an item\r\n");

        sem_post(shared_.nstored);
    }
    return NULL;
}


void *consume(void *args)
{
    int i;
    for(i=0;i<nitems;i++)
    {
        sem_wait(shared_.nstored);

        printf("consume an item\r\n");
        if(shared_.buff[i%MAXSIZE]!=i)
            printf("buff[%d]=%d\r\n",i,shared_.buff[i%MAXSIZE]);

        sem_post(shared_.nempty);
    }
    return NULL;
}