//遍历一个目录中的所有内容
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<dirent.h>
int main(void)
{
	//打开目录
	DIR* dir=opendir("../code");
	if(NULL==dir)
		perror("opendir"),exit(-1);
	//读取目录中的所有内容
	//普通文件的类型是8，目录的类型是4
	struct dirent *ent;
	while(ent=readdir(dir))
	{
		printf("%d %s\n",ent->d_type,ent->d_name);
	}
	//关闭目录
	closedir(dir);
	return 0;
}
