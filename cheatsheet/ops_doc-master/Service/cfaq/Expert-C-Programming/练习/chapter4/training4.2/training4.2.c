#include <stdio.h>
#include "print.c"
extern char p[];//����p����Ϊָ��ᱨ��
int main()
{
    printf("p = %c\n",p[3]);
    print();
    return 0;
}
