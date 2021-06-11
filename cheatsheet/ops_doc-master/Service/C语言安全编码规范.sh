https://github.com/LiPengfei19820619/SEI-CERT-C/blob/master/C%20%E8%AF%AD%E8%A8%80%E5%AE%89%E5%85%A8%E7%BC%96%E7%A0%81%E8%A7%84%E8%8C%83%EF%BC%882016%EF%BC%89.md
https://github.com/LiPengfei19820619/SEI-CERT-C/blob/master/ENV_11.md


C(PRE30-C 不要通过连接符创建通用字符名){
C标准支持可用于标识符、字符常量和文本字符串的通用字符名，用以表示基本字符集中未能覆盖的字符。
通用字符名\Unnnnnnnn指定了其8位短标识符（由ISO/IEC 10646规定）是nnnnnnnn的字符,
通用字符名\unnnn指定了其4位短标识符为nnnn（*其8位短标识符为字符0000nnnn）

如果匹配通用字符串名称的字符序列由符号连接生成，将产生未定义行为。

1. BAD：它通过标记级联生成通用字符名
#define assign(uc1, uc2, val) uc1##uc2 = val
void func(void) {
    int \u0401;
    /* ... */
    assign(\u04, 01, 4);
    /* ... */
}
2. GOOD：
此合规解决方案使用通用了字符名，但不通过连接符创建：
#define assign(ucn, val) ucn = val
void func(void) {
    int \\u0401;
    /* ... */   assign(\\u0401, 4);
    /* ... */
}
3. moosefs(cfg.c)
#define _CONFIG_MAKE_PROTOTYPE(fname,type) type cfg_get##fname(const char *name,type def)
  moosefs(buckets.h)
#define CREATE_BUCKET_ALLOCATOR(allocator_name,element_type,bucket_size)
}
C(PRE31-C 避免不安全宏的参数出现副作用){
  一个不安全的函数宏会在展开时多次使用或根本不使用某个参数。绝对不要调用包含赋值、增量、减量、volatile访问、
输入/输出等具有副作用（包括含有副作用的函数调用）参数的不安全宏。
  若文档中涉及不安全宏的时候，应当对使用含有副作用的参数调用进行警告，但是责任根源在于程序员使用了某个不安全宏。
由于在使用中会伴随风险，应避免定义不安全的函数宏。
不安全宏的问题之一是其宏参数含有副作用，正如下面这段不合规代码示例：

1. BAD
#define ABS(x) (((x) < 0) ? -(x) : (x))
void func(int n) {
    /* Validate that n is within the desired range */
    int m = ABS(++n);
    /* ... */
}
上面的ABS()宏调用展开后如下：
m = (((++n) < 0)? -(++n):(++n));
生成的代码是明确的，但会导致n递增两次而不是一次。

2. GOOD
在这个合规解决方案中，增量操作++n在宏调用之前得到执行。
#define ABS(x) (((x) < 0) ? -(x) : (x))  /* UNSAFE */
void func(int n) {
    /* Validate that n is within the desired range */
    ++n;
    int m = ABS(n);
    /* ... */
}

3. GOOD
iabs()函数将截断比int类型更宽的参数，这些参数的值范围不在int类型的范围内。
#include <complex.h>
#include <math.h>
static  inline int iabs(int x){
    return (((x) < 0)?-(x):(x));
}
void  func(int n)
{
    /* Validate that n is within the desired range */
    int m = iabs(++n);
    /* ... */
}

4. GOOD
合规解决方案（GCC）
GCC的__typeof扩展使得在一个宏中声明和并进行赋值操作变为可能，操作数的值赋给一个同类型的临时变量，
并让临时变量执行计算，从而保证了操作数将只被使用一次。另一个GCC的扩展，称为[语句表达式]，
它使用块语句的方式，代码如下：
#define ABS(x) __extension__ ({ __typeof (x) tmp = x; \
                    tmp < 0 ? -tmp : tmp; })

}