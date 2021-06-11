#include <stdio.h>

void hello(void)
{
    fprintf(stderr, "hello!\n");
}
 
void func(void)
{
    void        *buf[10];
    static int  i;
 
    for (i = 0; i < 100; i++) {   // ←越界！
        buf[i] = hello;
    }
}
 
int main(void)
{
    int buf[1000];
 
    func();
 
    return 0;
}