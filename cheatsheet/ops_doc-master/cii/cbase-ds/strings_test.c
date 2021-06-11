/**
 * File: strings_test.c
 * Author: ZhuXindi
 * Date: 2017-06-19
 */

#include <strings.h>
#include <string.h>
#include <stdio.h>

int main()
{
	char s[] = " Hello World! ";
	char *p;

	printf("original: %s\n", strtrim(s));

	printf("strtoupper(): %s\n", strtoupper(s));
	strcpy(s, "Hello World!");

	printf("strtolower(): %s\n", strtolower(s));
	strcpy(s, "Hello World!");

	printf("strntoupper(5): %s\n", strntoupper(s,5));
	strcpy(s, "Hello World!");

	printf("strntolower(5): %s\n", strntolower(s,5));
	strcpy(s, "Hello World!");

	p = strcasechr(s, 'o');
	printf("strcasechr('o'): %s\n", p);

	p = strnchr(s, 'o', 5);
	printf("strcasechr('o', 5): %s\n", p);

	p = strnchr(s, 'o', 3);
	printf("strcasechr('o', 3): %s\n", p);

	p = strncasechr(s, 'O', 5);
	printf("strcasechr('O', 5): %s\n", p);

	p = strncasechr(s, 'O', 3);
	printf("strcasechr('O', 3): %s\n", p);

	p = strnstr(s, "o", 5);
	printf("strnstr('o', 5): %s\n", p);

	p = strnstr(s, "o", 3);
	printf("strnstr('o', 3): %s\n", p);

	p = strncasestr(s, "O", 5);
	printf("strncasestr(\"O\", 5): %s\n", p);

	p = strncasestr(s, "O", 3);
	printf("strncasestr(\"O\", 3): %s\n", p);

	p = strstrn(s, "ok", 1);
	printf("strstrn(\"ok\", 1): %s\n", p);

	p = strcasestrn(s, "OK", 1);
	printf("strcasestrn(\"OK\", 1): %s\n", p);

	return 0;
}
