#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int main()
{
	char id[10]={};
	char passwd[8]={};
	int count=0;
	while(1)
	{
		printf("请输入用户名:");
		fgets(id,10,stdin);
		if(strlen(id)==9&&id[8]!='\n')
		{
			scanf("%*[^\n]");
			scanf("%*c");
		}
		printf("请输入密码:");
		fgets(passwd,8,stdin);
		if(strlen(passwd)==7&&passwd[6]!='\n')
		{
			scanf("%*[^\n]");
			scanf("%*c");
		}
		count++;
		if(!strcmp(id,"admin\n")&&!strcmp(passwd,"123456\n"))
		{
			printf("登录成功\n");
			exit(0);
		}
		if(count==3)
			break;
	}
	printf("登录失败\n");
	return 0;
}
