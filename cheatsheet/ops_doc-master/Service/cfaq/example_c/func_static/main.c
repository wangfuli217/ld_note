#include <stdio.h>
#include <stdlib.h>

#include "def.h"

int main(int argc, char **argv)
{
	func_struct_t func;
	
	f_create(&func);
	
	func.cb();
	
	system("pause");
	
	return 0;
}
