#include <stdio.h>
#include <string.h>

#define X )*2+1
#define _ )*2
#define s ((((((((((((((((0 /* For building glyphs 16 bits wide */



int main()
{
    static unsigned short stopwatch[] =
    {
    s _ _ _ _ _ X X X X X _ _ _ X X _ ,
    s _ _ _ X X X X X X X X X _ X X X ,
    s _ _ X X X _ _ _ _ _ X X X _ X X ,
    s _ X X _ _ _ _ _ _ _ _ _ X X _ _ ,
    s _ X X _ _ _ _ _ _ _ _ _ X X _ _ ,
    s X X _ _ _ _ _ _ _ _ _ _ _ X X _ ,
    s X X _ _ _ _ _ _ _ _ _ _ _ X X _ ,
    s X X _ X X X X X _ _ _ _ _ X X _ ,
    s X X _ _ _ _ _ X _ _ _ _ _ X X _ ,
    s X X _ _ _ _ _ X _ _ _ _ _ X X _ ,
    s _ X X _ _ _ _ X _ _ _ _ X X _ _ ,
    s _ X X _ _ _ _ X _ _ _ _ X X _ _ ,
    s _ _ X X X _ _ _ _ _ X X X _ _ _ ,
    s _ _ _ X X X X X X X X X _ _ _ _ ,
    s _ _ _ _ _ X X X X X _ _ _ _ _ _ ,
    s _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
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
