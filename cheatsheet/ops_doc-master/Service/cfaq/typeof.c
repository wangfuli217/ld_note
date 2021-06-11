/*
 * =====================================================================================
 *
 *       Filename:  typeof.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:25:48 PM
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

#define test(x) ({      \
                 typeof(x) _x = (x); \
                 _x += 1;            \
                 _x;                 \
                 })
int main(int argc, char* argv[]){
    float f = 0.5F;
    float f2 = test(f);
    printf("%f\n", f2);
    return EXIT_SUCCESS;
}
