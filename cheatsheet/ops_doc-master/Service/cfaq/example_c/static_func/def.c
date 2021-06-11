#include "def.h"

void
inc2()
{
	static int cnt;
	
	printf("CNT: %d\n", cnt++);
}