//与原型有关的类型提升
#include <stdio.h>

int main()
{
    union
    {
        double d;
        float f;
    }u;
    u.d = 10.0;
    printf("put in a double,pull out a float f = %f \n",u.f);
    u.f = 10.0;
    printf("put in a float, pull out a double d = %f \n", u.d);
}
