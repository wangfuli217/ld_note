#include<stdio.h>
int main()
{
#if defined(YI)
	printf("1\n");
#elif	defined(ER)
	printf("2\n");
#elif	defined(SAN)
	printf("3\n");
#else
	printf("4\n");
#endif
	return 0;
}
