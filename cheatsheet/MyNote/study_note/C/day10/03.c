/*
   strlen函数演示
   */
#include<stdio.h>
#include<string.h>
int main()
{
/*	char str[20]="abcdefg";
	strcat(str,"hig");
	printf("%s\n",str);*/
//	printf("%d\n",strncmp("abcd","abd",2));
	printf("%p\n",strstr("abcdef","cde"));
	return 0;
}
