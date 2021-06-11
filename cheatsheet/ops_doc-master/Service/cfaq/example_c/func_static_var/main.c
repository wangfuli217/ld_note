#include <stdio.h>

static void
print_var()
{
	static unsigned long _id = 9;
	
	printf("id: %lu\n", _id++);
}



int main(int argc, char **argv)
{
	for (unsigned int idx = 0; idx < 100; idx++) {
		print_var();
	}
	
	return 0;
}
