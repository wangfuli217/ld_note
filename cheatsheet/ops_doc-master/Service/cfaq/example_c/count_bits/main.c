#include <stdio.h>
#include <stdlib.h>

#define POWER2(n) !(n & (n - 1))

static inline int*
count_bits(int num, int* rsz)
{
	int *pa;
	
	pa = (int*)malloc(sizeof(int) * num);
	memset(pa, 0, sizeof(int) * num);
	
	for (int idx = 0; idx <= num; idx++) {
		if (idx == 0) {
			continue;
		}
		if (POWER2(idx)) {
			*(pa + idx) = 1;
		}
		
	}
}

int main(int argc, char **argv)
{
	printf("hello world\n");
	return 0;
}
