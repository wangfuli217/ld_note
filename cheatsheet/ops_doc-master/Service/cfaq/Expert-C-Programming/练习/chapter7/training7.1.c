#include <stdio.h>
#include <stdlib.h>

int main()
{
    int MB = 0;
    while (malloc(1 << 20))
    {
        ++MB;
    }
    printf("Allocated %d MB total\n",MB);
}
