#include <stdio.h>
#include <stdlib.h>
int main(int argc, char** argv)
{
    int val;
    if (argc < 2)
    {
GoalKicker.com – C Notes for Professionals 42
        printf("Usage: %s <integer>\n", argv[0]);
        return 0;
    }
    val = atoi(argv[1]);
    printf("String value = %s, Int value = %d\n", argv[1], val);
    return 0;
}

#if 0
$ ./atoi 100
String value = 100, Int value = 100
$ ./atoi 200
String value = 200, Int value = 200

$ ./atoi 0x200
0
$ ./atoi 0123x300
123

$ ./atoi hello
Formatting the hard disk...
#endif