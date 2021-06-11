#include <stdio.h>

static void 
__debug_hex(unsigned long l) 
{
	unsigned char *p = NULL;
	
	p = (unsigned char*)&l;
	
	printf("HEX: 0x");
	for (unsigned int idx = 0; idx < sizeof l; idx++) {
		printf("%02x ", *(p + idx));
	}
	printf("\n");
}

int main(int argc, char **argv)
{
	unsigned int 	ii = 18;
	unsigned int 	iii = 100;
	unsigned long 	ll;
	unsigned long 	*pll = NULL;
	unsigned int 	*pii = NULL;
	
	pll = &ii;
	pii = &iii;
	
	ll = *pll;
	
	__debug_hex(ll);
	
	printf("ll: %lu\n", ll);
	printf("iii: %u\n", *(pii + 1));
	printf("Aii: %p\n", &ii);
	printf("Aiii: %p\n", &iii);
	
	return 0;
}
