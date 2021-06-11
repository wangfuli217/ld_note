#include <stdio.h>
#include <stdlib.h>

int main(){
	char *buf = malloc(10);
	buf[10] = 0xff;
	free(buf);
	return 0;
}
