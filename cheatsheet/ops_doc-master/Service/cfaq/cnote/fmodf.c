#include <math.h> /* for fmodf() */
#include <stdio.h> /* for printf() */
int main(void)
{
    float x = 10.0;
    float y = 5.1;
    float modulus = fmodf(x, y);
    printf("%f\n", modulus); /* lf would do as well as modulus gets promoted to double. */
}

#if 0
#include <math.h> /* for fmodl() */
#include <stdio.h> /* for printf() */
int main(void)
{
    long double x = 10.0;
    long double y = 5.1;
    long double modulus = fmodl(x, y);
    printf("%Lf\n", modulus); /* Lf is for long double. */
}
#endif