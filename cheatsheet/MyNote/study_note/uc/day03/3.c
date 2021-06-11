//打印环境表中所有的内容
#include<stdio.h>
//#include<unistd.h>
#include<string.h>
int main(void)
{
	extern char** environ;
	char** p=environ;
	char *buf=NULL;
	while(*p)
	{
		if(!strncmp("SHELL",*p,5))
		{
			buf=strstr(*p,"=")+1;
			printf("%s\n",buf);
			break;
		}
		*p++;
	}
	return 0;
}
