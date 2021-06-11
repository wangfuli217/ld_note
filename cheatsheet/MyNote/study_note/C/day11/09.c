/*
   条件编译
   */
#include<stdio.h>
#define YI 1
int main()
{
#ifdef   YI
	printf("1\n");
	printf("sldf\n");
#else
	printf("2\n");
#endif
	return 0;
}
