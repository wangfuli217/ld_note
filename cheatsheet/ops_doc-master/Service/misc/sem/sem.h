#include <stdio.h>  
#include <stdlib.h>  
#include <sys/types.h>  
#include <sys/ipc.h>  
#include <sys/sem.h>  
#include <unistd.h>  
  
void init_sem(int , int );  
void delete_sem(int );  
void sem_p(int );  
void sem_v(int );  
  
union semun  
{  
    int val;  
    struct semid_ds *buf;  
    unsigned short *array;  
};  
  
void init_sem(int sem_id, int init_value)  
{  
    union semun sem_union;  
  
    sem_union.val = init_value;  
  
    if (semctl(sem_id, 0, SETVAL, sem_union) < 0)  
    {  
        perror("failed to init_sem");  
        exit(-1);  
    }  
  
    return ;  
}  
  
void delete_sem(int sem_id)  
{  
    union semun sem_union;  
  
    if (semctl(sem_id, 0, IPC_RMID, sem_union) < 0)  
    {  
        perror("failed to delete_sem");  
        exit(-1);  
    }  
  
    return ;  
}  
  
void sem_p(int sem_id)  
{  
    struct sembuf sem_b;  
  
    sem_b.sem_num = 0;  
    sem_b.sem_op = -1;  
    sem_b.sem_flg = SEM_UNDO;  
  
    if (semop(sem_id, &sem_b, 1) < 0)  
    {  
        perror("failed to sem_p");  
        exit(-1);  
    }  
  
    return;  
}  
  
void sem_v(int sem_id)  
{  
    struct sembuf sem_b;  
  
    sem_b.sem_num = 0;  
    sem_b.sem_op = 1;  
    sem_b.sem_flg = SEM_UNDO;  
  
    if (semop(sem_id, &sem_b, 1) < 0)  
    {  
        perror("failed to sem_v");  
        exit(-1);  
    }  
  
    return ;  
}  