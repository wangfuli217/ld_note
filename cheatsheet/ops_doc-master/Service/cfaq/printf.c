#include <stdio.h>
#include <stdarg.h>

void error(const char *fmt, ...)
{
	va_list argp;
	fprintf(stderr, "error: ");
	va_start(argp, fmt);
	vfprintf(stderr, fmt, argp);
	va_end(argp);
	fprintf(stderr, "\n");
}

//--------------------------------------------------------------------------------
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

Now you can write faterror, and have it call verror, too:

#include <stdlib.h>

void faterror(const char *fmt, ...)
{
	va_list argp;
	va_start(argp, fmt);
	verror(fmt, argp);
	va_end(argp);