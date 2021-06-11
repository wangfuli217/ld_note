#include<stdio.h>
int main()
{
	FILE *p_file=fopen("abc.txt","r");
	char ch=0;
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fread(&ch,sizeof(char),1,p_file);
	fread(&ch,sizeof(char),1,p_file);
	fread(&ch,sizeof(char),1,p_file);
	rewind(p_file);
	printf("%c\n",ch);
	printf("%ld\n",ftell(p_file));
	fclose(p_file);
	p_file=NULL;
	return 0;
}
