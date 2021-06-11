/*************************************************************************
	> File Name: shm_writer_reader.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Sun 06 Mar 2016 08:36:39 PM CST
 ************************************************************************/
//Posix share memory

//!!!!!!!!!!!!!!!!!!gcc Link this file with "-lrt"
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#define ERR_EXIT(m) \
	do \
    {\
		perror(m);\
		exit(EXIT_FAILURE);\
	}while(0)

int main(int argc, char * argv[])
{

	int shmid ;
	int opt;
	int *shmptr =&shmid;	
	struct stat buf;
	int r_flag;
	if(argc < 2)
	{
		ERR_EXIT("too few argvs \n");

	}
	else if(argc >  2)
	{
		ERR_EXIT("too many argvs");
	}
//	shm_unlink("/liu_posix");
	while((opt= getopt(argc,argv,"rw")) != -1)
	{
		switch(opt)
		{
			case 'r':
				r_flag =1;
				break;
			case 'w':
					r_flag = 0;
					break;
			defaut:
					ERR_EXIT("undefined argv\n");
					break;
		}
	}
	//step one
	if(r_flag == 0)//create or open POSIX shared memory object
	{
		shmid = shm_open("/liu_posix",O_CREAT|O_RDWR,0666);
		write(shmid,shmptr,sizeof(int));
	}
	else
	{
		shmid = shm_open("/liu_posix",O_RDWR,0666);
	}

	if(shmid == -1)
	{
		ERR_EXIT("shm_open error\n");
	}
	//step two
	if(r_flag == 0)//writer
	{// This step is necessary for allocating physical space for the shared memory
	 
		shmptr = mmap(NULL,sizeof(int),PROT_READ|PROT_WRITE,MAP_SHARED,shmid,0);
		if(shmptr == MAP_FAILED )
		{
			ERR_EXIT("mmap error\n");
		}
		
		//opt = ftruncate(shmid,size);
		//you can also use this 'ftruncate' modify the space of share memmory;
	}
	else
	{//reader
		if(fstat(shmid,&buf) == -1)
		{
			ERR_EXIT("reader fstat error\n");
		}
		shmptr = mmap(NULL,buf.st_size,PROT_READ|PROT_WRITE,MAP_SHARED,shmid,0);
		if(shmptr == MAP_FAILED )
		{
			ERR_EXIT("mmap error\n");
		}
	}

	printf("step two succes\n");
	close(shmid);
	
	if(r_flag == 0)
	{
		printf("step set value before\n");
		*shmptr = 1;
		while(*shmptr != 0)
		{
			fprintf(stdout,"%s\n","waiting for reader");
			printf("step set value after\n");
			sleep(1);
		}
		printf("writer got a value %d\n",*shmptr);
	}
	else
	{
		sleep(5);
		while(*shmptr != 1)
		{
			sleep(1);
			fprintf(stdout,"%s\n","waiting for writer");
			
		}

		printf("reader got a value %d\n",*shmptr);
		*shmptr = 0;

	}

	//step three
	
	//step four
	shm_unlink("/liu_posix");

	return 0;
}
