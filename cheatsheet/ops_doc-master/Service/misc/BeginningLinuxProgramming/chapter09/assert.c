#include <stdio.h>
#include <math.h>
#include <assert.h>
extern double sqrt(double );
//assert¾¯¸æ
double my_sqrt(double x)
{
    assert(x >= 0.0);
    return (x);
}

int main(void)
{
    printf("sqrt +2 = %g\n", my_sqrt(2.0)); 
    printf("sqrt -2 = %g\n", my_sqrt(-2.0));
    exit(0);
}
