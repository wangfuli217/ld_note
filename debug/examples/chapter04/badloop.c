#include <stdlib.h>
#include <stdio.h>
int main(int argc, char *argv[]){
	int a[5];
	int i, s;
	a[0] = 	a[1] = 	a[3] = 	a[4] = 0;
	s = 0;
	for(i=0; i<5; i++)
		s +=a[i]; /* invalid read */

	if(s == 377)
		printf("sum value %s", s);

	return 0; /* mem leak */

}
