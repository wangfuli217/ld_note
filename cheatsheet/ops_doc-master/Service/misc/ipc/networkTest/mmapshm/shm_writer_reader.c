/*************************************************************************
	> File Name: shm_writer_reader.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Wed 02 Mar 2016 08:37:51 PM CST
 ************************************************************************/
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <error.h>
#include "SystemVSem.h"
#define SEM_NAME "mysem"
#define SHM_KEY		(123)

typedef struct 
{
	char name[10];
	int age;
}Student;
int main(int argc ,char ** argv)
{
	int fd=0;
	int ret=0;
	int i=0;
	Student s;
	int semid;
	int * sptr=NULL;
	struct sembuf sembufs={1,0,1};
	key_t sem_key;
	if(argc != 2)
	{
		ERR_EXIT("argv error\n");
	}
	sem_key = ftok(".",'a');
	fd = open("Tshm",O_RDWR|O_CREAT,0666);
	if(fd < 0)
	{
		ERR_EXIT("file open error\n");
	}
	sptr = &fd;
	//lseek(fd,sizeof(int),SEEK_SET);
	//ret = write(fd,&,sizeof(Student));
//	write(fd,sptr,sizeof(int));
	ftruncate(fd,4);
	sptr = mmap(NULL, sizeof(int),PROT_READ | PROT_WRITE,MAP_SHARED,fd,0);
	if(sptr == ((void *) -1))
	{
		ERR_EXIT("mmap error\n");
	}
	close(fd);
	
	semid = sem_open(sem_key,0666);
	if(semid == -1)
	{
		semid = sem_create(sem_key,1,0666);
		sem_set_val(semid,0,0);
	}
	

	i=0;


	while(atoi(argv[1]) == 0 && i<10000)
	{	
		sembufs.sem_num =0;
		sembufs.sem_op = -1;
		sembufs.sem_flg = SEM_UNDO; 
		i++;
		printf("wait for reading\n");
		sem_v(semid,&sembufs,1);	
		printf("read :%d\n",*sptr);
		sembufs.sem_op =1;
	}
	while(atoi(argv[1]) == 1 && i< 999)
	{
		sembufs.sem_num =0;
		sembufs.sem_op = -1;
		sembufs.sem_flg = SEM_UNDO; 
		*sptr = i++ %1000;
		printf("write %d\n",*sptr);
		i = i%1000;
		sleep(5);
		sembufs.sem_op = 1;
		sem_p(semid,&sembufs,1);
		sleep(1);
		
	}
	munmap(sptr,sizeof(int));

	return 0;
	
}

