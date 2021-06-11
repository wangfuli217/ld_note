/* testmalloc.c Copyright 2007 Groetker, Holtmann, Keding, Wloka */
#include <stdio.h>
#include <stdlib.h>
#ifdef _MSC_VER
#define sleep()x _sleep(1000*(x))
#endif

#define blocksize 1024

/* make the program wait, to inspect process for memory use */
void wait_for_input(const char *prefix, int is_interactive){

	char c;
	if(is_interactive){
		printf("%s hit return to continue\n", prefix); fflush(stdout);
		c = getchar();
	}
	else
	{
		sleep(1);
	}
}
	

