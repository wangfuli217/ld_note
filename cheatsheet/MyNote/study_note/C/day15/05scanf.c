/*
   fscanf函数演示
   */
#include<stdio.h>
int main()
{
	FILE *p_file=fopen("b.txt","r");
	char ch=0;
	float fnum=0.0f;
	int num=0;
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fscanf(p_file,"%c %g %d",&ch,&fnum,&num);
	printf("%c %g %d\n",ch,fnum,num);
	fclose(p_file);
	p_file=NULL;
	return 0;
}
