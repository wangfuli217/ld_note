#include <stdio.h>
#include "mem.h"

int main(void)
{
	char *p1;
	char *p2;
	char *p3 = ALLOC(4);
	RESIZE(p3, 5);
	
	NEW(p1);
	NEW(p2);
	
//	FREE(p3);
//	FREE(p1);
//	FREE(p2);
	
	printf("0x%x\n", p1);
	printf("0x%x\n", p2);
	printf("0x%x\n", p3);	
	
	return 0;
}


