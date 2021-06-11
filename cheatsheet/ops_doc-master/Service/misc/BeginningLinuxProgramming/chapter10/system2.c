#include <stdlib.h>
#include <stdio.h>
/*
	由于程序是后台执行的所以，
*/
int main(void)
{
    printf("Running ps with system\n");
    system("ps -ax &");
    printf("MS Done.\n");
	printf("Linux Done.\n");
	printf("Os Done.\n");
    exit(0);
}
