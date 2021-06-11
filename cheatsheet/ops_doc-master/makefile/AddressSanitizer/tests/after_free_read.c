#include <stdio.h>
#include <stdlib.h>

int main(){
	char *p = malloc(1);
	p[0] = 0xff;
	free(p);
	printf("%x\n", p[0]);
	return 0;
}
