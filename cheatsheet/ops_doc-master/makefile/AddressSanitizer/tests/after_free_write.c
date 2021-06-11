#include <stdio.h>
#include <stdlib.h>

int main(){
	char *p = malloc(1);
	free(p);
	p[0] = 0xff;
	return 0;
}
