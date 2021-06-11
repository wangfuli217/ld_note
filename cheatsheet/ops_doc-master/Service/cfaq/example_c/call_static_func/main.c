#include <stdio.h>

extern void (*version_cb)(); // c 中 函数没有使用static定义或者声明的就是全局函数，但是变量必须使用extern才能引用

int main(int argc, char **argv)
{
	if (version_cb) version_cb();
	return 0;
}
