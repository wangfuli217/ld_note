#include <stdio.h>
int main(void){
    int hoge = 5;
    int piyo = 10;
    int *hoge_p;

    printf("&hoge..%p\n", &hoge);
    printf("&piyo..%p\n", &piyo);
    printf("&hoge_p..%p\n", &hoge_p);

    hoge_p = &hoge;
    printf("hoge_p..%p\n", hoge_p);

    return 0;
}

/*
           ┌──────────┐
           │    5     │  hoge
0x76cd5a78 ├──────────┤
           │    10    │  piyo
0x76cd5a74 ├──────────┤
           │0x76cd5a78│  hoge_p
0x76cd5a70 └──────────┘

*/

/*
    对于大部分运行环境来说，当程序运行时，不管是指向int的指针，还是指向double的指针，
都保持相同的表现形式(偶尔在一些运行环境中，指向char指针和指向int的指针有不一样的内部表示和位数)
*/
#if 0
#include <stdio.h>
int main(void){
    int hoge = 5;
    void *hoge_p;

    hoge_p = &hoge;
    /* printf("%d\n", *hoge_p);*/
    /* warning: dereferencing 'void *' pointer invalid use of void expression*/
    printf("%d\n", *(int*)hoge_p);

    return 0;
}
#endif

#if 0
#include <stdio.h>
int main(void){
    int *int_p;
    double double_variable = 5;

    int_p = &double_variable;
    /* warning: assignment from incompatible pointer type*/

    return 0;
}
#endif