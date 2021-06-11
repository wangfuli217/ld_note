/*
 * =====================================================================================
 *
 *       Filename:  longjmp.c
 *       setjmp 将当前位置的相关信息 (堆栈帧、寄存器等)  保存到 jmp_buf *结构中，并返回 0。
 *       当后续代码执行longjmp 跳转时，需要提供?个状态码。代码执行绪将返回 *setjmp 处
 *       并返回 longjmp 所提供的状态码。
 *        Version:  1.0
 *        Created:  04/18/2019 02:07:21 PM
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
#include <stdbool.h>
#include <setjmp.h>

void test(jmp_buf *env){
    printf("1....\n");
    longjmp(*env, 10);
}
int main(int argc, char* argv[]){
    jmp_buf env;
    int ret = setjmp(env);
    if (ret == 0) {
        test(&env);
    }
    else { 
        printf("2....(%d)\n", ret);
    }
    return EXIT_SUCCESS;
}
