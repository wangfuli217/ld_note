#include "psxsh_shm.h"

int main(int argc,char**argv)
{
    int fd, i, nloop, nusec;
    pid_t   pid;
    char    mesg[MESGSIZE];
    long    offset;
    struct shmstruct    *ptr;

    if (argc != 4)
    printf("usage: client2 <name> <#loops> <#usec>");
    nloop = atoi(argv[2]);
    nusec = atoi(argv[3]);

    fd = shm_open(argv[1],O_RDWR,0644);
    ptr = mmap(NULL,sizeof(struct shmstruct),PROT_READ|PROT_WRITE,
        MAP_SHARED,fd,0);
    close(fd);

    pid=getpid();
    for(i=0;i<nloop;i++)
    {
        snprintf(mesg, MESGSIZE, "pid %ld: message %d", (long) pid, i);
        if(sem_trywait(&ptr->nempty)==-1)
        {
            if(errno==EAGAIN)
            {
                sem_wait(&ptr->noverflowmutex);//表示已经满了
                ptr->noverflow++;
                sem_post(&ptr->noverflowmutex);
                continue;
            }
            else
            {
                printf("try wait error\r\n");
            }
        }
        pthread_mutex_lock(&ptr->mutex);
        //sem_wait(&ptr->mutex);
        offset = ptr->msgoff[ptr->nput];
        if (++(ptr->nput) >= NMESG)
            ptr->nput = 0;      /* circular buffer */
        pthread_mutex_unlock(&ptr->mutex);
        //sem_post(&ptr->mutex);
        strcpy(&ptr->msgdata[offset],mesg);
        sem_post(&ptr->nstored);
    }
    return 0;

}