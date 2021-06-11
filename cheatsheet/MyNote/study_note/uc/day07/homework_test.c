#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int main(void)
{
	//打开文件
	int fd=open("a.txt",O_RDWR);
	if(-1==fd)
		perror("open"),exit(-1);
	struct flock lock;
	lock.l_type=F_WRLCK;
	lock.l_whence=SEEK_SET;
	lock.l_start=0;
	lock.l_len=5;
	lock.l_pid=-1;
    int res=fcntl(fd,F_SETLK,&lock);
	if(res==-1)
		printf("加锁失败\n"),exit(-1);
	//写入数据
	res=write(fd,"hello",5);
	if(-1==res)
		perror("write"),exit(-1);
	printf("写入成功,写入的数据大小是%d\n",res);
	//关闭文件
	close(fd);
	return 0;
}
