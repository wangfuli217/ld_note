#include <stdio.h>
#include <stdlib.h>

static void 
for_test_1() 
{
	for (int i = 0; i < 10; i++, printf("i: %d\n", i)) {
		printf("loop: %d\n", i);
	}	
}

static void 
for_test_2() 
{
	int i = 10;
    
    for (; i < 10; i++, printf("i: %d\n", i)) {
		printf("loop: %d\n", i);
	}	
}b

int main(int argc, char **argv)
{
	for_test_2();
	
	system("pause");
}
