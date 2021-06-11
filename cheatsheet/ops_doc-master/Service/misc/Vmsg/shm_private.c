#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/ipc.h>
#include <sys/types.h>
#include <sys/shm.h>
#include <string.h>
#define MAXSIZE 1024
int main()
{
    int shmid;
    char *p = NULL;
    pid_t pid;
    #if 0
    key_t key;
    if ((key = ftok(".", 'a')) == -1)
    {
        perror("ftok");
        exit(-1);
    }
    #endif
    if ((shmid = shmget(IPC_PRIVATE, MAXSIZE, 0666)) == -1)
    {
        perror("shmget");
        exit(-1);
    }
    if ((pid = fork()) == -1)
    {
        perror("fork");
        exit(-1);
    }
    if (pid == 0)
    {
        if ((p = shmat(shmid, NULL, 0)) == (void *)-1)
        {
            perror("shmat");
            exit(-1);
        }
        strcpy(p, "hello\n");
        system("ipcs -m");
        if (shmdt(p) == -1)
        {
            perror("shmdt");
            exit(-1);
        }
        system("ipcs -m");
    }
    else
    {
        getchar();
        if ((p = shmat(shmid, NULL, 0)) == (void *)-1)
        {
            perror("shmat");
            exit(-1);
        }
        printf("%s\n", (char *)p);
        if (shmctl(shmid, IPC_RMID, NULL) == -1)
        {
            perror("RM");
            exit(-1);
        }
    }
    return 0;
}