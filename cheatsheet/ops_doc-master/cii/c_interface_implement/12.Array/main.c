#include <stdio.h>
#include "array.h"
#include "arrayrep.h"

int main(void)
{
	Array_T t = Array_new(10,sizeof (long));
	Array_free(&t);
	return 0;
}


