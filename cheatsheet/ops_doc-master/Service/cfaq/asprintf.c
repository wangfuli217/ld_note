/* based on <2001Sep19.2243.scs.0019@aeroroot.scs.ndip.eskimo.net> */

#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>

int
saprintf(char **retp, const char *fmt, ...)
{
	va_list argp;
	int len;
	char *buf;

	va_start(argp, fmt);
	len = vsnprintf(NULL, 0, fmt, argp);
	va_end(argp);

	buf = malloc(len + 1);
	if(buf == NULL)
		{
		*retp = NULL;
		return -1;
		}

	va_start(argp, fmt);
	vsnprintf(buf, len+1, fmt, argp);
	va_end(argp);

	*retp = buf;
	return len;
}
