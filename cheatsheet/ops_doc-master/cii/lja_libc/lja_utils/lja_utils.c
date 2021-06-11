#include <error.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
 * from tcpdump
 *
 * must free return buf
 *
 * Copy arg vector into a new buffer, concatenating arguments with spaces.
 */
char *
lja_copy_argv(register char **argv)
{
	register char **p;
	register unsigned int len = 0;
	char *buf;
	char *src, *dst;

	p = argv;
	if (*p == 0)
		return 0;

	while (*p)
		len += strlen(*p++) + 1;

	buf = (char *)malloc(len);

	if (buf == NULL){
		fprintf(stderr,"Failed malloc %s:%d\n",__FILE__,__LINE__);
		exit(-1);
	}

	p = argv;
	dst = buf;
	while ((src = *p++) != NULL) {
		while ((*dst++ = *src++) != '\0')
			;
		dst[-1] = ' ';
	}
	dst[-1] = '\0';

	return buf;
}

