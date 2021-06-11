#include <stdio.h>
//#include <arpa/inet.h>
#include <stdint.h>

#define IS_BIG htons(1) == 1

#if __BYTE_ORDER == __LITTLE_ENDIAN
	#pragma message("__LITTLE_ENDIAN")
#elif  __BYTE_ORDER == __BIG_ENDIAN 
	#pragma message("__BIG_ENDIANtemp")
#endif
typedef union {
	char a;
	int b;
} A;

#define btol16(i)	 ( (((uint16_t)(i) & 0xff00) >> 8) | (((uint64_t)(i) & 0x00ff) << 8))
				
#define btol32(i) 	 ( (((uint32_t)(i) & 0xff000000) >> 24) | (((uint32_t)(i) & 0x00ff0000) >> 8) | 	\
					(((uint32_t)(i) & 0x000000ff) << 24) | (((uint32_t)(i) & 0x0000ff00) << 8) )

#define btolf(f) 	 ( (((float)(f) & 0xff000000) >> 24) | (((float)(f) & 0x00ff0000) >> 8) | 	\
					(((float)(f) & 0x000000ff) << 24) | (((float)(f) & 0x0000ff00) << 8) )

#define btol64(i) ((((uint64_t)(i) & 0xff00000000000000) >> 56) | (((uint64_t)(i) & 0x00ff000000000000) >> 40) | 	\
					(((uint64_t)(i) & 0x0000ff0000000000) >> 24) | (((uint64_t)(i) & 0x000000ff00000000) >> 8) |	\ 
					(((uint64_t)(i) & 0x00000000000000ff) << 56) | (((uint64_t)(i) & 0x000000000000ff00) << 40)	|	\
					(((uint64_t)(i) & 0x0000000000ff0000) << 24) | (((uint64_t)(i) & 0x00000000ff000000) << 8))
					
#define __ntohll(i) btol64(i)
#define __htonll	__ntohll
#define __htonf		btolf
#define __ntohf		btolf


static inline unsigned long long
htonll(unsigned long long l) 
{
	unsigned char *a, *b;
	unsigned long long temp;
	
	temp = l;
	
	a = &temp;
	b = &l;
	
	a[0] = b[7];
	a[1] = b[6];
	a[2] = b[5];
	a[3] = b[4];
	a[4] = b[3];
	a[5] = b[2];
	a[6] = b[1];
	a[7] = b[0];
	
	return temp;
}

#define ntohll(l) htonll(l)

static inline double 
htond(double d) /* 浮点型的数字按照IEEE标准进行，不能简单进行换位, 只能通过 double ---> string  -----> double 方式*/
{
}
#define ntohd(d) htond(d)

int main(int argc, char **argv)
{
//	if (IS_BIG)
//	{
//		printf("big endian\n");
//	}
//	else
//	{
//		printf("little endian\n");
//	}
	
	A aa;
	
	aa.b = 1;
	
	if (aa.a == 1)
	{
		printf("little endian\n");
	}
	else
	{
		printf("big endian\n");
	}
	
	int i = 0x1;
	
	if (*((char*)&i) == 1)
	{
		printf("little endian\n");
	}
	else
	{
		printf("big endian\n");
	}
	
	float f = 99.12;
	
	uint64_t u = 10000;
	
	uint64_t u_1 = __htonll(u);
	uint64_t u_2 = u_1;
	
	printf("u_1: %llu\n", u_1);
	printf("u_2: %llu\n", u_2);
	printf("u_1: %llu\n", __ntohll(u_1));
	printf("u_1: %llu\n", ntohll(u_1));
	
//	printf("float: %f\n", __htonf(f));
//	printf("float: %f\n", __ntohf(__htonf(f)));

//	double d_1 = 1000.1234;
//	
//	printf("d_1: %f\n", htond(d_1));
//	printf("d_1: %f\n", ntohd(d_1));
	
	return 0;
}
