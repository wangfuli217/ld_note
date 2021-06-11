#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int main(void)
{
	int fd=open("a.txt",O_RDWR);
	if(-1==fd)
		perror("open"),exit(-1);
	struct flock lock;
	lock.l_type=F_RDLCK;
	lock.l_whence=SEEK_SET;
	lock.l_start=0;
	lock.l_len=10;
	lock.l_pid=-1;
	int res=fcntl(fd,F_SETLK,&lock);
	if(res==-1)
		printf("加锁失败\n"),exit(-1);
	else
		printf("加锁成功\n");
	close(fd);
	return 0;
}
