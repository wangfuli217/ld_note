/*
   宏操作符
   */
#include<stdio.h>
#define STR(n)  #n
#define LOCAL(n)  l_##n##cd
int main()
{
	int num=0;
	int LOCAL(num)=35;
	printf("%s\n",STR(2+2));
	printf("%d\n",LOCAL(num));
	return 0;
}
