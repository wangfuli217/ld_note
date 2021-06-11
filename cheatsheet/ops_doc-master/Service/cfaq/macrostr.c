/*
 * =====================================================================================
 *
 *       Filename:  macrostr.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:34:00 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <string.h>
#include <stdlib.h>
#include <stdio.h>


#define test(name) ({   \
                    printf("%s\n", #name); })
int main(int argc, char* argv[])
{
    test(main);
    test("\"main");
    return EXIT_SUCCESS;
}
