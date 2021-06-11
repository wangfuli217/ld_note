#include <stdio.h>
#include <stdlib.h>

#define dup_printf(fmt, args...) printf(fmt, ##args), printf(fmt, ##args)

int 
main(int argc, char **argv)
{
	dup_printf("hello world: %s\n", "chenbo");
		
	system("pause");
	return 0;
}
