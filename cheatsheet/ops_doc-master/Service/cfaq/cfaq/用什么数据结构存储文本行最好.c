// 静态字符串 
char *a[4] = {"this", "is", "a", "test"};
char **p = a;

// 动态字符串  方法1. malloc strcpy
#include <stdlib.h>
char **p = malloc(4 * sizeof(char *));
if(p != NULL) {
	p[0] = malloc(5);
	p[1] = malloc(3);
	p[2] = malloc(2);
	p[3] = malloc(5);

	if(p[0] && p[1] && p[2] && p[3]) {
		strcpy(p[0], "this");
		strcpy(p[1], "is");
		strcpy(p[2], "a");
		strcpy(p[3], "test");
	}
}

// 动态字符串 方法2. strdup
#include <stdio.h>
#include <stdlib.h>
extern char *agetline(FILE *);
FILE *ifp;

/* assume ifp is open on input file */

char **lines = NULL;
size_t nalloc = 0;
size_t nlines = 0;
char *p;

while((p = agetline(ifp)) != NULL) {
	if(nlines >= nalloc) {
		nalloc += 50;
#ifdef SAFEREALLOC
		lines = realloc(lines, nalloc * sizeof(char *));
#else
		if(lines == NULL)		/* in case pre-ANSI realloc */
			lines = malloc(nalloc * sizeof(char *));
		else	lines = realloc(lines, nalloc * sizeof(char *));
#endif
		if(lines == NULL) {
			fprintf(stderr, "out of memory");
			exit(1);
		}
	}

	lines[nlines++] = p;
}
