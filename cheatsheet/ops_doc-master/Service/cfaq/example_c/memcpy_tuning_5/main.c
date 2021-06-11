#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __GNUC__
	#define memcpy memcpy_128
#else
	#define memcpy memcpy_64
#endif


static void
memcpy_64(void * dest, const void* src, unsigned int size)
{
	char* c_dest = (char*) dest;
	const char* c_src = (const char*)src;
	unsigned int c_size = size;
	
	while(c_size > sizeof(uint64_t)) {
		*(uint64_t*)c_dest = *(uint64_t*)c_src;
		
		c_dest += sizeof(uint64_t);
		c_src += sizeof(uint64_t);
		
		c_size -= sizeof(uint64_t);

	}
	
	while(c_size--) {
		*c_dest++ = *c_src++;
	}
}

static void
memcpy_128(void* dest, const void* src, size_t size)
{
	char* c_dest = (char*) dest;
	const char* c_src = (const char*)src;
	unsigned int c_size = size;
	
	while(c_size > sizeof(__uint128)) {
		*(__uint128*)c_dest = *(__uint128*)c_src;
		
		c_dest += sizeof(__uint128);
		c_src += sizeof(__uint128);
		
		c_size -= sizeof(__uint128);

	}
	
	while(c_size--) {
		*c_dest++ = *c_src++;
	}	
}

typedef struct {
	__int128_t a;
	__int128_t b;
}int256_t;

static void
memcpy_256(void* dest, const void* src, size_t size)
{
	char* c_dest = (char*) dest;
	const char* c_src = (const char*)src;
	unsigned int c_size = size;
	
	while(c_size > sizeof(int256_t)) {
		*(int256_t*)c_dest = *(int256_t*)c_src;
		
		c_dest += sizeof(int256_t);
		c_src += sizeof(int256_t);
		
		c_size -= sizeof(int256_t);

	}
	
	while(c_size--) {
		*c_dest++ = *c_src++;
	}	
}

int main(int argc, char **argv)
{
	char src[10] = "123456789";
	char dest[10] = {0};
	
	for (int i = 0; i < 10; i++) {
		printf("src[%d]: %p\n", i, src + i);
	}
	
	char* p = src;
	
	(unsigned long*)p++;
	
	printf("p: %p\n", p);
	
	printf("long: %zu\n", sizeof(uint64_t));
	
	memcpy_q(dest, src, strlen(src));
	
	printf("dest: %s\n", dest);
	
	system("pause");
	
 	return 0;
}
