//使用有名管道实现进程间的通信
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int main(void)
{
	//打开文件
	int fd=open("a.pipe",O_WRONLY);
	if(-1==fd)
		perror("open"),exit(-1);
	//写入数据到文件
	int i=0;
	for(i=1;i<100;i++)
		{
			int res=write(fd,&i,sizeof(int));
			if(-1==res)
				perror("write"),exit(-1);
			usleep(100000);
		}
	//关闭文件
	close(fd);
	return 0;
}
