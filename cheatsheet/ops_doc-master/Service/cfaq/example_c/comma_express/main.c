#include <stdio.h>

#define setValue(v) (v = ~(unsigned int)0, 0) // 这个宏函数永远返回0，但是v的值已经设置

int main(int argc, char **argv)
{
	int a, b, c;
	
	a = 3 * 5, a + 5;
	printf("V: %d\n", (a = 3 * 5, a + 5));
	printf("V: %d\n", (a = 3, b = 5, b += a, c = b* 5));
	printf("V: %d %u\n", setValue(a), a);
	
	return 0;
}
