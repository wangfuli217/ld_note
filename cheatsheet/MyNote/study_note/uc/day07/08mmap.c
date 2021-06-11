//建立虚拟地址到文件的映射
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/mman.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<sys/fcntl.h>
#include<string.h>
typedef struct
{
	int id;
	char name[20];
	double salary;
}Emp;
int main(void)
{
	//创建一个新文件
	int fd=open("emp.dat",O_RDWR|O_CREAT|O_EXCL,0644);
	if(-1==fd)
		perror("open"),exit(-1);
	//指定文件的大小
	ftruncate(fd,3*sizeof(Emp));
	//建立虚拟地址到文件的映射
	void *p=mmap(NULL,3*sizeof(Emp),PROT_READ|PROT_WRITE,MAP_SHARED,fd,0);
	if(MAP_FAILED==p)
		perror("mmap"),exit(-1);
	//通过虚拟地址写入数据
	Emp *pe=p;
	pe[0].id=1001;
	strcpy(pe[0].name,"zhangfei");
	pe[0].salary=3000;
	pe[1].id=1002;
	strcpy(pe[1].name,"guanyu");
	pe[1].salary=3500;
	pe[2].id=1003;
	strcpy(pe[2].name,"liubei");
	pe[2].salary=4000;
	//解除映射
	munmap(p,3*sizeof(Emp));
	//关闭文件
	close(fd);
	return 0;
}
