#include <stdio.h>
#include <stdlib.h>

int main(){
	char *buf = malloc(10);
	printf("%x\n", buf[-1]);
	return 0;
}
