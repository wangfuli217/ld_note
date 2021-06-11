#include <stdio.h>
#include <stdlib.h>

int 
main(int argc, char **argv)
{
	int i = 10;
	
	switch (i) {
	case 1 ... 9:
		printf("I is in\n");
		break;
	case 11:
	case 12:
		printf("m is n\n");
		break;
	default:
		break;
	}
	
	system("pause");
	
	return 0;
}
