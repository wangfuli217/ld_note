#include <stdio.h>
#include "debug.h"

void tohex(char* start, int len){
	int x=0;
	for(;x<len;x++){				
		printf("%x ",*(start+x));		
	}									
	putchar(10);						
}

