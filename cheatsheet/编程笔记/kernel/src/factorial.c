#include <stdio.h>

int fac();
int n = 4;

int
main()
{
	int a = fac();

	printf("%d\n", a);
	return 0;
}

#if 0
int
fac(int n)
{

	if (n > 1) {
		n *= fac(n - 1);
	}

	return n;
}
#endif
int
fac()
{
	int res = 1;
	if (n > 1) {
		res *= n;
		n -= 1;
		res *= fac();
	}
	return res;
}
