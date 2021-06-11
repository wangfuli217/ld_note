#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	void* pv = NULL;
	
	printf("sizeof-pv: %lu\n", sizeof pv);
	printf("sizeof-main: %lu\n", sizeof main);
	
	return 0;
}
