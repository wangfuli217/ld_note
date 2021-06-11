#include <stdio.h>

int main(int argc, const char *argv[]){
    printf("%d\n", sizeof(int(*[5])(double)));
    printf("%d\n", sizeof(main));
    return 0;
}
/*
除了函数类型和不完全类型，其他类型都有大小，通过sizeof(类型名)编译器计算当前类型的大小
  基本类型，必定依赖处理环境进行计算
  指针，也依赖处理环境，但它的大小 和派生源的大小没有关系，它的 大小是固定 的。
  数组，通过派生源类型的大小乘以元素个数得到
  函数，大小无法计算
*/