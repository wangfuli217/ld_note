#include <stdio.h>
#include "shared_ptr.h"
#include "unique_ptr.h"

int main(int argc, char **argv)
{
	__shared_ptr();
	
	//__shared_ptr_2();
	
	__shared_ptr_3();
	
	__unique_ptr();
	
	__CONSOLE__("exit main.\n");
	return 0;
}