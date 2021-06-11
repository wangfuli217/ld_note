/*
 * =====================================================================================
 *
 *       Filename:  ptrarray.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 05:32:49 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <stdio.h>

void array1(void) {
    int x[] = {1,2,3,4,5,6};
    int (*p)[] = &x; // 指针 p 指向数组

    for(int i = 0; i < 6; i++) {
        printf("%d\n", (*p)[i]); // *p 返回该数组, (*p)[i] 相当于 x[i]
    }
}
void array2(void) {
    int x[][4] = {{1, 2, 3, 4}, {11, 22, 33, 44}};
    int (*p)[4] = x;  // 相当于 p = &x[0]

    for(int i = 0; i < 2; i++) {
        for (int c = 0; c < 4; c++) {
            printf("[%d, %d] = %d\n", i, c, (*p)[c]);
        }
        p++;
    }
}
void array3(void) {
    int x[][4] = {{1, 2, 3, 4}, {11, 22, 33, 44}};
    int (*p)[][4] = &x;

    for(int i = 0; i < 2; i++) {
        for (int c = 0; c < 4; c++) {
            printf("[%d, %d] = %d\n", i, c, (*p)[i][c]);
        }
    }
}

int main(int argc, char *argv[]){
    array1();
    array2();
    array3();
    return 0;
}
