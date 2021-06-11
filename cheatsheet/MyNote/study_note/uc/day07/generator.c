#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<sys/mman.h>
int main(void)
{
	int fd=open("accounts.dat",O_RDWR|O_CREAT,0600);
	if(fd==-1)
		perror("open"),exit(-1);
	struct stat st={};
	fstat(fd,&st);
	if(st.st_size==0)
	{
		ftruncate(fd,sizeof(int)+st.st_size);
		printf("生成的账号是:100000\n");
		void *p=mmap(NULL,sizeof(int),PROT_READ|PROT_WRITE,MAP_SHARED,fd,0);
		memset(p,0,sizeof(int));
		int *pe=(int *)p;
		*pe=100000;
		munmap(p,sizeof(int));
	}
	else
	{
		ftruncate(fd,st.st_size+sizeof(int));
		void *p=mmap(NULL,sizeof(int)*2,PROT_READ|PROT_WRITE,MAP_SHARED,fd,st.st_size-sizeof(int));
		memset(p+sizeof(int),0,sizeof(int));
		int *pe=(int *)p;
		printf("生成的账号是:%d\n",*pe+1);
		*(pe+1)=*pe+1;
		munmap(p,2*sizeof(int));
	}
	close(fd);
	return 0;
}
