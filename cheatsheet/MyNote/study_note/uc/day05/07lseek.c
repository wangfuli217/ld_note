//lseek函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<sys/types.h>
#include<unistd.h>
#include<sys/stat.h>
#include<fcntl.h>

int main(void)
{
	//打开文件
	int fd=open("c.txt",O_RDWR);
	if(-1==fd)
		perror("open"),exit(-1);
	printf("打开文件成功\n");
	//使用lseek函数调整读写位置
	char c=0;
	read(fd,&c,sizeof(char));
	printf("%c\n",c);
	read(fd,&c,sizeof(char));
	printf("%c\n",c);
	int offset=lseek(fd,3,SEEK_CUR);
	read(fd,&c,sizeof(char));
	printf("%c\n",c);
	//关闭文件
	close(fd);
	return 0;
}
