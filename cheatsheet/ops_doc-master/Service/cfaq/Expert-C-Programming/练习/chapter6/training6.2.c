#include <stdio.h>
int j;
int d = 1;
void a()
{}
int main()
{
    int i;
    printf("The stack top is near %p\n", &i);//堆栈段
    printf("The BSS top is near %p\n", &j);//BSS段
    printf("The BSS top is near %p\n",&d);//数据段
    printf("The text top is near %p\n",&a); //文本段
    return 0;
}
