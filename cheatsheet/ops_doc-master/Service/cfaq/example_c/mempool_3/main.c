/*
 ============================================================================
 Name        : c.c
 Author      : 
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mempool.h"

extern void runCommand();

int main(void) {
	puts("!!!Hello World!!!"); /* prints !!!Hello World!!! */
//	printf("sizeof long %d",sizeof(long));
//	printf("sizeof long %d",sizeof(long long));
	SYS_MemInit();
	showMemAll();
	runCommand();

	return EXIT_SUCCESS;
}
