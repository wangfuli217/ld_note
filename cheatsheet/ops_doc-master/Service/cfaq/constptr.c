/*
 * =====================================================================================
 *
 *       Filename:  constptr.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 05:11:20 PM
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
    int x[] = { 1, 2, 3, 4 };
    int* const p = x;
    for (int i = 0; i < 4; i++) {
        int v = *(p + i);
        *(p + i) = ++v;
        printf("%d\n", v);
        //p++;  // Compile Error!                                                             
    }
}

void test2(void){
    int x = 1, y = 2;
    int const* p = &x;
    //*p = 100; ! ! // Compile Error!
    p = &y;
    printf("%d\n", *p);
    ////*p = 100; ! ! // Compile Error!
}

void test3(void){
    const int x = 1;
    const int* p = &x;
    printf("%d\n", *p);
    *p = 1234;  ! ! ! // Compile Error!

}

int main(int argc, char *argv[]){
    test1();
    test2();
    test3();
    return 0;
}
