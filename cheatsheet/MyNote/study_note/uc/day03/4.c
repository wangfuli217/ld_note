#include<stdio.h>
#include<stdlib.h>
int main(void)
{
//	char *pc=getenv("SHELL");
//	if(!pc)
//		perror("getenv"),exit(-1);
//	printf("SHELL=%s\n",pc);
//	pc=getenv("MARK");
//	if(!pc)
//		perror("getenv"),exit(-1);
//	printf("MARK=%s\n",pc);
//	printf("-----------------------------------------------\n");
int res=setenv("SHELL","abc",0);
if(res==-1)
	perror("setenv"),exit(-1);
printf("SHELL=%s\n",getenv("SHELL"));
setenv("MARK","年轻就是任性",0);
printf("MARK=%s\n",getenv("MARK"));
//	printf("-----------------------------------------------\n");
res=putenv("SHELL=abc");
if(res)
	perror("putenv"),exit(-1);
printf("%s\n",getenv("SHELL"));
res=putenv("abc=123");
if(res)
	perror("putenv"),exit(-1);
printf("%s\n",getenv("abc"));
//	printf("-----------------------------------------------\n");
unsetenv("abc");
printf("删除后的结果是:%s\n",getenv("abc"));
//	printf("-----------------------------------------------\n");
clearenv();
return 0;
}
