//#error和#warning的使用
#include<stdio.h>
#define VERSION 4
#if(VERSION<3)
	#error "版本过低"
#elif(VERSION>3)
	#warning "版本过高"
#endif
int main(void)
{
	printf("程序正常运行\n");
	return 0;
}
