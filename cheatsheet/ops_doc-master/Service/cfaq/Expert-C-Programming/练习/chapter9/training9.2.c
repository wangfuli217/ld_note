#include <stdio.h>

int main()
{
    int a[10]={0,1,2,3,4,5,6,7,8,9},*p, i = 2;
    p = a;
    printf("%d %d \n",p[i],*(p+i));
    p = a+i;
    printf("%d\n",*p);
    printf("%d %d\n",a[6],6[a]);
    return 0;
}
