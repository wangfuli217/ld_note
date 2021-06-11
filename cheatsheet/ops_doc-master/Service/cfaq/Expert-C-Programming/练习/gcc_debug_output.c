#include <stdio.h>
#include <stdarg.h>

#define DEBUG

#ifdef DEBUG
#define DEBUG_WRITE(arg) debug_write arg
#else
#define DEBUG_WRITE(arg)
#endif

#define SNAP_INT(arg) fprintf(stderr, #arg "..%d\n", arg)

void debug_write(char *format, ...){
    va_list ap;
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
}

int main(void){
    DEBUG_WRITE(("\n%s..%d\n", "debug_write", 10));
    int hoge = 4;
    SNAP_INT(hoge);
    return 0;
}

/*
使用DEBUG_WRITE应加 两重括号，使用gcc时
gcc -DDEBUG ...将会加上DEBUG的宏定义
vfprintf(stderr, format, ap);输出到stderr不会有缓冲
#define SNAP_INT(arg) fprintf(stderr, #arg "..%d\n", arg)，#arg将输出原文，
其后只有空格，将合并两个字符串.
*/