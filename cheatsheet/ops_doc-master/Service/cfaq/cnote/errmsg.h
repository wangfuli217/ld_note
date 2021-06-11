#ifndef ERRMSG_H_INCLUDED
#define ERRMSG_H_INCLUDED
#include <stdarg.h>
#include <stdnoreturn.h>    // C11
void verrmsg(int errnum, const char *fmt, va_list ap);
noreturn void errmsg(int exitcode, int errnum, const char *fmt, ...);
void warnmsg(int errnum, const char *fmt, ...);
#endif