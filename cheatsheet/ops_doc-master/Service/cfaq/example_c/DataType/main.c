#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	unsigned int i = -1;
	
	printf("I: %u\n", i);
	
	printf("sizeof('a'):%d \n", sizeof('a')); // sizeof char*
    printf("sizeof(\"a\"):%d \n", sizeof("a")); // sizeof string
	printf("sizeof(1000.999): %d \n", sizeof(1000.999)); // sizeof double
	
	system("pause");
}
