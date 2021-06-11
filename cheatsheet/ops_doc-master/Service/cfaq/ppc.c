/*
 * =====================================================================================
 *
 *       Filename:  ppc.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/19/2019 04:55:04 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <stdio.h>
int main(int argc, char* argv[])
{
#if __MY__
    printf("a");
#else
    printf("b");
#endif
    return EXIT_SUCCESS;
}

// tail -n 10  ppc.c
// gcc -E ppc.c -D__MY__ | tail -n 10
// gcc -E ppc.c -o ppc.i 
// gcc -C -E main.c -o main.i
//
// gcc -M -I./lib main.c
// gcc -MM -I./lib main.c  #  忽略标准库
