//shmserver.c
#include "psxsh_shm.h"


int main(int argc,char **argv)
{
    int     fd, index, lastnoverflow, temp;
    long    offset;
    struct shmstruct    *ptr;
    int flag = O_RDWR|O_CREAT|O_EXCL;
    if (argc != 2)
    {
        printf("usage: server2 <name>\r\n");
        return -1;
    }
    shm_unlink(argv[1]);

    fd = shm_open(argv[1],O_RDWR|O_CREAT|O_EXCL,0644);//创建共享内存区

    ptr=mmap(NULL,sizeof(struct shmstruct),PROT_READ|PROT_WRITE,MAP_SHARED,fd,0);//
    ftruncate(fd,sizeof(struct shmstruct));//调整大小
    close(fd);


    for (index = 0; index < NMESG; index++)//计算数据的偏移量
        ptr->msgoff[index] = index * MESGSIZE;


//初始化
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);  
    pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_SHARED);//进程间通信需要该属性，否则会死锁
    pthread_mutex_init(&ptr->mutex,&attr);

   // sem_init(&ptr->mutex, 1, 1);
    sem_init(&ptr->nempty, 1, NMESG);
    sem_init(&ptr->nstored, 1, 0);
    sem_init(&ptr->noverflowmutex, 1, 1);


    index =0;
    lastnoverflow=0;
    for(;;)
    {
        sem_wait(&ptr->nstored);//同步
        pthread_mutex_lock(&ptr->mutex);
    //  sem_wait(&ptr->mutex);
        offset=ptr->msgoff[index];//获取偏移量
        printf("index = %d: %s\n", index, &ptr->msgdata[offset]);
        if (++index >= NMESG)
            index = 0;              /* circular buffer */
        pthread_mutex_unlock(&ptr->mutex);
    //  sem_post(&ptr->mutex);
        sem_post(&ptr->nempty);
        sem_wait(&ptr->noverflowmutex);//这里为了计算超出buffer后还发送了多少内容（有多少内容丢失）
        temp = ptr->noverflow;      /* don't printf while mutex held */
        sem_post(&ptr->noverflowmutex);
        if (temp != lastnoverflow)
        {
            printf("noverflow = %d\n", temp);
            lastnoverflow = temp;
        }

    }
    return 0;
}