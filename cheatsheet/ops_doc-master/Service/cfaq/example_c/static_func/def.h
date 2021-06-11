#ifndef __DEF_H_
#define __DEF_H_

#include <stdio.h>

static void
inc()
{
	static int cnt;
	
	printf("cnt: %d\n", cnt++);
	
}

void
inc2();

#endif
