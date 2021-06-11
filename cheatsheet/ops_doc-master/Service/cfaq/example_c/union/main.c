#include <stdio.h>
#include <stdlib.h>

typedef union
{
	void * ptr;
	short  i;
}PP;



int main(int argc, char **argv)
{
	PP p;
	
	p.i = 1;
	
	p.ptr = malloc(10);	
	
	printf("P.I: %d\n", p.i);
	printf("P.I: %d\n", p.ptr);
	
	system("pause");
	
	return 0;
}
