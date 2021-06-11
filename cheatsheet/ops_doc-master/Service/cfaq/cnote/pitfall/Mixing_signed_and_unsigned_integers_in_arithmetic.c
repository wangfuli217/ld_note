#include <stdio.h>
int main(void)
{
    unsigned int a = 1000;
    signed int b = -1;
    if (a > b) puts("a is more than b");
    else puts("a is less or equal than b");
    return 0;
}