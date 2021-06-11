// 如果需要通过函数返回值以外的方式返回值，将“指向 T 的指针”（如果想要返回的值的类型为 T）作为参数传递给函数。
#include <stdio.h>

void func(int *a, double *b)
{
    *a = 5;
    *b = 3.5;
}

int main(void)
 {
     int    a;
     double b;

     func(&a, &b);
     printf("a..%d b..%f\n", a, b);

     return 0;
 }