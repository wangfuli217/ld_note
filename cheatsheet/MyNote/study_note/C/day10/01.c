/*
   字符串演示
   */
#include<stdio.h>
int main()
{
	char *p_str="abcdef",*p_str1="abcdef",*p_str2="abc\"\"def";
	printf("%p\n%p\n",p_str,p_str1);
	printf("%p\n",p_str2);
	printf("%s\n",p_str2);
	return 0;
}
