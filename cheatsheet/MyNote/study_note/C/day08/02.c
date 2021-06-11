#include<stdio.h>
void print(int num,int num1)
{
	printf("%d X %d = %d\n",num,num1,num*num1);
}
int main()
{
	print(1,9);
	print(2,8);
	print(3,7);
	print(4,6);
	print(5,5);
	return 0;
}
