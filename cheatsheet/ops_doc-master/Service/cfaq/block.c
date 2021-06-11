/*
 * =====================================================================================
 *
 *       Filename:  block.c
    语句块代表了一个作用域，在语句块内声明的自动变量超出范围后立即被释放。除了用 "{ ... }"
表示一个常规语句块外，还可以直接用于复杂的赋值操作，这在宏中经常使用。
最后一个表达式被当做语句块的返回值。相对应的宏版本如下。

在宏里使用变量通常会添加下划线前缀，以避免展开后跟上层语句块的同名变量冲突。
 *        Version:  1.0
 *        Created:  04/18/2019 01:32:41 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dr. wangfl(victor) (mn), wangfl217@126.com
 *        Company:  xianleidi.com
 *
 * =====================================================================================
 */
#include <stdio.h>

#define test() ({  \
                char _a = 'a'; \
                _a++;          \
                _a; })

int main(int argc, char *argv){
    int i = ({ char a = 'a'; a++; a; });
    printf("%d\n", i);
    i = test();
    printf("%d\n", i);
    return 0;
}
