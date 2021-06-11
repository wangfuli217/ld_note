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
	lock.l_len=5;
	lock.l_pid=-1;
	int res=fcntl(fd,F_SETFL,&lock);
	if(-1==res)
		printf("加锁失败\n"),exit(-1);
	printf("加锁成功\n");
	sleep(20);
	lock.l_type=F_UNLCK;
	res=fcntl(fd,F_SETFL,&lock);
	if(-1==res)
		printf("解锁失败\n"),exit(-1);
	printf("解锁成功\n");
	close(fd);
	return 0;
}
