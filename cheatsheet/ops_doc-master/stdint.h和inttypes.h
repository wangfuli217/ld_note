C 语言提供了丰富的整数类型，但是这些类型在各个系统中有差异。因此 C99 为了消除这种差异，新增了 stdint.h 和 inttypes.h 头文件，用于定义跨平台整数类型（Portable Types）。
C 语言为现有的数据类型新定义了更多的别名，这些新定义的别名存放在 stdint.h 头文件中。例如 int32_t 表示 32 位的 int 类型。因此在 int 为 32 位的系统中 int32_t 是 int 的别名。在 int 为 16 位，long 为 32 位的系统中，int32_t 是 long 的别名。因此，使用 int32_t 声明变量，可以确保无论在什么系统中，都能保证使用的是 32 位来存储数据。
上面讨论的 int32_t 类型定义了变量精确的宽度（32 位），称为精确宽度整数类型。但是有的底层系统可能不支持这种用法，因此精确宽度整型是可选的类型。
C99 和 C11 定义了第二种非精确宽度的别名集合。
    最小宽度类型 - 保证类型至少有指定的位数。例如 int_least8_t 是系统中最少容纳 8 位的整数类型的别名，如果系统最小的整数是 16 位，那么 int_least8_t 就是 16 位整数。
    最快最小宽度类型 - C99 和 C11 定义了一组可使计算速度达到最快的类型别名。例如 int_fast8_t 是系统中计算速度最快的有符号 8 位整数的别名。
    最大可能整数类型 - C99 定义了 intmax_t 表示最大有符号整数类型，可存储任何有效的有符号整数值。uintmax_t 表示最大无符号整数类型。这些类型可能比 long long 和 unsigned long 类型更大。因为 C 语言编译器可能实现了 C 语言标准之外的类型。
C 语言还规定了打印跨平台整数类型需要的占位符。例如，inttypes.h 头文件中定义了 PRId32 字符串宏用于打印 32 位有符号值。

代码 altnames.c
/* altnames.c -- portable names for integer types */
  #include <stdio.h>
  #include <inttypes.h> // supports portable types
int main(void)
{
      int32_t me32;     // me32 a 32-bit signed variable
  
      me32 = 45933945;
      printf("First, assume int32_t is int: ");
      printf("me32 = %d\n", me32);
      printf("Next, let's not make any assumptions.\n");
      printf("Instead, use a \"macro\" from inttypes.h: ");
      printf("me32 = %" PRId32 "\n", me32);
  
      return 0;
  }   
程序最后一个 printf() 函数使用了 PRId32 占位符，PRId32 定义在 inttypes.h 头文件中，这个例子中它将会被 “d” 替换。这行代码相当于：
printf("me32 = %" "d" "\n", me32);
在 C 语言中，多个连续的双引号中的字符串可以拼接成一个完整的字符串，因此，这行代码相当于：
printf("me32 = %d\n", me32);
程序运行结果如下，程序中使用了用于显示引号的 \" 转义序列：

First, assume int32_t is int: me32 = 45933945
Next, let's not make any assumptions.
Instead, use a "macro" from inttypes.h: me32 = 45933945