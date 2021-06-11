#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

int main(void)
{
	int fd=open("a.pipe",O_RDONLY);
	if(-1==fd)
		perror("open"),exit(-1);
	int i=0;
	for(i=1;i<100;i++)
	{
		int x=0;
		read(fd,&x,sizeof(int));
		printf("x=%d\n",x);
		usleep(100000);
	}
	close(fd);
	return 0;
}
