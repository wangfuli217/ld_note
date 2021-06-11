#include <stdio.h>

int main(void)
{
    int     hoge = 5;   // 类型 变量名;
    int     piyo = 10;
    int     *hoge_p;    // int* hoge_p -> 类型 变量名;

    /*输出每个变量的地址*/
     printf("&hoge..%p\n", &hoge);
     printf("&piyo..%p\n", &piyo);
     printf("&hoge_p..%p\n", &hoge_p);

     /*将hoge 的地址赋予hoge_p*/
     hoge_p = &hoge;
     printf("hoge_p..%p\n", hoge_p);

     /*通过hoge_p 输出hoge 的内容*/
     printf("*hoge_p..%d\n", *hoge_p);

     /*通过hoge_p 修改hoge 的内容*/
     *hoge_p = 10;
     printf("hoge..%d\n", hoge);

     // 通过以下的代码，可以证明字符串常量本质还是数组：
     printf("size..%d\n", sizeof("abcdefghijklmnopqrstuvwxyz"));
     return 0;
}

/*
1. 先有"指针类型"。然后有了"指针类型的变量"和"指针类型的值"。
使用 int 类型表示整数。因为 int 是"类型"，所以存在用于保存 int 型的变量，当然也存在 int 型的值。
指针类型同样如此，既存在指针类型的变量，也存在指针类型的值。
指针类型的值实际是指内存的地址。

对变量使用&运算符，可以取得该变量的地址。这个地址称为指向该变量的指针。
指针变量 hoge_p 保存了指向其他变量的地址的情况下，可以说"hoge_p 指向 hoge"。
对指针变量运用*运算符，就等同于它指向的变量。如果 hoge_p 指向 hoge，*hoge_p 就等同于 hoge。
*/