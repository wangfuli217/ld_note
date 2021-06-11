#include <stdio.h>
#include <stdlib.h>

int main()
{
    char a[4][6];
    char *p[4];
    int j;
    for(j=0; j<= 4; j++)
        p[j] = malloc(6);
    a[1][2] = 'a';
    p[1][2] = 'p';
    printf("a:%#x a[1]:%#x a[1][2]:%#x %c\n",a,a[1],a[1]+2,*(a[1]+2));
    printf("P:%#x p[1]:%#x p[1][2]:%#x %c\n",p,p[1],p[1]+2,p[1][2]);
    for(j=0; j<= 4; j++)
        free(p[j]);
}
