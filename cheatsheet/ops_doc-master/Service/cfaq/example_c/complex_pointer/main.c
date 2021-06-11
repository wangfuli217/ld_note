#include <stdio.h>
#include <stdlib.h>

typedef int (*(*function_t)[5])(int*);         // 定义一个类型是function_t类型函数指针的数组
typedef int (*(*function_2_t)(int*))[5];       // 定义一个指向 类型是function_2_t的数组指针；
typedef int* (*(*function_4_t)(int*))[5];

typedef int *(*(*function_3_t)(int))[10];

typedef int (*func)(int);

static int
__show_self(int* p) 
{
	printf("self: %d\n", *p);
}


int main(int argc, char **argv)
{
	function_2_t temp = malloc(sizeof(function_2_t));
	
	for (unsigned int idx = 0; idx < 5; idx++) {
		*((*temp) + idx) = &__show_self;
	}
	
 
	return 0;
}
