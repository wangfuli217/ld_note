#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define cast(T, t) (T)(t)

#define UNUSED(t) cast(void, t)

typedef  struct {
	int a;
} __attribute__ ((aligned(sizeof(int)))) A;

int main(int argc, char **argv)
{
	char* pa = malloc(sizeof(char));
	char* paa = malloc(sizeof(char));
	
	printf("pa: 0x%p\n", pa);
	printf("paa: 0x%p\n", paa);
	
	int* p = cast(int*, malloc(sizeof(int))); //64 位下默认按照8byte对齐分配，所以所有地址都是000结尾
	
	*p = 100;
	
	int p_addr = cast(int, p); //指针地址转换为int保存
	
	//int* p_4 = (int*)(p_addr + 4);
	int* p_4 = cast(int *, (p_addr + 4)); // 地址 移动 4个 bytes，并转换成int*
	
	*p_4 = 999;
	
	int* pp = cast(int *, malloc(sizeof(int) * 11));
	
	intptr_t pp_addr = pp;
	
	
	
	printf("p: %p\n", p);
	printf("pp: %p\n", pp);
	printf("p_addr: %x\n", p_addr);
	printf("*p: %d\n", *p);
	printf("*p_4: %d\n", *p_4);
	printf("pp_addr: %x\n", pp_addr);
	printf("pp + 1: %p\n", pp + 1);
	printf("pp + 10: %p\n", pp + 10);
	
	
	system("pause");
	

	free(p);
	free(pp);
	
	return 0;
}
