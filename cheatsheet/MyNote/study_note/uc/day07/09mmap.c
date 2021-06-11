#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/mman.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

typedef struct
{
	int id;
	char name[20];
	double salary;
}Emp;
int main(void)
{
	int fd=open("emp.dat",O_RDONLY);
	if(fd==-1)
		perror("open");
	void *p=mmap(NULL,3*sizeof(Emp),PROT_READ,MAP_SHARED,fd,0);
	if(p==MAP_FAILED)
		perror("mmap"),exit(-1);
	int i=0;
	Emp *pe=(Emp *)p;
	for(i=0;i<3;i++)
		printf("姓名:%s  编号:%d  工资:%lg\n",pe[i].name,pe[i].id,pe[i].salary);
	munmap(p,3*sizeof(Emp));
	close(fd);
	return 0;
}
