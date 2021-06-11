void f(int n)  // 函数参数 'n' 的作用域开始
{         // 函数体开始
   ++n;   // 'n' 在作用域中并指代函数参数
// int n = 2; // 错误：不能在同一作用域重声明标识符
   for(int n = 0; n<10; ++n) { // 循环局域的 'n' 的作用域开始
       printf("%d\n", n); // 打印 0 1 2 3 4 5 6 7 8 9
   } // 循环局域的 'n' 的作用域结束
     // 函数参数 'n' 回到作用域
   printf("%d\n", n); // 打印参数的值
} // 函数参数 'n' 的作用域结束
int a = n; // 错误：名称 'n' 不在作用域中



enum {a, b};
int different(void)
{
    if (sizeof(enum {b, a}) != sizeof(int))
        return a; // a == 1
    return b; // C89 中 b == 0 ， C99 中 b == 1
}

