#include <stdio.h>
#include <stdlib.h>

#define int_max (1 << 31) - 1 // ~(1 << 31)
#define uint_max (~0)
#define ulong_max ((unsigned long)~0UL) // (unsigned long)-1
#define ulonglong_max (~0ULL) // (~0LLU)


int main(int argc, char **argv)
{
	printf("int_max: %d\n", int_max);
	printf("uint_max: %u\n", uint_max);
	printf("uint_max: %lu\n", ulong_max);
	printf("ulonglong_max: %llu\n", ulonglong_max);
	printf("V: %u\n", 2177452108 - 0);
	printf("V: %d\n", 2177452108 - 0);
	printf("V: %d\n", ~2177452108);
	system("pause");
	
	return 0;
}
