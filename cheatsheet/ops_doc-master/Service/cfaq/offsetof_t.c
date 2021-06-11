/*
 * =====================================================================================
 *
 *       Filename:  offsetof_t.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:06:52 PM
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
#include <stddef.h>

typedef struct {
    int x;
    short y[3];
    long long z;
} data_t;
int main(int argc, char* argv[]) {
    printf("x %d\n", offsetof(data_t, x));
    printf("y %d\n", offsetof(data_t, y));
    printf("y[1] %d\n", offsetof(data_t, y[1]));
    printf("z %d\n", offsetof(data_t, z));
    return EXIT_SUCCESS;
}
