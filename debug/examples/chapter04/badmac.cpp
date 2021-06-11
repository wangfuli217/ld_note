#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
	int i;
	char *p = (char*)malloc(10);
	char *pt = p;

	for(i=0; i<10; i++)
		p[i] = 's';
	delete p;

	pt[1] = 'x';
	free(pt);
	return 0;
}


