/**
va_list arg_ptr：定义一个指向个数可变的参数列表指针；
va_start(arg_ptr, argN)：使参数列表指针arg_ptr指向函数参数列表中的第一个可选参数， 
    说明：argN是位于第一个可选参数之前的固定参数，（或者说，最后一个固定参数；…之前的一个参数），
    函数参数列表中参数在内存中的顺序与函数声明时的顺序是一致的。如果有一va函数的声明是
    void va_test(char a, char b, char c, …)，则它的固定参数依次是a,b,c，最后一个固定参数argN为c，
    因此就是va_start(arg_ptr, c)。
va_arg(arg_ptr, type)：返回参数列表中指针arg_ptr所指的参数，返回类型为type，并使指针arg_ptr指向参数列表中下一个参数。
va_copy(dest, src)：dest，src的类型都是va_list，va_copy()用于复制参数列表指针，将dest初始化为src。
va_end(arg_ptr)：清空参数列表，并置参数指针arg_ptr无效。 说明：指针arg_ptr被置无效后，可以通过调用va_start()、
                 va_copy()恢复arg_ptr。每次调用va_start() / va_copy()后，必须得有相应的va_end()与之匹配。
                 参数指针可以在参数列表中随意地来回移动，但必须在va_start() … va_end()之内。
*/

/**
 * va_copy
 * _____________________________________________________________________________
 *   Defined in header <stdarg.h>
 * _____________________________________________________________________________
 *  void va_copy( va_list dest, va_list src );  (since C99)
 * _____________________________________________________________________________
 * The va_copy macro copies <src> to <dest>.
 * {va_end} should be called on <dest> before the function returns or any 
 * subsequent re-initialization of <dest> (via calls to {va_start} or 
 * {va_copy}).
 *
 * Parameters
 *  dest - an instance of the va_list type to initialize
 *   src - the source va_list that will be used to initialize dest
 *
 * Compilation
 *  gcc -o va_copy va_copy.c
 * Created
 *  2015-08-13
 */


#include <stdio.h>
#include <stdarg.h>
#include <math.h>

double sample_stddev(int count, ...)
{
    /* Compute the mean with args1. */
    double sum = 0;
    va_list args1;
    va_start(args1, count);
    va_list args2;
    va_copy(args2, args1); /* copy va_list object */
    for (int i = 0; i < count; ++i) {
        double num = va_arg(args1, double);
        sum += num;
    }
    va_end(args1);
    double mean = sum / count;

    /* Compute standard deviation with arg2 and mean */
    double sum_sq_diff = 0;
    for (int i = 0; i < count; ++i) {
        double num = va_arg(args2, double);
        sum_sq_diff += (num-mean)*(num-mean);
    }
    va_end(args2);
    return sqrt(sum_sq_diff / count);
}

int main(void)
{
    printf("%f\n", sample_stddev(4, 25.0, 27.3, 26.9, 25.7));
}

