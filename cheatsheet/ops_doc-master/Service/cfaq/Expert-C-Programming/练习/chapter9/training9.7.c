//玩转数组/指针参数
#include <stdio.h>

char ga[] = "abcdefghijklm";

void my_array_func(char ca[10])
{
    printf(" addr of array param = %#x \n", &ca);
    printf(" addr (ca[0]) = %#x \n", &(ca[0]));
    printf(" addr (ca[1]) = %#x \n", &(ca[1]));
    printf(" ++ca = %#x \n\n", ++ca);
}

void my_pointer_func(char *pa)
{
    printf(" addr of ptr param = %#x \n", &pa);
    printf(" addr (pa[0]) = %#x \n", &(pa[0]));
    printf(" addr (pa[1]) = %#x \n", &(pa[1]));
    printf(" ++pa = %#x \n\n", ++pa);
}

int main()
{
    printf(" addr of global array = %#x \n", &ga);
    printf(" addr (ga[0]) = %#x \n", &(ga[0]));
    printf(" addr (ga[1]) = %#x \n\n", &(ga[1]));
    my_array_func(ga);
    my_pointer_func(ga);
    return 0;
}
