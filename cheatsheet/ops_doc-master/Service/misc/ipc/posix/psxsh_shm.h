//shm.h
#include <sys/mman.h>
#include <sys/stat.h>        /* For mode constants */
#include <fcntl.h>           /* For O_* constants */
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <semaphore.h>
#include <time.h>
#include <assert.h>
#include <errno.h>
#include <signal.h>
#include <pthread.h>

#define MESGSIZE 256
#define NMESG   16

struct shmstruct{
//这里既可以用二值信号量也可以用互斥锁（需要设置互斥锁属性，否则会死锁）
    pthread_mutex_t mutex;
    //        sem_t mutex;  
    sem_t nempty;
    sem_t nstored;
    int nput;
    long noverflow;
    sem_t   noverflowmutex; /* mutex for noverflow counter */
    long    msgoff[NMESG];  /* offset in shared memory of each message */
    char    msgdata[NMESG * MESGSIZE];  /* the actual messages */
};