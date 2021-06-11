void debug(const char *, ...);
void (*dbginfo(int, const char *))(const char *, ...);
#define DEBUG (*dbginfo(__LINE__, __FILE__))

void debug(const char *fmt, ...)
{
	va_list argp;
	fprintf(stderr, "DEBUG: \"%s\", line %d: ", dbgfile, dbgline);
	va_start(argp, fmt);
	vfprintf(stderr, fmt, argp);
	va_end(argp);
	fprintf(stderr, "\n");
}

void (*dbginfo(int line, const char *file))(const char *, ...)
{
	dbgfile = file;
	dbgline = line;
	return debug;
}

// DEBUG("i is %d", i);
// (*dbginfo(__LINE__, __FILE__))("i is %d", i);

