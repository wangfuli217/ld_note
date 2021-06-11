#include "debug.h"

void tohex(char* start, int len){
	int x=0;
	for(;x<len;x++){				
		printf("%x ",*(start+x));		
	}									
	printf("\n");						
}

void tobin(unsigned int num){
	unsigned int dup=num,tmp=0,factor=0;
	int i=0;
	for(i=31;i>=0;i--){
		tmp=(dup>>i)&0x1;
		printf("%d",tmp);
		if(i%4==0){
			printf(" ");
		}
	}
	printf("\n");
}


