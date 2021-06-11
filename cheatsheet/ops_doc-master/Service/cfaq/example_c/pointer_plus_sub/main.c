#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define index(a, b) ((unsigned long)b - (unsigned long)a) / sizeof *a /* 指针不过是保存了地址的整型变量 */

int 
main(int argc, char **argv)
{
	int* array = malloc(sizeof *array * 10);
	
	int* p = array + 5;
	
	printf("array: 0x%p\n", array);
	printf("p: 0x%p\n", p);
	
	printf("p - array: %u\n", (uintptr_t)p - (uintptr_t)array);
	printf("p - array: %u\n", p - array); // 相隔元素个数
	printf("p - array: %lu\n", index(array, p));
	
	
	void* v = malloc(10);
	
	printf("v: %p\n", v);
	printf("v + 1: %p\n", v + 1);
	printf("v + 2: %p\n", v + 2);
	
	void* c = malloc(10);
	
	printf("c: %p\n", c);
	printf("c + 1: %p\n", c + 1);
	printf("c + 2: %p\n", c + 2);
	
	
	int i = 99999999;
	char *cc = &i;
	int *ii = cc;
	
	printf("ii: %d\n", *(int*)cc); // 按照 int 类型的宽度进行解引用
	printf("ii: %d\n", *ii);
	printf("ii: %d\n", *cc);
	
	system("pause");
	
	return 0;
}
