//修改文件的权限和大小
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
int main(void)
{
	//获取文件的权限和大小
	struct stat st={};
	int res=stat("a.txt",&st);
	if(-1==res)
		perror("stat"),exit(-1);
	printf("权限是:%o,大小是%ld\n",st.st_mode&0777,st.st_size);
	//修改文件的权限和大小
	res=chmod("a.txt",0600);
	if(-1==res)
		perror("chmod"),exit(-1);
	res=truncate("a.txt",100);
	if(-1==res)
		perror("truncate"),exit(-1);
	//获取修改后的权限和大小,打印
	res=stat("a.txt",&st);
	if(-1==res)
		perror("stat"),exit(-1);
	printf("修改之后的权限是:%o,修改之后的大小是:%ld\n",st.st_mode&0777,st.st_size);
	return 0;
}
