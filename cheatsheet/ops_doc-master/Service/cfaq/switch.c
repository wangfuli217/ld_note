/*
 * =====================================================================================
 *
 *       Filename:  switch.c
 *       GCC C99 switch 范围扩展。
 *        Version:  1.0
 *        Created:  04/18/2019 02:00:47 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <stdio.h>

int main(int argc, char *argv[]){
    int x = 1;
    switch (x)
    {
    case 0 ... 9: printf("0..9\n"); break;
    case 10 ... 99: printf("10..99\n"); break;
    default: printf("default\n"); break;
    }
    char c = 'C';
    switch (c)
    {
    case 'a' ... 'z': printf("a..z\n"); break;
    case 'A' ... 'Z': printf("A..Z\n"); break;
    case '0' ... '9': printf("0..9\n"); break;
    default: printf("default\n"); break;
    }
    return 0;
}
