#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	short s = 99;

	printf("short: %#x\n", (int)s);
	printf("float: %.14f\n",  232.111111111111);
	printf("float: %.14g\n",  232.111111111111);
	printf("float: %100.14f\n",  232.111111111111);
	system("pause");

	return 0;
}
