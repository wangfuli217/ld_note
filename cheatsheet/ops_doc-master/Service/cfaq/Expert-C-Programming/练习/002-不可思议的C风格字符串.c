#include<stdio.h>
#include<stdlib.h>
#include<string.h>


void mystery(){//改编自《C和指针》中文版 P270
    for(int i=1; i<10; i++)
        printf("%s\n", "**********" + 10 - i);
}

void decimal_to_hex(unsigned int value){
    if(value/16 != 0)
        decimal_to_hex(value/16);
    putchar("0123456789ABCDEF"[value % 16]);
}


int main(){
    char *str1 = "hello";
    const char *str2 = "hello";
    const char * const _str_ = "hello";
    char str_arr[] = "hello";

    printf("Address of    str1 = %p.\n"
           "Address of    str2 = %p.\n"
           "Address of \"hello\" = %p.\n"
           "Address of str_arr = %p.\n\n",
           str1, str2, "hello", str_arr);

    printf("_str_   = %s\n", _str_);
    printf("str_arr = %s\n", str_arr);
    printf("%s  ##print `hello` directly.\n\n", "hello");

    printf("print the Second char of `hello`:\n");
    printf("  *(str1+1)    = %c\n", *(str1+1));
    printf("  str_arr[1]   = %c\n", str_arr[1]);
    printf("  \"hello\"[1]   = %c\n", "hello"[1]);
    printf(" *(\"hello\"+1)  = %c\n", *("hello"+1));
    ///错误的输出方式：
    //printf("str1=%s\n", *str1);//试图访问`h`转换成十六进制的位置0x00000068报错, 发生访问冲突(无权访问)


    //尝试修改字符串
    //str1[0] = 'y'; str2[0] = 'y'; //ERROR: str1指向的是字符串常量, str2是只读(const)的, 均无法修改！
    str_arr[0] = 'y';


    str1 = "world";
    str2 = "world";
    //_str_ = "world";      //error: assignment of read-only variable '_str_'
    //str_arr = "world";    //error: assignment to expression with array type

    printf("\nsizeof and strlen():\n");
    printf("sizeof(str_arr) = %lu\n", sizeof(str_arr));
    printf("strlen(\"hello\") = %lu\n\n", strlen("hello"));

    ///调用上面定义的两个函数:
    printf("Output of function mystery:\n");
    mystery();
    printf("\nOutput of decimal_to_hex(65535): ");
    decimal_to_hex(65535);


    /*
    Output/输出：
        Address of    str1 = 0040b130.
        Address of    str2 = 0040b130.
        Address of "hello" = 0040b130.
        Address of str_arr = 0061ff2a.
        _str_   = hello
        str_arr = hello
        hello  ##print `hello` directly.
        print the Second char of `hello`:
          *(str1+1)    = e
          str_arr[1]   = e
          "hello"[1]   = e
         *("hello"+1)  = e
        sizeof and strlen():
        sizeof(str_arr) = 6
        strlen("hello") = 5
        Output of function mystery:
        *
        **
        ***
        ****
        *****
        ******
        *******
        ********
        *********
        Output of decimal_to_hex(65535): FFFF
    Explanation/解释：
        (1) C风格字符串：在内存中连续存储的子串字符, 以0('\0'或者说NUL)结尾
            以内存的首地址来表示该字符串, 不严谨的说, 字符串都是`char *`类型
        (2) 打印字符串时, 使用`%s`格式控制符, 并且对应的是字符串的首字符【地址】！
            直到遇到'\0'结束。
        (3) 字符串常量详解
            字符串常量出现在表达式中时, 它的值是一个【指针常量】 ==> char* const ptr;
                 数组名用于表达式中时, 它的值也是  【指针常量】
            因此, 字符串常量可以进行下标引用、间接访问、sizeof以及指针运算！
           【注】 只要代码中出现了字符串常量, 编译器把这些指定字符的一份拷贝存储在内存中,
                  并存储一个指向第1个字符的指针。
                 【重要】重复出现的相同字符串常量不会多次拷贝！！
                         因此str1和str2指向同一块地址。
        (4) mystery和decimal_to_hex两个函数都使用了字符串常量在表达式中(作为指针)的运算
        (5) 有两种方式定义字符串变量：指针形式的str1 和 字符数组形式的str_arr
            1)指针形式
                  如果该字符指针变量未声明为const, 可以指向别的字符(串)地址; 当然也可以指向字符数组：str1 = str_arr。
                  不可以通过指针修改字符串的内容，即只读的！
                  char *str1 = "hello"; 等价于 const char *str2="hello";
                 【注】两者不完全等价：str1[0] = 'y'; 可以通过编译--运行时试图修改只读的字符串常量
                                     str2[0] = 'y'; 无法通过编译--const关键字起到的作用
                       因此const char *str2="hello";的方式更好一些！
                 【注】这种形式定义字符串, 只是把指向该
                      `字符串常量的第1个字符的指针` 赋值给新定义的指针变量
            2)数组形式
                  申请一块连续的空间, 将字符串常量拷贝到这块内存中！
                  数组名是一个指针常量, 不可以再指向别的地址。数组是可以修改的！
                  因此, 字符数组只有在定义时才能将整个字符串一次性地赋值给它！！！
                  char str[6]; str = "hello";  ===>是错的！str不可以指向别的地址。
        (6) _str_即不可以指向别的字符地址, 也不可通过_str_修改所指向的字符串
    */

    return 0;
}