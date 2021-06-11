#include <stdio.h>

// 这样并不是把未知类型的指针p强制转换为int，然后进行sizeof操作，而是编译器
// 把星号(*)当作乘号来处理了，但由于左右操作数类型不匹配而报错。
int main(void){
    int *q;
    int p;
    p = sizeof(int) * q;
    printf("%d\n",p);
    return 0;
}

#if 0
// 这样写便为把未知类型的指针p强制转换为int，然后进行sizeof操作。
int main(void){
    int *q;
    int p = (int) * q;
    p = sizeof p;
    printf("%d\n",p);
    return 0;
}
#endif

#if 0
// 对指针p的地址进行强制转换，指针p强制转换为int，然后乘上sizeof(int)。
int main(void){
    int *q;
    int p;
    p = sizeof(int) * (int)q;
    printf("%d\n",p);
    return 0;
}

#endif

#if 0
// q为int型变量，p = int的长度乘以q,结果输出： 8
int main(void){
    int q = 2;
    int p;
    p = sizeof(int) * q;
    printf("%d\n",p);
    return 0;
}
#endif