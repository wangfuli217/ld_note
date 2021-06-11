/*
 * =====================================================================================
 *
 *       Filename:  vaarg.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 02:25:46 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
/*  指定自变量数量 */
void test(int count, ...){
    va_list args;
    va_start(args, count);
    for (int i = 0; i < count; i++){
        int value = va_arg(args, int);
        printf("%d\n", value);
    }
    va_end(args);
}
/*  以 NULL  为结束标记 */
void test2(const char* s, ...){
    printf("%s\n", s);
    va_list args;
    va_start(args, s);
    char* value;
    do{
        value = va_arg(args, char*);
        if (value) printf("%s\n", value);
    }
    while (value != NULL);
    va_end(args);
}
/*  直接将 va_list 传递个其他可选自变量函数 */
void test3(const char* format, ...){
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
}
int main(int argc, char* argv[]){
    test(3, 11, 22, 33);
    test2("hello", "aa", "bb", "cc", "dd", NULL);
    test3("%s, %d\n", "hello, world!", 1234);
    return EXIT_SUCCESS;
}
