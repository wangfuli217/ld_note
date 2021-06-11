#include <stdio.h>

typedef void FUNC(int);

static void show(int i)
{
	printf("i: %d\n", i);
}

int main(int argc, char **argv)
{
	FUNC* f;
	FUNC  ft;
	
	f = &show;
	
	f(20);
	ft(30);

	return 0;
}
