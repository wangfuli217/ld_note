#include <stdio.h>

int main()
{
    int x=1,y=2,z;
    //z = y+++++x; //会报错
    z = y++ + ++x;
    printf("x = %d\ny = %d\nz = %d\n",x,y,z);
    return 0;
}
