#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

static long seed = 0; //全局变量

static long random_1()
{
	srand(time(NULL));
	for(int i = 0; i < 4; i++)
	{
		printf("R:%d\n", rand());
	}
}

static long random_2()
{
	for(int i = 0; i < 4; i++)
	{
		printf("R:%d\n", rand_r(&seed));
	}
}

static long random_3()
{
	srandom(time(NULL));
	for(int i = 0; i < 4; i++)
	{
		printf("R:%d\n", random());
	}
}

int main(int argc, char **argv)
{
	seed = time(NULL);

	random_1();
	random_2();
	random_3();
	
	system("pause");
	
	return 0;
}
