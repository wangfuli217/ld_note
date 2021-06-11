/*
 * =====================================================================================
 *
 *       Filename:  macrofunc.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:36:48 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <stdio.h>

#define test(x, y) ({   \
                    int _z = x + y;     \
                    _z; })
int main(int argc, char* argv[])
{
    printf("%d\n", test(1, 2));
    return EXIT_SUCCESS;
}
#if 0
int main(int argc, char* argv[])
{
    printf("%d\n", ({ int _z = 1 + 2; _z; }));
    return 0;
}
#endif
