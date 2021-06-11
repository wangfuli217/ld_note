#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int main(void)
{
	int fd=open("a.txt",O_RDONLY);
	if(-1==fd)
		perror("open"),exit(-1);
	printf("打开文件成功\n");
	struct flock lock={};
	lock.l_type=F_RDLCK;
	lock.l_whence=SEEK_SET;
	lock.l_start=0;
	lock.l_len=5;
	lock.l_pid=-1;
	fcntl(fd,F_SETLK,&lock);
	printf("文件加锁成功,正在使用中\n");
	sleep(20);
	printf("文件关闭\n");
	close(fd);
	return 0;
}
