#include <stdio.h>
#include <stdlib.h>

typedef unsigned char BYTE;


int main(int argc, char **argv)
{
	BYTE i = 10;
	
	i = 255;
	
	printf("byte: %d\n", i);
	
	system("pause");
	
	return 0;
}
