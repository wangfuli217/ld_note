#include <stdio.h>
#include <stdlib.h>

int array[] = {23, 34, 12, 17, 204, 99, 16};
#define TOTAL_ELEMENTS (sizeof(array)/sizeof(array[0]))

int main()
{
    int d = -1, x;
    if(d <= TOTAL_ELEMENTS - 2)//if(d <= (int)TOTAL_ELEMENTS - 2)
    {
        x = array[d+1];
        printf("%d\n", x);
    }
    else
    {
        printf("error!");
    }
    return 0;
}
