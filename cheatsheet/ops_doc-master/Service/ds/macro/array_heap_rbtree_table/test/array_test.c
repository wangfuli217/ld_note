#include <stdio.h>

#include "array.h"

ARR_DEF(bytearr, char);

int main(int argc, char **argv)
{
	struct bytearr arr = ARR_INITIALIZER;
	(void)argc; (void)argv;

	char *ptr = ARR_RESERVE_RIGHT(&arr, 100);
	printf("%ld\n", ARR_LENGTH(&arr));
	printf("%ld\n", ARR_SPACE_LEFT(&arr));
	printf("%ld\n", ARR_SPACE_RIGHT(&arr));

	return 0;
}
