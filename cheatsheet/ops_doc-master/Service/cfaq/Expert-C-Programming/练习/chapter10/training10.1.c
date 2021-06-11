#include <stdio.h>

int main()
{
    char pea[4][6];
    pea[1][2] = 'a';
    pea[1][0] = 'c';
    printf("pea[1][2] = %c\n",*(*(pea+1)+2));
    printf("pea[1][0] = %c\n",*(*(pea+1)));
}
