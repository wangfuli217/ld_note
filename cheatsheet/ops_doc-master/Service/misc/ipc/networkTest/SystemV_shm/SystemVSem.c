/*************************************************************************
	> File Name: SystemVSem.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Thu 03 Mar 2016 08:18:05 AM CST
 ************************************************************************/

#include "SystemVSem.h"
//create a sem set
int sem_create(key_t key,int nsems,int semflag)
{
	int semid = semget(key,nsems,semflag|IPC_CREAT|IPC_EXCL);
	if(semid == -1 /*&& errno == EEXIST*/)
	{
		printf("sem exits ,create error\n");
		semid = sem_open(key,semflag);

	}
	else if(semid == - 1 /*&& errno != EEXIST*/)
	{
		ERR_EXIT("sem create failed\n");
	}
	return semid;
}
//open a sem set
int sem_open(key_t key ,int semflag)
{
	int semid=0;
	semid = semget(key,0,semflag);
	if(semid == -1)
	{
//		ERR_EXIT("sem open error\n");
	}
	return semid;
}
//set sem value
int sem_set_val(int semid, int semnum, int val)
{
	union semun semunbuf;
	semunbuf.val = val;
	int ret = semctl(semid,semnum,SETVAL,semunbuf);
	if(ret != 0)
	{
		ERR_EXIT("sem_set_val error\n");

	}
	return ret;

}
//delete a sem
int sem_del(int semid )
{
	int ret =0;
	ret =semctl(semid,0,IPC_RMID,NULL);
	if(ret !=0)
	{
		ERR_EXIT("sem_del error\n");
	}
	return ret;
}

//get sem stat
int sem_get_stat(int semid ,struct semid_ds * semid_ds_buf)
{
	union semun semunbuf;
	int ret =0;
	semunbuf.buf = semid_ds_buf;
	ret = semctl(semid,0,IPC_STAT,&semunbuf);
	if(ret == -1)
	{
		ERR_EXIT("sem stat get error\n");
	}
	return ret;
	
}

//sem_p
int sem_p(int semid, struct sembuf * sops, unsigned nsops)
{
	int ret = semop(semid,sops,nsops);
	if(ret == -1)
	{
		ERR_EXIT("sem pending error\n");
	}
	return ret;
}
//sem_v
int sem_v(int semid ,struct sembuf *sops,unsigned nsops)
{
	int ret = semop(semid,sops,nsops);
	if(ret == -1)
	{
		ERR_EXIT("sem wait error\n");
	}
	return ret;
}
