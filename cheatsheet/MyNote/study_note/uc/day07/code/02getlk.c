//使用F_GETLK参数判断锁能否加上
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int main(void)
{
	int fd=open("a.txt",O_RDWR);
	if(fd==-1)
		perror("open"),exit(-1);
	struct flock lock;
	lock.l_type=F_RDLCK;
	lock.l_whence=SEEK_SET;
	lock.l_start=0;
	lock.l_len=5;
	lock.l_pid=-1;
	int res=fcntl(fd,F_GETLK,&lock);
	if(-1==res)
		perror("fcntl"),exit(-1);
	printf("F_RDLCK=%d,F_WRLCK=%d,F_UNLCK=%d\n",F_RDLCK,F_WRLCK,F_UNLCK);
	printf("lock.l_type=%d,lock.l_pid=%d\n",lock.l_type,lock.l_pid);
	close(fd);
	return 0;
}
