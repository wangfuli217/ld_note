#include <stdio.h>
#include <stdlib.h>

int main(){
	char *buf = malloc(1);
	printf("%x\n", buf[0]);
	free(buf);
	return 0;
}
