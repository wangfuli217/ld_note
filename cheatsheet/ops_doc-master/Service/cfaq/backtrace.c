#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <execinfo.h>

void func3()
{
    printf("start func3+++++\n");

    // 1.backtrace
    printf("backtrace output:\n");
    void *buf[128];
    int n = backtrace(buf, 128);
    if (n >= 128) {
        fprintf(stderr, "Warning: backtrace maybe truncated.\n");
    }
    printf("n = %d\n", n);
    int i = 0;
    for (i = 0; i < n; ++i) {
        printf("buf[%d] = %p\n", i, buf[i]);
    }

    // 2.backtrace_symbols
    printf("backtrace_symbols output:\n");
    char **p = backtrace_symbols(buf, n);
    if (p == NULL) {
        fprintf(stderr, "backtrace_symbols() failed, error.\n");
        exit(EXIT_FAILURE);
    }
    for (i = 0; i < n; ++i) {
        printf("str[%d] = %s\n", i, p[i]);
    }
    free(p);

    // 3.backtrace_symbols_fd
    printf("backtrace_symbols_fd output:\n");
    backtrace_symbols_fd(buf, n, STDERR_FILENO); // 写入标准错误输出
    printf("finish func3-----\n");
}


void func2()
{
    printf("start func2+++++\n");
    func3();
    printf("finish func2-----\n");
}


void func1()
{
    printf("start func1+++++\n");
    func2();
    printf("finish func1-----\n");
}

int main()
{
    func1();
    return 0;
}

/*
gcc -g -Wall -rdynamic backtrace.c -o test


*/