#include<stdio.h>
int main(int argc,char *argv[])
{
	FILE *p_file=fopen(argv[1],"r");
	FILE *p_file1=NULL;
	char buf[1024*1024]={};
	int size=0;
	if(!p_file)
	{
		printf("对不起,%s不存在\n",argv[1]);
		return 0;
	}
	p_file1=fopen(argv[2],"w");
	if(!p_file1)
	{
		printf("对不起,打开失败\n");
		fclose(p_file);
		p_file=NULL;
		return 0;
	}
	while(1)
	{
		size=fread(buf,sizeof(char),1024*1024,p_file);
		if(size==0)
			break;
		fwrite(buf,sizeof(char),size,p_file1);
	/*	if(EOF!=fscanf(p_file,"%c",&ch))
			fprintf(p_file1,"%c",ch);
		else
			break;*/
	}
	fclose(p_file);
	p_file=NULL;
	fclose(p_file1);
	p_file1=NULL;
	return 0;
}
