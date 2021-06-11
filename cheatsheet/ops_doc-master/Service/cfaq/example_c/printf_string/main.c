#include <stdio.h>
#include <stdlib.h>

#define QUOTER "hello"

int main(int argc, char **argv)
{
	printf("hello world"QUOTER"\n");
	printf("hello world""QUOTER""\n");
	
	system("pause");
	
	return 0;
}
