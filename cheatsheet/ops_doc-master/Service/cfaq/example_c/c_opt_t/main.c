#include <stdio.h>
#include <stdlib.h>

#define BLOCKSIZE 8 

static void
loop_opt() 
{
	int i = 0; 
    int limit = 33;  /* could be anything */ 
    int blocklimit; 

    /* The limit may not be divisible by BLOCKSIZE, 
     * go as near as we can first, then tidy up.
     */ 
    blocklimit = (limit / BLOCKSIZE) * BLOCKSIZE; 

    /* unroll the loop in blocks of 8 */ 
    while( i < blocklimit ) 
    { 
        printf("process(%d)\n", i); 
        printf("process(%d)\n", i+1); 
        printf("process(%d)\n", i+2); 
        printf("process(%d)\n", i+3); 
        printf("process(%d)\n", i+4); 
        printf("process(%d)\n", i+5); 
        printf("process(%d)\n", i+6); 
        printf("process(%d)\n", i+7); 

        /* update the counter */ 
        i += 8; 

    } 

    /* 
     * There may be some left to do.
     * This could be done as a simple for() loop, 
     * but a switch is faster (and more interesting) 
     */ 

    if( i < limit ) 
    { 
        /* Jump into the case at the place that will allow
         * us to finish off the appropriate number of items. 
         */ 

        switch( limit - i ) 
        { 
            case 7 : printf("process(%d)\n", i); i++; 
            case 6 : printf("process(%d)\n", i); i++; 
            case 5 : printf("process(%d)\n", i); i++; 
            case 4 : printf("process(%d)\n", i); i++; 
            case 3 : printf("process(%d)\n", i); i++; 
            case 2 : printf("process(%d)\n", i); i++; 
            case 1 : printf("process(%d)\n", i); 
        }
    } 
}

static void
loop_opt_for()
{
	int max = 100;
	
	for(int i = max; i--;) {
		printf("i: %d\n", i);
	}
}


int main(int argc, char **argv)
{
	loop_opt();
	loop_opt_for();
	
	system("pause");
	return 0;
}
