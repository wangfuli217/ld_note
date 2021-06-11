#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
int main(void)
{
	int fd=open("a.txt",O_WRONLY);
	if(-1==fd)
		perror("open"),exit(-1);
	printf("打开文件成功\n");
	int res=write(fd,"hello",5);
	if(res==-1)
		printf("写入失败\n"),exit(-1);
	printf("写入成功\n");
	close(fd);
	return 0;
}
