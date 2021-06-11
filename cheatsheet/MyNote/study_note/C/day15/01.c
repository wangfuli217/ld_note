/*
   文件操作代码演示
   */
#include<stdio.h>
int main()
{
	FILE *p_file=fopen("a.txt","w");
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fclose(p_file);
	p_file=NULL;
	return 0;
}

