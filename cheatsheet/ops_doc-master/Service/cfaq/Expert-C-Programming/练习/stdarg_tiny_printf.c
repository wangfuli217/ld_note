#include <stdio.h>
#include <stdarg.h>
#include <assert.h>

void tiny_printf(char *format, ...) {
    int i;
    va_list ap;

    va_start(ap, format);
    for (i = 0; format[i] != '\0'; i++) {
        switch (format[i]) {
            case 's':
                printf("%s ", va_arg(ap, char*));
                break;
            case 'd':
                printf("%d ", va_arg(ap, int));
                break;
            default:
                assert(0);
        }
    }
    va_end(ap);
}

int main(void){
    tiny_printf("sdd", "result..", 3, 5);
    return 0;
}
/*
头文件stdarg.h提供了一组方便使用可变长参数的宏
va_list一般是这样定义typedef char *va_list;
va_start(ap, format)意味着 使指针ap指向参数format的下一个位置
宏va_arg()指定ap和参数类型，就可以顺序的取出可变长部分的参数
va_end(ap);是一个空定义的宏，只因标准里指出了对于va_start()的函数需要写va_end()
*/

/*
                        ┌──────────┐
                        │          │  使用中的栈
                   ┌─   ├──────────┤
                   │    │    *     │  str
                   │    ├──────────┤
                   │    │   100    │
                   │    ├──────────┤
                   │    │    *     │  指向"%d, %s\n"
printf() reference area ├──────────┤
                   │    │          │  返回信息
                   │    ├──────────┤
                   │    │          │  返回信息
                   │    ├──────────┤
                   │    │          │  printf()自己的局部变量
                   └─   ├──────────┤
                        │    │     │
                             V
无论堆积多少参数，总能找到第一个参数地址（它一定存在于距离固定的场所），随着对
第一个参数的占位符的解析，就可以知道后面还有几个参数.
*/
