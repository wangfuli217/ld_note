#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#ifndef PRINT_1
#define PRINT_1 printf("1")
#endif 
#ifndef PRINT_0
#define PRINT_0 printf("0")
#endif

#ifndef PRINT_SPACE
#define PRINT_SPACE printf(" ")
#endif

#ifndef PRINT_LF
#define PRINT_LF printf("\n")
#endif


static int
varint32encode(char* buff, uint32_t i)
{
	uint32_t 	x;
	int 		n;

	x = i;
	n = 0;
	
	while(x > 127) {
		buff[n++] = 0x80 | (x & 0x7F);
		x >>= 7;
	}

	buff[n++] = (char)x;

	return n;	
}

static inline uint32_t
varint32decode(char* buff)
{
	uint32_t 	x, t;
	int 		n;
	
	n = 0;
	x = 0;
	
	for (int i = 0; i < 32; i += 7) {
		t = (uint32_t)buff[n++];
		
		x |= ((t & 0x7F) << i);	

		if (t & 0x80 == 0) {
			break;
		}
	}

	return x;
}

static int
varint64encode(char* buff, uint64_t i)
{
	uint64_t 	x;
	int 		n;
	
	x = i;
	n = 0;
	
	while(x > 127) {
		buff[n++] = 0x80 | (x & 0x7F);
		x >>= 7;
	}
	
	buff[n++] = (char)x;
	
	return n;
}

static uint64_t
varint64decode(char* buff)
{
	uint64_t 	x, t;
	int 		n;
	
	x = n = 0;
	
	for (int i = 0; i < 64; i += 7) {
		t = (uint64_t)buff[n++];
		
		x |= (t & 0x7F) << i;
		
		if (t & 0x8F == 0) {
			break;
		}
	}
	
	return x;
}

static inline void 
dump_binary(const char* b, unsigned int l) 
{
	for (unsigned int i = 0; i < l; i++) {
		for (unsigned int j = 0; j < 8; j++) {
			if ((*(b + i) << j) & 0x80 ) {
				PRINT_1;
			} else {
				PRINT_0;
			}
		}
		
		PRINT_SPACE;
	}
	
	PRINT_LF;
}



int
main(int argc, char* argv[])
{
	char buff[10] = {0};

	varint32encode(buff, 10000);

	printf("buff: %s\n", buff);
	
	dump_binary(buff, 10);
	
	printf("U: %u\n", varint32decode(buff));
	
	memset(buff, 0, 10);
	
	varint64encode(buff, 100000);
	printf("buff: %s\n", buff);
	dump_binary(buff, 10);
	printf("U: %u\n", varint64decode(buff));
	
	system("pause");
	
	return 0;
}