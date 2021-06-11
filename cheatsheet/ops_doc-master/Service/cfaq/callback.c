/*
 * =====================================================================================
 *
 *       Filename:  callback.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 05:25:19 PM
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

void test(void) {
    printf("test");
}
typedef void(func_t)();
typedef void(*func_ptr_t)();
int main(int argc, char* argv[]) {
    func_t* f = test;
    func_ptr_t p = test;
    f();
    p();
    return EXIT_SUCCESS;
}
