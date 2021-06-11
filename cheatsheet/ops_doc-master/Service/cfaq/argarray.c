/*
 * =====================================================================================
 *
 *       Filename:  argarray.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 03:10:55 PM
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

/*  数组名默认指向第一元素指针，和 test2 一个意思 */
void test1(int len, int x[]){
    int i;
    for (i = 0; i < len; i++) {
        printf("x[%d] = %d; ", i, x[i]);
    }
    printf("\n");
}
/*  直接传递数组第一个元素指针 */
void test2(int len, int* x){
    for (int i = 0; i < len; i++) {
        printf("x[%d] = %d; ", i, *(x + i));
    }
    printf("\n");
}

/*  数组指针: 数组名默认指向第一个元素指针，&array 则是获得整个数组指针 */
void test3(int len, int(*x)[len]) {
    for (int i = 0; i < len; i++) {
        printf("x[%d] = %d; ", i, (*x)[i]);
    }
    printf("\n");
}
/*  多维数组: 数组名默认指向第一个元素指针，也即是 int(*)[] */
void test4(int r, int c, int y[][c]) {
    for (int a = 0; a < r; a++) {
        for (int b = 0; b < c; b++) {
            printf("y[%d][%d] = %d; ", a, b, y[a][b]);
        }
    }
    printf("\n");
}
/*  多维数组: 传递第一个元素的指针 */
void test5(int r, int c, int (*y)[c]){
    for (int a = 0; a < r; a++) {
        for (int b = 0; b < c; b++) {
            printf("y[%d][%d] = %d; ", a, b, (*y)[b]);
        }
        y++;
    }
    printf("\n");
}
/*  多维数组 */
void test6(int r, int c, int (*y)[][c]){
    for (int a = 0; a < r; a++) {
        for (int b = 0; b < c; b++) {
            printf("y[%d][%d] = %d; ", a, b, (*y)[a][b]);
        }
    }
    printf("\n");
}

/*  元素为指针的指针数组，相当于 test8 */
void test7(int count, char** s){
    for (int i = 0; i < count; i++) {
        printf("%s; ", *(s++));
    }
    printf("\n");
}
void test8(int count, char* s[count]){
    for (int i = 0; i < count; i++) {
        printf("%s; ", s[i]);
    }
    printf("\n");
}
/*  以 NULL  结尾的指针数组 */
void test9(int** x){
    int* p;
    while ((p = *x) != NULL) {
        printf("%d; ", *p);
        x++;
    }
    printf("\n");
}
int main(int argc, char* argv[]){
    int x[] = { 1, 2, 3 };
    int len = sizeof(x) / sizeof(int);
    test1(len, x);
    test2(len, x);
    test3(len, &x);
    int y[][2] ={
        {10, 11},
        {20, 21},
        {30, 31}
    };
    int a = sizeof(y) / (sizeof(int) * 2);
    int b = 2;
    test4(a, b, y);
    test5(a, b, y);
    test6(a, b, &y);
    char* s[] = { "aaa", "bbb", "ccc" };
    test7(sizeof(s) / sizeof(char*), s);
    test8(sizeof(s) / sizeof(char*), s);
    int* xx[] = { &(int){111}, &(int){222}, &(int){333}, NULL };
    test9(xx);
    return EXIT_SUCCESS;
}
