#include <stdio.h>
#include <stdarg.h>

void debug(const char *, ...);
void dbginfo(int, const char *);
#define DEBUG dbginfo(__LINE__, __FILE__), debug

static const char *dbgfile;
static int dbgline;

void dbginfo(int line, const char *file)
{
	dbgfile = file;
	dbgline = line;
}

void debug(const char *fmt, ...)
{
	va_list argp;
	fprintf(stderr, "DEBUG: \"%s\", line %d: ", dbgfile, dbgline);
	va_start(argp, fmt);
	vfprintf(stderr, fmt, argp);
	va_end(argp);
	fprintf(stderr, "\n");
}

// DEBUG("i is %d", i);
// dbginfo(__LINE__, __FILE__), debug("i is %d", i);