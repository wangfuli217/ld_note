#include <stdio.h>

static int
__is_open()
{
	printf(__FUNCTION__);
	return 0;
}

static int
__is_close()
{
	printf(__FUNCTION__);
	return 1;
}

int main(int argc, char **argv)
{
	if (1 && __is_open() && __is_close()) {
		printf("this");
	}
	
	return 0;
}
