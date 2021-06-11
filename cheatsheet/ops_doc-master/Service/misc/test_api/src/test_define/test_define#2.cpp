#include <stdio.h>

//#define makechar(c) #@c
//
//int main(void) {
//
//    char a = makechar(b);
//    printf("%c.\n", a);
//
//    return 0;
//}

#define A(x) (#x[0])

int main(){
    //a定义成"a"字符串后，取出改指针第一个字符值
    printf("%d\n", A(a));
    printf("%d\n", "a"[0]);//97
    //"a"在静态空间存放，占用2个字符，'a','\0',所有取第二字符时为0
    printf("%d\n", "a"[1]);//0
    return 0;
}
