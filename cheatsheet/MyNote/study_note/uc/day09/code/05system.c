//system函数的使用
#include<stdio.h>
#include<stdlib.h>
int main(void)
{
	int res=system("shell.sh");
	if(-1==res)
	{
		perror("system"),exit(-1);
	}
	printf("system执行完毕\n");
	return 0;
}
