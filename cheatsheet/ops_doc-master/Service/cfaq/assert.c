// assert(0) 是一个很好的方法，用于指明"不可能发生"的情况。
// assert(!"ptr==NULL -- can not hanppen") 特很好
// 断言 逻辑操作符|| 和 三目运算符 常用

// 仅在得到客观测量结果的支持时，才应该改变 NDEBUG 开关。
#include <stdio.h>
#include <stdlib.h>

// assert的定义使用了 e1||e2， 这是因为assert(e)必须被扩展为表达式，而不是语句。
// e2是一个逗号表达式，其结果是一个值，这是||运算符的要求，整个表达式最终转换为void
// 是应为C语言标准规定assert(e)没有返回值。

// 类似 e1||e2的表达式通常出现在条件判断中，如if语句，但它也可以作为单独的语句出现。
// 作为单独的语句，该表达式的效果等效于下述语句
// if(!(e1)) e2;
#undef assert
#ifdef NDEBUG
#define assert(e) ((void)0)
#else
extern void assert(int e);
#define assert(e) ((void)((e) || \
        (fprintf(stderr, "%s:%d Assertion Failed:%s\n", \
        __FILE__, (int)__LINE__, #e), abort(), 0)))
#endif

#define massert(e,msg) ((e) ? (void)0 : (\
    fprintf(stderr,"%s:%u - failed assertion '%s' : %s\n",__FILE__,__LINE__,#e,(msg)),\
    syslog(LOG_ERR,"%s:%u - failed assertion '%s' : %s",__FILE__,__LINE__,#e,(msg)),abort()))