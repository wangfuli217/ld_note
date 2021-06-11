#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 函数返回
// 将malloc得到的内存首地址通过函数的返回值返回到主函数。
char* test(void)
{
    char *p;
    p = (char*)malloc(10 * sizeof(char));
    strcpy(p, "123456789" );
    return p;
}
int main(void)
{
    char *str = NULL ;
    str = test();
    printf("%s\n", str);
    free(str);
    return 0;
}

#if 0
// 二级指针
// 将malloc得到的内存首地址通过二级指针返回到主函数。

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void test(char **p)
{
    *p = (char*)malloc(10 * sizeof(char));
    strcpy(*p, "123456789" );   
}
void main()
{
    char *str = NULL ;
    test(&str);
    printf("%s\n", str);
    free(str);
}
#endif

#if 0
// 错误二：二级指针未指向存在的一级指针

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void test(char **p)
{
    *p = (char*)malloc(10 * sizeof(char));
    strcpy(*p, "123456789" );   
}
void main()
{
    char **str = NULL ; //原代码：char *str = NULL;
    test(str);          //       test(&str);
    printf("%s\n", str);
    free(str);
}
#endif