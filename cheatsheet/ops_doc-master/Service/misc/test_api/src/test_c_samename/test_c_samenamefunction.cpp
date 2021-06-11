#include <stdio.h>

int test(int a, int b)
{
	printf("test(int a, int b)\n");
	return 0;
}

int test(int a)
{
	printf("test(int a)\n");
	return 0;
}
//编译出错
///tmp/ccHzzJE6.o:(.eh_frame+0x12): undefined reference to `__gxx_personality_v0'
int main(int argc, char *argv[]) {
	test(1);
	test(1,1);//不支持同名函数
	return 0;
}
