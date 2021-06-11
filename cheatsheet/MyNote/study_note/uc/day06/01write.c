#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
int main(void)
{
	int fd=open("b.txt",O_WRONLY|O_CREAT,0644);
	printf("%d\n",fd);
	if(-1==fd)
		perror("open"),exit(-1);
	int i=0;
	//自定缓冲区提高效率
	int buf[10000];
	for(i=1;i<=1000000;i++)
	{
		buf[(i-1)%10000]=i;
		if((i-1)%10000==9999)
			write(fd,buf,sizeof(buf));
	}
	close(fd);
	return 0;
}
