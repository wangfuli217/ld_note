#include<stdio.h>
#pragma pack(3)
#define GO goto
#pragma GCC poison goto
int main(void)
{
	GO ok;
	printf("main函数开始\n");
ok:
	printf("main函数结束\n");
	return 0;
}
