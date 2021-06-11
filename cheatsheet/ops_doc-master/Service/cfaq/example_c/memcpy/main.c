#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	char a[10] = "123456789";
	char b[10] = {0};
	
	memcpy(b, a, 2);
	
	printf("B: %s\n", b);
	
	system("pause");
	
	
	return 0;
}
