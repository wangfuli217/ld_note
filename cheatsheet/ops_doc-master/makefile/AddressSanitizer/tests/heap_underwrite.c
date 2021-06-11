#include <stdio.h>
#include <stdlib.h>

int main(){
	char *buf = malloc(10);
	buf[-1] = 0xff;
	free(buf);
	return 0;
}
