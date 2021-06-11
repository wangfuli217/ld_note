#include <stdio.h>
#include "def.h"


static void 
__inc_2()
{
	inc();
	inc2();
}

int main(int argc, char **argv)
{
	__inc();
	__inc();
	__inc_2();
	__inc_2();
	return 0;
}
