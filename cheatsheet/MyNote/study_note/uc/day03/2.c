//错误编号和错误信息的使用
#include<stdio.h>
#include<errno.h>
#include<string.h>
int main(void)
{
	perror("错误信息为");
	FILE *p=fopen("abc.txt","r");
	if(!p)
	{
		printf("打开文件失败\n");
		perror("错误信息为");
		printf("%m\n");
	}
	printf("---------------------------------------------\n");
	p=fopen("/etc/passwd","w");
	printf("%s\n",strerror(errno));
	perror("错误是");
	printf("%m\n");
	return 0;
}
