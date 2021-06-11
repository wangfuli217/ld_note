#include <string.h>
#define DUMBCOPY for(i=0; i<65535; i++) \
                destination[i] = source[i]
#define SMARTCOPY memcpy(destination, source, 65536)

int main()
{
    int i, j;
    char source[65536],destination[65536];
    for(j=0; j<100; j++)
        SMARTCOPY;
}
