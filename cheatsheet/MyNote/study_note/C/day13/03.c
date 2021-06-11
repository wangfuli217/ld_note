/*
   结构体演示
   */
#include<stdio.h>
typedef struct
{
	char ch;
	long long a;
	int num;
	char ch1;
	char ch2;
	short num1;
}stru;
int main()
{
	printf("%d\n",sizeof(stru));
	return 0;
}
