/*
 * =====================================================================================
 *
 *       Filename:  structinit_t.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:10:30 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */

typedef struct
{
    int x;
    short y[3];
    long long z;
} data_t;
int main(int argc, char* argv[])
{
    data_t d = {};
    data_t d1 = { 1, { 11, 22, 33 }, 2LL };
    data_t d2 = { .z = 3LL, .y[2] = 2 };
    return EXIT_SUCCESS;
}
