#include <stdio.h>
#include <stdlib.h>

static void 
func(char* p) 
{
	printf("is func char* \n");
}

static void 
func(int i) 
{
	printf("is func int \n");
}

static int // 必须参数有差异才能重载
func(int i)
{
	return 0;
}

int 
main(int argc, char **argv)
{
	func(NULL); // c++03 c++11 invoke func(int i)
	func(nullptr); //c++11 invoke func(char* p)
	
	system("pause");
	
	return 0;
}
