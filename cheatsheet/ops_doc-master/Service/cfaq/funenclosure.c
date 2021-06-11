/*
 * =====================================================================================
 *
 *       Filename:  funenclosure.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 02:11:17 PM
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

typedef void(*func_t)();
func_t test()
{
    void func1()
    {
        printf("%s\n", __func__);
    };
    return func1;
}
int main(int argc, char* argv[])
{
    test()();
    return EXIT_SUCCESS;
}
