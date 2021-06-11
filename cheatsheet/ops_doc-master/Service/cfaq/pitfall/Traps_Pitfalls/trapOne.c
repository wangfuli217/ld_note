#include <stdio.h>

void isOne(int i)
{
    if(i == 1)
        printf("One\n");
    else 
        printf("Not one\n");
}

int main()
{
    struct { int a:1; } s;
    s.a = 1;
    isOne(s.a);
    return 0;   
}