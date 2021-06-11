//umask函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int main(void)
{
	//使用umask函数设置屏蔽的权限
	mode_t old=umask(0055); //设置新的屏蔽字,返回旧的系统默认,当前系统默认屏蔽0002
	printf("old=%o\n",old); //0002
	//创建一个新文件
	int fd=open("b.txt",O_CREAT|O_RDWR,0777);
	if(-1==fd)
		perror("open"),exit(-1);
	umask(old);  //恢复系统默认的屏蔽字,对已经创建过的文件权限没有影响
	close(fd);
	return 0;
}
