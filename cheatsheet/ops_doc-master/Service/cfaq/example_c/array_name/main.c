#include <stdio.h>
#include <stdlib.h>

/*
&a[0][0]的指针类型为int *p，所以步长为4；
&a[0]的指针类型为int (*p) [3]，所以步长为12；
a的指针类型为int (*p) [3]，所以步长仍然为12；
&a的指针类型为int (*p) [2][3]，所以步长为24；
*/

static void
array_name() 
{
    int a[2][3];

    printf("&a[0][0] address is 0x%X\n", &a[0][0]);
    printf("&a[0]0]+1 address is 0x%X\n", &a[0][0]+1);
    printf("size of pointer step is 0x%X\n", sizeof(*(&a[0][0])));
    printf("\n");

    printf("&a[0] address is 0x%X\n", &a[0]);
    printf("&a[0]+1 address is 0x%X\n", &a[0] + 1);
    printf("size of pointer step is 0x%X\n", sizeof(*(&a[0])));
    printf("\n");

    printf("a address is 0x%X\n", a);
    printf("a+1 address is 0x%X\n", a + 1);
    printf("size of pointer step is 0x%X\n", sizeof(*a));
    printf("\n");

    printf("&a address is 0x%X\n", &a);
    printf("&a+1 address is 0x%X\n", &a + 1);
    printf("size of pointer step is 0x%X\n", sizeof(*(&a)));
    printf("\n");

    return 0;
}


int 
main(int argc, char **argv)
{
	char a[10];
	
	printf("a: 0x%x\n", a);
	printf("&a: 0x%x\n", &a);
	
	
	printf("&a[0]: 0x%x\n", &a[0]);
	printf("sizeof a : %d\n", sizeof a);
    
    
    array_name();
	
	system("pause");
	
	return 0;
}
