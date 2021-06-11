/*
 * =====================================================================================
 *
 *       Filename:  macrocat.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:31:41 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>

#define test(name, index) ({                          \
                           int i, len = sizeof(name ## index) / sizeof(int); \
                           for (i = 0; i < len; i++)                         \
                           {                                                 \
                           printf("%d\n", name ## index[i]);             \
                           }})
int main(int argc, char* argv[])
{
    int x1[] = { 1, 2, 3 };
    int x2[] = { 11, 22, 33, 44, 55 };
    test(x, 1);
    test(x, 2);
    return EXIT_SUCCESS;
}
