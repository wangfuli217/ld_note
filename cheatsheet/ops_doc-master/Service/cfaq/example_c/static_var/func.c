#include "foo.h"
#include <stdio.h>

void 
foo_var_2()
{
	foo_var();
	printf("%s %d\n", __func__, id++);
}