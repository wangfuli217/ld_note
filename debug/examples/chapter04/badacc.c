#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]){
int len = 4;
int *pt=(int*)malloc(len*sizeof(int));
int *p = pt;
int i = 0;
for(i=0; i<len; i++)
	p++;

*p=5; /* invalid write */
printf("the value of p equal:%d", *p); /* invalid read */
return 0; /* mem leak */
}
