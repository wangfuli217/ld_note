#include <math.h>
#include <float.h>
#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
    double x, r;
    int exp;

    x = strtod(argv[1], NULL);
    r = frexp(x, &exp);

    printf("frexp(%g, &e) = %g: %g * %d^%d = %g\n",
           x, r, r, FLT_RADIX, exp, x);
    exit(EXIT_SUCCESS);
} /* main */

/*
$ ./a.out 2560
frexp(2560, &e) = 0.625: 0.625 * 2^12 = 2560
$ ./a.out -4
frexp(-4, &e) = -0.5: -0.5 * 2^3 = -4
*/