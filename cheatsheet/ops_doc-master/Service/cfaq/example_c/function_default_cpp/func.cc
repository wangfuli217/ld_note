#include "func.h"
#include <stdio.h>

int
version(unsigned long sec, unsigned long msec, unsigned long usec)
{
	printf("sec: %lu msec: %lu usec: %lu\n", sec, msec, usec);
	return 0;
}

int
func(unsigned long sec, bool isloop)
{
	return 0;
}