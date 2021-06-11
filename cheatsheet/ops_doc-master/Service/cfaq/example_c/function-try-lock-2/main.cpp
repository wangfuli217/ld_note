#include <stdio.h>
#include "base.h"

int 
main(int argc, char **argv)
try {
	B b(0);
} catch (...) {
	printf("create B failed.\n");
	return 0;
}
