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
    //a�����"a"�ַ�����ȡ����ָ���һ���ַ�ֵ
    printf("%d\n", A(a));
    printf("%d\n", "a"[0]);//97
    //"a"�ھ�̬�ռ��ţ�ռ��2���ַ���'a','\0',����ȡ�ڶ��ַ�ʱΪ0
    printf("%d\n", "a"[1]);//0
    return 0;
}
