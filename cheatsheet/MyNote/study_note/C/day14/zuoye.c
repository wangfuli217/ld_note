#include<stdio.h>
#include<stdlib.h>
char *strcp(const char *p_str1,const char *p_str2)
{
	int i=0;
	char *p_ret=NULL;
	for(i=0;*(p_str2+i)!='\0';i++);
	p_ret=(char *)malloc((i+1)*sizeof(char));
	if(!p_ret)
	{
		printf("分配失败\n");
		exit(0);
	}
	for(i=0;*(p_str2+i)!='\0';i++)
		*(p_ret+i)=*(p_str2+i);
	*(p_ret+i)='\0';
	return p_ret;
}
int main()
{
	char *p_str1=NULL,*p_str2=NULL;
	p_str1=strcp("abcd","efg");
	printf("%s\n",p_str1);
	free(p_str1);
	p_str1=NULL;
	return 0;
}
