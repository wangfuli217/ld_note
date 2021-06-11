/*
 * =====================================================================================
 *
 *       Filename:  assert_t.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04/18/2019 04:40:15 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
void test(int x) {
    assert(x > 0);
    printf("%d\n", x);
}
int main(int argc, char* argv[]) {
    test(-1);
    return EXIT_SUCCESS;
}
#if 0
gcc -E -DNDEBUG main.c
$ gcc -E main.c
void test(int x)
{
    ((x > 0) ? (void) (0) : __assert_fail ("x > 0", "main.c", 16, __PRETTY_FUNCTION__));
    printf("%d\n", x);
}
#endif
