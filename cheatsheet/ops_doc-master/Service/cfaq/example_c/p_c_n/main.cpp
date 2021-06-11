#include <stdio.h>
#include <cstdlib>

int nn(unsigned int n)
{
	if (n == 0)
	{
		return 1;
	}
	
	return n * nn(n - 1);
}


int
p(const int& n, const int& m)
{
	if (n == 0)
	{
		return 0;
	}
	
	return nn(n) / nn(n - m);
}


int main(int argc, char **argv)
{
	printf("n!: %d\n", nn(3));
	printf("n-m: %d\n", p(3, 2));
	
	system("pause");
	
	return 0;
}
