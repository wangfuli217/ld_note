/*
 * =====================================================================================
 *
 *       Filename:  typecast.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 11:05:51 AM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */

int main(int argc, char *argv[]){
    long a = -1L;
    unsigned int b = 100;
    printf("%ld\n", a > b ? a : b);
    return 0;
}
