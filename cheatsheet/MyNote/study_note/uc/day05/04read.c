#include<stdio.h>
#include<stdlib.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<fcntl.h>

int main(void)
{
	char buf[20]={};
	int fd=open("b.txt",O_RDONLY);
	if(-1==fd)
		perror("open"),exit(-1);
	while(1)
	{
		int size=read(fd,buf,20);
		if(-1==size)
			perror("read"),exit(-1);
		if(size==0)
			break;
		printf("%s",buf);
	}
	printf("\n");
	close(fd);
	return 0;
}
