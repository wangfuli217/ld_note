#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
typedef struct
{
	int id;
	char name[20];
	double salary;
}Info;
int main(void)
{
	int fd=open("emp.dat",O_WRONLY|O_CREAT|O_EXCL,0644);
	if(-1==fd)
		perror("open"),exit(-1);
	Info info={};
	printf("请输入员工的编号:");
	scanf("%d",&info.id);
	scanf("%*[^\n]");
	scanf("%*c");
	printf("请输入员工的姓名:");
	fgets(info.name,20,stdin);
	if(strlen(info.name)==19&&info.name[18]!='\n')
	{
		scanf("%*[^\n]");
		scanf("%*c");
	}
	if(info.name[strlen(info.name)-1]=='\n')
		info.name[strlen(info.name)-1]='\0';
	printf("请输入员工的工资:");
	scanf("%lg",&info.salary);
	int res=write(fd,&info,sizeof(info));
	if(res==-1)
		perror("write"),exit(-1);
	close(fd);
	return 0;
}
