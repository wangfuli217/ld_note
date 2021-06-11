#include <stdio.h>
#include "print.c"
extern char p[];//若把p声明为指针会报错
int main()
{
    printf("p = %c\n",p[3]);
    print();
    return 0;
}
