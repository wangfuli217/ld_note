#include <stdio.h>
int main(void)
{
    unsigned short int a=10;
    int b=-5;
    if(b>a)
        printf("无符号保护规则\n");
    else 
        printf("值保护规则\n");

    printf("int %d-----unsigned short int %d",sizeof(int),sizeof(unsigned short int));
    return 0;
}
/*
a是unsigned short int型，但在和b进行比较的时候a会提升位为int型，与真实值10保持一致。
这里的int和unsigned short int 类型大小不一致，故编译器选择了值保护规则，事实上ANSI/ISO C标准也是采用了值保护规则的
*/