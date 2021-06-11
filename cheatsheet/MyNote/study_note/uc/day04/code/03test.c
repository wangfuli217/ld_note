//进行一个简单的测试
#include<stdio.h>
int main(void)
{
	int *pi=(int*)0xbfba537c;
	printf("*pi=%d\n",*pi);
	return 0;
}
