#include <stdio.h>
#include <string.h>


int main()
{
    static unsigned short stopwatch[] = {
    0x07C6,
    0x1FF7,
    0x383B,
    0x600C,
    0x600C,
    0xC006,
    0xC006,
    0xDF06,
    0xC106,
    0xC106,
    0x610C,
    0x610C,
    0x3838,
    0x1FF0,
    0x07C0,
    0x0000
    };
    char buf[32];
    int n, i;
    n = sizeof(stopwatch)/sizeof(stopwatch[0]);
    for(i = 0; i < n; i++)
    {
     _itoa(stopwatch[i], buf, 2);
     printf("%016s\n", buf);
    }
    return 0;
}
