#include <stdio.h>

int main()
{
    int apricot[2][3][5]={{{1,2,3,4,5},{6,7,8,9,0},{11,12,13,14,15}}};
    int (*r)[5] = apricot[0];
    int *t = apricot[0][0];

    printf("(*r)[4]:%d,*t:%d, apricot[0][0][1]:%d",(*r)[4],*t,apricot[0][0][1]);

}
