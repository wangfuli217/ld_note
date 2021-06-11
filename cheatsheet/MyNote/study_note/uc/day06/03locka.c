//使用fcntl函数对文件进行加锁
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/stat.h>
#include<sys/types.h>
int main(void)
{
	//打开一个文件
	int fd=open("a.txt",O_RDWR);
	if(-1==fd)
		perror("open"),exit(-1);
	//准备一把锁
	struct flock lock;
	//将锁的类型设置为读锁
	lock.l_type=F_RDLCK;  //读锁
	//设置锁的起始位置
	lock.l_whence=SEEK_SET;
	//设置锁的偏移量
	lock.l_start=0;
	//设置锁定的数据大小
	lock.l_len=10;
	//设置锁定的进程号
	lock.l_pid=-1;
	//使用fcntl函数进行加锁
	int res=fcntl(fd,F_SETLK,&lock);
	if(-1==res)
		perror("fcntl"),exit(-1);
	printf("加锁成功,下面开始使用文件\n");
	//模拟占用文件的过程
	sleep(20);
	printf("使用文件完毕,进程结束\n");
	//关闭文件
	return 0;
}
