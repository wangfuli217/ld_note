#include<stdio.h>
#include<string.h>
char *mystrcat(char * const p_dest,const char *p_source)
{
	char *p_temp=p_dest+strlen(p_dest);
	const char *p_temp1=p_source;
	for(;p_temp1<=p_source+strlen(p_source);p_temp++,p_temp1++)
	{
		*p_temp=*p_temp1;
	}
	return p_dest;
}
int main()
{
	char str[20]={};
	char str1[10]={};
	scanf("%s",str);
	printf("%s\n",mystrcat(str,"woshis"));
	return 0;
}
