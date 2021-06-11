#include<stdio.h>
void func(void)
{
	static int num=0;
	printf("num是%d\n",num);
	num=100;
}
int main()
{
	func();
	func();
	return 0;
}
