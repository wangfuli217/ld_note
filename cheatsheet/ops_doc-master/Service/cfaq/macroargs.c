/*
 * =====================================================================================
 *
 *       Filename:  macroargs.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:35:26 PM
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

#define println(format, ...) ({   \
                              printf(format "\n", __VA_ARGS__); })
int main(int argc, char* argv[])
{
    println("%s, %d", "string", 1234);
    return EXIT_SUCCESS;
}
#if 0
int main(int argc, char* argv[])
{
    ({ printf("%s, %d" "\n", "string", 1234); });
    return 0;
}
#endif
