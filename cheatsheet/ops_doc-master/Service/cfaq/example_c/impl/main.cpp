#include <stdio.h>
#include "impl.h"
#include <stdlib.h>
#include <string.h>

#define RESULT(a)	printf("From: %s\n", a)
#define PAUSE		system("pause")

int main(int argc, char **argv)
{
	char To[] = "Hello";
	char From[20] = {0};
	
	memcpy2(From, To, strlen(To));

	RESULT(From);//printf("From: %s\n", From);

	memset(From, 0, 20);
	
	strcpy2(From, To);
	
	RESULT(From);//printf("From: %s\n", From);
	
	PAUSE;
	
	return 0;
}
