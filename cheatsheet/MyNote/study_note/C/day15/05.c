/*
   fprintf函数演示
   */
#include<stdio.h>
int main()
{
	FILE *p_file=fopen("b.txt","w");
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fprintf(p_file,"%c %g %d\n",'t',5.23f,48);
	fclose(p_file);
	p_file=NULL;
	return 0;
}
