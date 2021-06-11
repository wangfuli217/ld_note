#include <stdio.h>
#include <stdlib.h>

static void
_param_order(int a, int b, int c, char* d)
{
	printf("a: %p\n", &a);
	printf("b: %p\n", &b);
	printf("c: %p\n", &c);
	printf("d: %p\n", &d);
}



int main(int argc, char **argv)
{
	_param_order(1, 2, 3, "hello");
	
	system("pause");
	return 0;
}
