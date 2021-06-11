#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int 
main(int argc, char **argv)
{
	int* a[2][3];
	
	printf("sizeof(a): %zu\n", sizeof a); /* a 的类型 int*[2][3] or int***  */
	printf("sizeof(*a): %zu\n", sizeof *a); /* *(a + 0) == sizeof a[0]  a的类型为int* [2][3] or int*** or int*(*)[3], *a == int** 3*sizeof(int*) */
	printf("sizeof(**a): %zu\n", sizeof **a); /* *(*(a + 0) + 0) == sizeof a[0][0] */
	printf("sizeof(***a): %zu\n", sizeof ***a); /* int* */
	printf("sizeof(*(&a)): %zu\n", sizeof *&a); /* &a 的类型为 int* (*)[2][3]  *a == int* [2][3] */
	
	printf("a: 0x%p\n", a);
	printf("&a: 0x%p\n", &a);
	printf("&a[0]: 0x%p\n", &a[0]);
	printf("&a[0][0]: 0x%p\n", &a[0][0]);
	
	
	char** b[3][4];
	
	printf("&b[1][3]:%p\n", &b[1][3]);
	printf("&b[0][0]:%p\n", &b[0][0]);
	printf("&b[1][3] - &b[0][0]: %d\n", &b[1][3] - &b[0][0]); /* 7  这里地址按照当前机器的字长进行计算，实际的地址数值差为28，但是这个类型是按照指针类型加减，
																	每个指针的大小是4B, 所以 28 / 4 = 7  
															   * */
	printf("&b[1][3] - &b[0][0]: %d\n", (uint32_t)&b[1][3] - (uint32_t)&b[0][0]); /* 7 */
	
	int** c[3][4];
	
	printf("&c[1][3]:%p\n", &c[1][3]);
	printf("&c[0][0]:%p\n", &c[0][0]);
	printf("&c[1][3] - &c[0][0]: %d\n", &c[1][3] - &c[0][0]); /* 7 */
	
	system("pause");
	
	return 0;
}
