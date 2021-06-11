#include <stdio.h>

int main(void)
{
    int hoge;
    int *hoge_p;

    /*将指向hoge 的指针赋予hoge_p */
    hoge_p = &hoge;
     /*输出hoge_p 的值*/
     printf("hoge_p..%p\n", hoge_p);
     /*给hoge_p 加1*/
     hoge_p++;
     /*输出hoge_p 的值*/
     printf("hoge_p..%p\n", hoge_p);
     /*输出hoge_p 加3 后的值*/
     printf("hoge_p..%p\n", hoge_p + 3);

     return 0;
}