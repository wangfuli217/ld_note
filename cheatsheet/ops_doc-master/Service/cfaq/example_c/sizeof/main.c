#include <stdio.h>
#include <stdlib.h>

#define SIZEOF(v) (char*)(&v + 1) - (char*)(&v)

int main(int argc, char **argv)
{
	int i = 99;
		
	char a[100];
    long l;
		
	printf("sizeof: %lld\n", SIZEOF(i));
	printf("sizeof: %lld\n", SIZEOF(a));
    printf("sizeof: %lld\n", SIZEOF(l));
	
	system("pause");
	
	return 0;
}
