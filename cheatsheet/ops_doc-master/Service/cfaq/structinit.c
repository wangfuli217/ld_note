/*
 * =====================================================================================
 *
 *       Filename:  structinit.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:05:03 PM
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
int main(int argc, char* argv[])
{
    /* 直接定义结构类型和变量 */
    struct { int x; short y; } a = { 1, 2 }, a2 = {};
    printf("a.x = %d, a.y = %d\n", a.x, a.y);
    /* 函数内部也可以定义结构类型 */
    struct data { int x; short y; };
    struct data b = { .y = 3 };
    printf("b.x = %d, b.y = %d\n", b.x, b.y);
    /* 复合字面值 */
    struct data* c = &(struct data){ 1, 2 };
    printf("c.x = %d, c.y = %d\n", c->x, c->y);
    /* 也可以直接将结构体类型定义放在复合字面值中
     * */
    void* p = &(struct data2 { int x; short y; }){ 11, 22 };
    /* 相同内存布局的结构体可以直接转换 */
    struct data* d = (struct data*)p; 
    printf("d.x = %d, d.y = %d\n", d->x, d->y);
    return EXIT_SUCCESS;
}
