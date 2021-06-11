/*
   联合演示
   */
#include<stdio.h>
union un
{
	char ch;
	int num;
};
int main()
{
	union un abc;
	abc.ch='a';
	printf("%d\n",sizeof(union un));
	return 0;
}
