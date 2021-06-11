/*
 * =====================================================================================
 *
 *       Filename:  arrays.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 02:38:59 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <stdio.h>

void test1(void){
    int x[][2] =
    {
        { 1, 11 },
        { 2, 22 },
        { 3, 33 }
    };
    int col = 2, row = sizeof(x) / sizeof(int) / col;
    for (int r = 0; r < row; r++)
    {
        for (int c = 0; c < col; c++)
        {
            printf("x[%d][%d] = %d\n", r, c, x[r][c]);
        }
    }
}
void test2(void){
    int x[][2] =
    {
        { 1, 11 },
        { 2, 22 },
        { 3, 33 }
    };
    int len = sizeof(x) / sizeof(int);
    int* p = (int*)x;
    for (int i = 0; i < len; i++)
    {
        printf("x[%d] = %d\n", i, p[i]);
    }
}

void test3(void){
    int x[][2] =
    {
        { 1, 11 },
        { 2, 22 },
        { 3, 33 },
        [4][1] = 100,
        { 6, 66 },
        [7] = { 9, 99 }
    };
    int col = 2, row = sizeof(x) / sizeof(int) / col;
    for (int r = 0; r < row; r++)
    {
        for (int c = 0; c < col; c++)
        {
            printf("x[%d][%d] = %d\n", r, c, x[r][c]);
        }
    }

}

int main(int argc, char *argv){
    test1();
    test2();
    test3();
    return 0;
}

