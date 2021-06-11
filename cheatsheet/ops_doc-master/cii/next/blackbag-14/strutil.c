#include <sys/types.h>

#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "strutil.h"
#include "util.h"

/*
 * Copy arg vector into a new buffer, concatenating arguments with spaces.  
 */
char *
copy_argv(char **argv)
{
        char **p;
        u_int len = 0;
        char *buf;
        char *src, *dst;

        p = argv;
        if (*p == 0)
                return 0;
        
        while (*p)
                len += strlen(*p++) + 1;
  
        buf = malloc(len);

        p = argv;
        dst = buf;
        while ((src = *p++) != NULL) {
                while ((*dst++ = *src++) != '\0')
                        ;
                dst[-1] = ' ';
        }
        dst[-1] = '\0';

	return(buf);
}

char **
parse_argv(char *str, int *argc)
{
	char **argv, **ap, *p, *q;
	static const char sep[] = " \t";

	argv = (char **)malloc(((strlen(str) + 1) / 2 + 1) * sizeof(char *));
	*argc = 0;

	for (ap = argv; (*ap = strsep(&str, sep)) != NULL; ) {

		/* Deal with quoted strings */
		if (**ap == '"' && (p = q = (*ap)+1)) {
			int found = 0;

			/* Replace null character (from strsep) with space. */
			if (str != NULL)
				*(str - 1) = ' ';

			while (*p && (p = strpbrk(p, "\"\\")) != NULL) {
				switch (*p) {
				case '\\':
					if (*(p + 1))
						strcpy(p, p + 1);
					p++;
					break;
				case '"':
					*p = '\0';
					*ap = q;
					str = p + 1;
					found = 1;
					break;
				default:
					break;
				}
			}
                 
			/* If no terminating quote, put back null character. */
			if (str != NULL && found != 1)
				*(str - 1) = '\0';
		}

		/* Advance pointer if this argument isn't an empty string. */
		if (**ap != '\0') {
			ap++;
			(*argc)++;
		}
	}
	return (argv);
}

/*
 * ' is a special character for most DB's, and a legal character
 * in the ifAlias field, we must escape it
 */
void
sanitize_string(char *src, char *dst, int len)
{
	char *p, *r, *oldr;
	char tdst[len*2];

	p = tdst;
	r = oldr = src;
	while (*oldr != NULL) {
		r = strchr(oldr, '\'');
		if (r != NULL) {
			memmove(p, oldr, r - oldr);
			p += r - oldr;
			*p++ = '\\';
			*p++ = '\'';
		} else {
			strlcpy(p, oldr, len);
			strlcpy(dst, tdst, len);
			while (dst[strlen(dst)-1] == '\\')
				dst[strlen(dst)-1] = '\0';
			return;
		}
		oldr = r + 1;
	}
	*p = '\0';
	strlcpy(dst, tdst, len);
	/* don't end in a slash */
	while (dst[strlen(dst)-1] == '\\')
		dst[strlen(dst)-1] = '\0';
}

char *
strnsep(char **strp, char *delim)
{
	char *p;
	
	if ((strp == 0) || (*strp == 0) || (delim == 0))
		return NULL;

	/* skip past delim at beginning of string */
	*strp += strspn(*strp, delim);

	/* if we skipped past everything, strp goes to NULL */
	if (**strp == '\0')
		*strp = 0;

	p = strsep(strp, delim);
	return (p);
}

unsigned long
strash(char *s) {
	unsigned long h = 5381;

	/* h = h * K + byte for K in [ 31, 33, 37 ], x<<5-x = x * 31 */
	for(h = 0; *s; h = ((h<<5)-h) + (unsigned char) *s++) ;

	return h;
}

const char *
strint(int i) {
	static char buf[100];

	snprintf(buf, 99, "%d", i);

	return(buf);
}
