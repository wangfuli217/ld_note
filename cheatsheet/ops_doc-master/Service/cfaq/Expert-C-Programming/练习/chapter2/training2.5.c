#include <stdio.h>

int main()
{
    char p;
    char i = 2;
    char apple;
    p = i;
    apple = sizeof(int) * p; //int的长度乘以p，若p为指针会报错。
    printf("%d\n", apple);
}
