#include <stdio.h>
#include <stdlib.h>

void before() __attribute__((constructor));

void after() __attribute__((destructor));


int main(int argc, char **argv)
{
	printf("hello world\n");
	
	system("pause");
	
	return 0;
}


void before()
{
	printf("before\n");
}

void after()
{
	printf("after\n");
	system("pause");
}