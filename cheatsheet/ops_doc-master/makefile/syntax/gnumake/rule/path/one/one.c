#include <stdio.h>
#include "main.h"

extern void hello();
void main()
{
	printf("HelloWorld from one\r\n");
	printf("HelloWorld code = %d\r\n", TEST_CODE);
	hello();
}
