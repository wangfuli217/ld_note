#include <stdio.h>

#define IF 	{if(
#define THEN	) {
#define ELSE	} else {
#define FI	}} 

int main ()
{
    int hi = 8, low = 2, r;
    r = (hi << 4) | low;

    printf("r = %d\n", r);

    IF hi == 0
    THEN    IF low == 8
            THEN printf("error\n");
            FI
    ELSE    hi += low;
            printf("low: %d\n", hi);   
    FI
}