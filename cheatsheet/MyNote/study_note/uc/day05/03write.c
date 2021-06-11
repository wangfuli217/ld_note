//write函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

int main(void)
{
	//打开/创建文件
	int fd=open("b.txt",O_WRONLY|O_CREAT|O_EXCL,0644);
	if(-1==fd)
		perror("open"),exit(-1);
	printf("打开文件成功\n");
	//向文件写入数据
	int size=write(fd,"hello",5);
	if(-1==size)
		perror("write"),exit(-1);
	printf("写入的数据大小是%d\n",size);
	//关闭文件
	size=close(fd);
	if(-1==size)
		perror("close"),exit(-1);
	printf("关闭文件成功\n");
	return 0;
}
