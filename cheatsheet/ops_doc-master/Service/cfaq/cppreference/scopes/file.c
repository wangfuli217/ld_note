int i; // i 的作用域开始
static int g(int a) { return a; } // g 的作用域开始（注意 "a" 拥有块作用域）
int main(void)
{
    i = g(2); // i 和 g 在作用域中
}

// 文件作用域的标识符默认拥有外部链接和静态存储期。