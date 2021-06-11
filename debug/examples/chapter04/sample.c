#include <stdlib.h>

void foo()
{
	int *p = (int*)malloc(sizeof(int)*10); /* mem leak */
	p[10]=10;                              /* invalid write */
}

int main(int argc, char *argv)
{
	foo();
	return 0;
}


