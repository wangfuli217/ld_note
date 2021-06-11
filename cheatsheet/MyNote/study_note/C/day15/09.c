/*
   位置指针演示
   */
#include<stdio.h>
int main()
{
	int ch=0;
	FILE *p_file=fopen("abc.txt","r");
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fseek(p_file,2,SEEK_SET);
	fread(&ch,sizeof(char),1,p_file);
	printf("%c\n",ch);
	fseek(p_file,4,SEEK_CUR);
	fread(&ch,sizeof(char),1,p_file);
	printf("%c\n",ch);
	fseek(p_file,-2,SEEK_END);
	fread(&ch,sizeof(char),1,p_file);
	printf("%c\n",ch);
	fclose(p_file);
	p_file=NULL;
	return 0;
}
