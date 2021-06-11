#include <stdio.h>
typedef char vegetable[20];
int main()
{
    char carrot1[10][20];   //二者等价
    vegetable carrot2[10];
    carrot1[0][0] = 'A';
    carrot2[0][0] = 'B';
    printf("carrot1(0,0):%c,carrot2(0,0):%c\n",carrot1[0][0],carrot2[0][0]);
    return 0;
}
