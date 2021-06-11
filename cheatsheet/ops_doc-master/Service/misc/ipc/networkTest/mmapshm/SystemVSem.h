/*************************************************************************
	> File Name: SystemVsem.h
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Thu 03 Mar 2016 08:14:59 AM CST
 ************************************************************************/
#ifndef SYSTEMVSEM_H
#define SYSTEMVSEM_H
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <error.h>
#include <string.h>

extern int errno;
#define ERR_EXIT(m) \
	do \
	{\
		 perror(m);\
		 exit(EXIT_FAILURE);\
	}while(0)

union semun  // more about semun "man semctl"
{
	int val;
	struct semid_ds *buf;
	unsigned short *array;
	struct seminfo *__buf;
};
/*struct semid_ds
{
	struct ipc_perm sem_perm;
	time_t sem_otime;
	time_t sem_ctime;
	unsigned short sem_nsems;
};
*/
extern int sem_open(key_t key, int semflag);
extern int sem_create(key_t key,int nsems,int semflag);
extern int sem_del(int semid);
extern int sem_get_stat(int semid,struct semid_ds* semid_ds_buf);
extern int sem_set_val(int semid,int semnum,int val);
extern int sem_p(int semid, struct sembuf *sops,unsigned nsops);
extern int sem_v(int semid, struct sembuf*sops,unsigned nsops);

#endif
