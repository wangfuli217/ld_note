/*
 * =====================================================================================
 *
 *       Filename:  hello.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年12月04日 22时16分03秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>

extern char **environ;
int main(int argc,char *argv[])
{
	int i;
	printf("Hello world!\n");
	for(i = 0;i<argc;i++)
	{
		printf("%s,",argv[i]);
	}
	printf("\n");
	//打印全部环境变量
	printf("打印全部环境变量\n");
	char **env = environ;
	while (*env)
	{
		printf("%s\n", *env);
		env++;
	}

	char *var, *value;
	var = "USER";
	value = getenv(var);
	if (value)
	{
		printf("[%s]: %s\n", var, value);
	}
	else
	{
		printf("[%s] 没有这个环境变量\n", var);
	}
	return 0;
}
