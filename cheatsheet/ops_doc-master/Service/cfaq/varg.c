#include <stdlib.h>		/* for malloc, NULL, size_t */
#include <stdarg.h>		/* for va_ stuff */
#include <string.h>		/* for strcat et al. */

char *vstrcat(const char *first, ...)
{
	size_t len;
	char *retbuf;
	va_list argp;
	char *p;

	if(first == NULL)
		return NULL;

	len = strlen(first);

	va_start(argp, first);

	while((p = va_arg(argp, char *)) != NULL)
		len += strlen(p);

	va_end(argp);

	retbuf = malloc(len + 1);	/* +1 for trailing \0 */

	if(retbuf == NULL)
		return NULL;		/* error */

	(void)strcpy(retbuf, first);

	va_start(argp, first);		/* restart; 2nd scan */

	while((p = va_arg(argp, char *)) != NULL)
		(void)strcat(retbuf, p);

	va_end(argp);

	return retbuf;
}
char *str = vstrcat("Hello, ", "world!", (char *)NULL);


#include <stdio.h>
#include <stdarg.h>
#ifdef MAIN

void miniprintf(const char *, ...);

main()
{
	miniprintf("Hello, world!\n");
	miniprintf("%c %d %s\n", '1', 2, "three");
	miniprintf("%o %d %x\n", 10, 10, 10);
	miniprintf("%u\n", 0xffff);
	return 0;
}

#endif

extern char *baseconv(unsigned int, int);

void
miniprintf(const char *fmt, ...)
{
	const char *p;
	int i;
	unsigned u;
	char *s;
	va_list argp;

	va_start(argp, fmt);

	for(p = fmt; *p != '\0'; p++) {
		if(*p != '%') {
			putchar(*p);
			continue;
		}

		switch(*++p) {
		case 'c':
			i = va_arg(argp, int);
			/* *not* va_arg(argp, char); see Q 15.10 */
			putchar(i);
			break;

		case 'd':
			i = va_arg(argp, int);
			if(i < 0) {
				/* XXX won't handle INT_MIN */
				i = -i;
				putchar('-');
			}
			fputs(baseconv(i, 10), stdout);
			break;

		case 'o':
			u = va_arg(argp, unsigned int);
			fputs(baseconv(u, 8), stdout);
			break;

		case 's':
			s = va_arg(argp, char *);
			fputs(s, stdout);
			break;

		case 'u':
			u = va_arg(argp, unsigned int);
			fputs(baseconv(u, 10), stdout);
			break;

		case 'x':
			u = va_arg(argp, unsigned int);
			fputs(baseconv(u, 16), stdout);
			break;

		case '%':
			putchar('%');
			break;
		}
	}

	va_end(argp);
}


