#include <stdio.h>
#include <stdlib.h>

enum color {
	red,
	green,
	yellow
};

int main(int argc, char **argv)
{
	printf("sizeof: %d\n", sizeof(enum color));
	
	system("pause");
	
	return 0;
}
