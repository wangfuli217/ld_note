#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	int *p;
	
	p = NULL;
	
	delete p;
	
	free(p);
	
	return 0;
}
