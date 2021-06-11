#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	//地址增大
	int* p = malloc(sizeof(int));
	printf("p : %p\n", p);
	
	int* q = p;
	
	*p = 100;
	
	p = realloc(p, 20);
	printf("p : %p\n", p);
	
	printf("*p : %d\n", *p); // *p 的内容不变 范围是 newsize - oldsize 内容不变
	
	//*q = 10; //这里不能使用，因为原来的地址已经被realloc释放

	
	
	//地址容量缩小，扩充后的地址不一定与源地址相当
	int* pp = malloc(sizeof(int) * 10);
	
	*pp = 999;
	
	int* qq = pp + 5;
	
	pp = realloc(pp, 5);
	
	*qq = 100;
	
	printf("pp : %d\n", *pp);
	printf("qq : %d\n", *qq);
	
	
	//缩小到0
	
	int* zero = malloc(10);
	
	int* zero_1 = realloc(zero, 0);
	
	printf("Zero_1: %p\n", zero_1);
	
	system("pause");
	
	free(p);
	
	return 0;
	
}
