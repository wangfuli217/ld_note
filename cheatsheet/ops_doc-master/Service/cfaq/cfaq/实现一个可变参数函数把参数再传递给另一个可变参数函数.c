通常来说做不到。理想情况下，你应该提供另一个版本的函数，这个函数接收va_list指针类型的参数：

void faterror(const char *fmt, ...) { 
    error(fmt, what goes here? ); 
    exit(EXIT_FAILURE); 
}

2. 通过va_list实现方法如下：
#include <stdio.h>
#include <stdarg.h>

void verror(const char *fmt, va_list argp)
{
	fprintf(stderr, "error: ");
	vfprintf(stderr, fmt, argp);
	fprintf(stderr, "\n");
}

void error(const char *fmt, ...)
{
	va_list argp;
	va_start(argp, fmt);
	verror(fmt, argp);
	va_end(argp);
}

error和verror之间的关系跟printf和vprintf之间的关系完全类似。实际上，任何时候你准备写
变参的时候，写出两个版本都是一个好的注意。
一个函数接受va_list参数，完成所有的工作
一个函数仅仅进行封装
这种技术的唯一限制是verror只能对参数进行一次扫描，没办法再次调用va_start.

#include <stdlib.h>
void faterror(const char *fmt, ...)
{
	va_list argp;
	va_start(argp, fmt);
	verror(fmt, argp);
	va_end(argp);
	exit(EXIT_FAILURE);
}