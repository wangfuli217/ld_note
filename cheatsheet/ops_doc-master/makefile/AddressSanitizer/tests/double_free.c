#include <stdio.h>
#include <stdlib.h>

int main(){
	void *p = malloc(1);
	free(p);
	free(p);
	return 0;
}
