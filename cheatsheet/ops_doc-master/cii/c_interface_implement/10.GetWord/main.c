#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
//#include "getword.h"

#define SIZE 20

// wordÆğÊ¼ 
int start(int c)
{
	return isalpha(c);	
}

//wordÄÚÈİ 
int rest(int c)
{
	return isalpha(c) || c == '_';
}

int main(void)
{
	
	char buffer[SIZE];
	FILE *fp = fopen("test.txt","r");
	memset(buffer,0,SIZE);
	while(getword(fp,buffer,SIZE,start,rest))
		printf("%s\n",buffer);	
	return 0;
}
