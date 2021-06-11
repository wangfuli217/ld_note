#include<stdio.h>
#include<stdlib.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<fcntl.h>
typedef struct
{
	int id;
	char name[20];
	double salary;
}Info;
int main(void)
{
	int fd=open("emp.dat",O_RDONLY);
	if(-1==fd)
		perror("open"),exit(-1);
	Info info={};
	int res=read(fd,&info,sizeof(info));
	printf("姓名是:%s\n",info.name);
	printf("编号是:%d\n",info.id);
	printf("工资是:%lg\n",info.salary);
	close(fd);
	return 0;
}
