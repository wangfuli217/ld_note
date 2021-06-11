/*
   sizeof关键字演示
   */
#include<stdio.h>
int main()
{
	int num=3;
	printf("%u\n",sizeof(float));
	printf("%u\n",sizeof(3+5));
	sizeof(num=10);
	printf("%u\n",num);
	printf("%u\n",sizeof(num=100));
	return 0;
}
