#include <stdio.h>
int main(void)
{
    unsigned  char a=0x80;
    unsigned long b=0;
    b|=a<<8;
     printf("0x%lx\n",b);

    printf("unsigned  int %d-----unsigned long %d",sizeof(unsigned  int),sizeof(unsigned long));
    return 0;
}
/*
如果是在无符号保护的规则下（a被提升为unsigned int，unsigned int 和unsigned long 一样 大）则会打印出0x8000。
但在值保护规则下，a会被提升为int 型，然后a<<8的结果也会被提升为long型，如果long型大于int型，则a<<8的结果会带符号进行提升，
则打印结果为0xffff8000，但是如果long型和int型大小一致则值保护规则和无符号保护规则相一致。因为此编译器的int 和long大小一致，故打印0x8000
*/