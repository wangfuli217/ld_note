#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
//#include "getword.h"

#define SIZE 20

// word��ʼ 
int start(int c)
{
	return isalpha(c);	
}

//word���� 
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
