#include "foo.h"

extern unsigned int aaa;

void 
show_var(unsigned int v)
{
	printf("v: %u\n", v);
	printf("aaa: %u\n", aaa);
}
