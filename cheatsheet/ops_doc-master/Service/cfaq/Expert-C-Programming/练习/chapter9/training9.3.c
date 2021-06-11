#include <stdio.h>

void my_function1(int *turnip)
{
    printf("%d\n",turnip[1]);
}

void my_function2(int turnip[])
{
    printf("%d\n",turnip[1]);
}

void my_function3(int turnip[10])
{
    printf("%d\n",turnip[1]);
}

int main()
{
    int a[10] ={0,1,2,3,4};
    my_function1(a);
    my_function2(a);
    my_function3(a);
}
