#include <stdio.h>
#include <stdlib.h>
int 
main(int argc, char** argv)
{
	char str[20];
	int i;
	for (i=0; i<2; i++)
	{
		scanf("%[^\n]s", str);
		printf("%s\n", str);
		//fflush(stdin);
	}
	return 0;
}