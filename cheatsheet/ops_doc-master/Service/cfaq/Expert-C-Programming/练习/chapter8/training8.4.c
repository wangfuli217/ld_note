#include <stdio.h>
#include <stdlib.h>
int main()
{
    char c1=44,c2=65;
    float f1,f2=34.0;
    double d=2.0;
    c1 = c1+c2;
    f1 = f2 * d;
    printf("%d,%c\n", sizeof(c1), c1);
    printf("%d,%lf\n", sizeof(f1),f1);
    return 0;
}
