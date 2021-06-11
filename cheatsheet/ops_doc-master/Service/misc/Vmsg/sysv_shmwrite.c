//shmwrite.c

#include "sysv_shm.h"
#define PATHNAME "."
    int
main(int argc, char **argv)
{
    int      id;
    int flag;
    char    *ptr;
    size_t  length=1024;
    key_t key;
    struct shmid_ds buff;
    key = ftok(PATHNAME,1);

    if(key<0)
    {
        printf("ftok error\r\n");
        return -1;
    }

    id = shmget(key, length,IPC_CREAT | IPC_EXCL| S_IRUSR | S_IWUSR  );
    if(id<0)
    {
        printf("errno: %s\r\n",strerror(errno));
        printf("shmget error\r\n");
        return -1;
    }
    ptr = shmat(id, NULL, 0);
    if(ptr==NULL)
    {
        printf("shmat error\r\n");
        return -1;
    }

    shmctl(id,IPC_STAT,&buff);
    int i;
    for(i=0;i<buff.shm_segsz;i++)
    {
        *ptr++ = i%256;
    }
    return 0;
}