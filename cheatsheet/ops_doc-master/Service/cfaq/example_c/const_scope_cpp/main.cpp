#include <stdio.h>
#include <stdlib.h>

extern const int aa;

int main(int argc, char **argv)
{
	printf("hello world\n");

	int i = aa;
	
	return 0;
}