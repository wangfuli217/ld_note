/*
 * =====================================================================================
 *
 *       Filename:  funcptr.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 02:14:37 PM
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

typedef void(func_t)();          //  函数类型
typedef void(*func_ptr_t)();     //  函数指针类型
void test() {
    printf("%s\n", __func__);
}
int main(int argc, char* argv[]) {
    func_t* func = test;         //  声明?个指针
    func_ptr_t func2 = test;     //  已经是指针类型
    void (*func3)();             //  声明?个包含函数原型的函数指针变量
    func3 = test;
    func();
    func2();
    func3();
    return EXIT_SUCCESS;
}
