/*
 * =====================================================================================
 *
 *       Filename:  strconcat.c
 *
 *    Description:  conncat.c
 *
 *        Version:  1.0
 *        Created:  04/18/2019 10:56:03 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv){
char* s1 = "Hello"
        " World!";
char* s2 = "Hello \
            World!";
printf("s1=%s \n s2=%s", s1, s2);
return 0;

}
