#include <stdio.h>
#include <stdlib.h>


int 
main(int argc, char **argv)
{
	int *p;
    
    p = new int[10];
    
    printf("INT: %d\n", *p);
    
    system("pause");
	return 0;
}
