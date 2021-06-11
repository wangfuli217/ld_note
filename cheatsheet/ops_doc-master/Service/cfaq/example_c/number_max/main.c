#include <stdio.h>
#include <stdlib.h>

#define INT32_MAX 0x7FFFFFFF
#define INT32_MIN (INT32_MAX + 1) // 0x80000000 == min  按照补码的计算方式          0xFFFFFFFF == -1

#define UINT32_MAX 0xFFFFFFFFU
#define UINT32_MIN 0x0

#define INT64_MAX 0x7FFFFFFFFFFFFFFFLL  /* 0x7FFFFFFFFFFFFFFFLL */
#define INT64_MIN 0x8000000000000000LL // (INT64_MAX + 1)

#define UINT64_MAX 0xFFFFFFFFFFFFFFFULL /* 0xFFFFFFFFFFFFFFFLLU */


typedef struct {
	int i24:24;
	int	:8;
} int24_t;

typedef struct {
	unsigned int u24:24;
	unsigned int :8;
} uint24_t;

typedef struct {
	unsigned long long i48:48;
	unsigned long long :16;
} int48_t;

#define INT24_MAX 0x7FFFFF
#define INT24_MIN ~INT24_MAX //(-INT24_MAX - 1)

#define UINT24_MAX 0xFFFFFF

#define INT48_MAX 0x7FFFFFFFFFFF
#define INT48_MIN ~INT48_MAX

int main(int argc, char **argv)
{
	unsigned long long ll = 1000ULL;
	
	
	printf("INT24_MAX: %d\n", INT24_MAX);
	printf("INT24_MIN: %d\n", INT24_MIN);
	
	printf("UINT24_MAX: %d\n", UINT24_MAX);
	
	printf("INT48_MAX: %lld\n", INT48_MAX);
	printf("INT48_MIN: %lld\n", INT48_MIN);
	
	printf("INT32_MAX: %d\n", INT32_MAX);
	printf("INT32_MIN: %d\n", INT32_MIN);
	
	
	printf("UINT32_MAX: %u\n", UINT32_MAX);
	printf("UINT32_MIN: %d\n", UINT32_MIN);
	
	printf("INT64_MAX: %lld\n", INT64_MAX);
	printf("INT64_MIN: %lld\n", INT64_MIN);
	
	printf("UINT64_MAX: %llu\n", ~-1);
	
	system("pause");
	return 0;
}
