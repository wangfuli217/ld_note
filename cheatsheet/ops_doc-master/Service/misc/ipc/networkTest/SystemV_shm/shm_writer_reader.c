/*************************************************************************
	> File Name: shm_writer_reader.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Wed 02 Mar 2016 08:37:51 PM CST
 ************************************************************************/
#include<unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <error.h>

#define SHM_KEY		(123)

#define ERR_EXIT(m)\
	do\
	{\
		perror(m);\
		exit(EXIT_FAILURE);\
	}while(0)

typedef struct 
{
	char name[10];
	int age;
}Student;

int main(int argc, char * argv[])
{

	int shmid=0;
	int opt,r_flag;
	int *shmptr;
	if(argc < 2)
	{
		ERR_EXIT("too few argvs");
	}
	while((opt = getopt(argc,argv,"rw")) != -1)
	{
		switch(opt)
		{
			case 'w':
				r_flag = 0;
				break;
			case 'r':
				r_flag = 1;
				break;
			default:/*'?' wrong argv*/
				ERR_EXIT("wrong argv\n");

		}
	}
	if(r_flag == 0)
	{
		shmid = shmget(1234,sizeof(int),IPC_CREAT|0666);
	}
	else
	{
		shmid = shmget(1234,0,0);
	}
	if(shmid == -1)
	{
		ERR_EXIT("shmget error\n");
	}
	shmptr = (int *) shmat(shmid,NULL,0);
	if(r_flag == 0)
	{
		*shmptr = 1;
		while(1)
		{
			if(*shmptr == 0)
			{
				break;
			}
			sleep(2);
			fprintf(stdout,"%s","waiting for being read\n");
		}
	}
	else
	{
		while(1)
		{
			if(*shmptr == 1)
			{
				fprintf(stdout,"%s:%d\n","Reader got a value ",1);
				*shmptr = 0;
				break;
			}
			sleep(2);
		}
	}
	shmdt(shmptr);
	shmctl(shmid,IPC_RMID,NULL);
	return 0;	
}

