#include <stdio.h>
#include <stdlib.h>

int main(){
	char *buf = malloc(10);
	printf("%x", buf[10]);
	free(buf);
	return 0;
}
