/**
 * File: strings.c
 * Author: ZhuXindi
 * Date: 2017-06-19
 */

#include <strings.h>
#include <string.h>
#include <ctype.h>

char *strtrim(char *s)
{
	char *ret = s;
	size_t n = strlen(s);

	while (n && isspace(s[n-1]))
		n--;
	while (isspace(*s)) {
		s++;
		n--;
	}

	memmove(ret, s, n);
	ret[n] = 0;
	return ret;
}

char *strtoupper(char *s)
{
	char *ret = s;

	while (*s) {
        	*s = toupper(*s);
		s++;
	}
	return ret;
}

char *strntoupper(char *s, size_t n)
{
	char *ret = s;

	while (*s && n--) {
        	*s = toupper(*s);
		s++;
	}
	return ret;
}

char *strtolower(char *s)
{
	char *ret = s;

	while (*s) {
        	*s = tolower(*s);
		s++;
	}
	return ret;
}

char *strntolower(char *s, size_t n)
{
	char *ret = s;

	while (*s && n--) {
        	*s = tolower(*s);
		s++;
	}
	return ret;
}

char *strcasechr(const char *s, int c)
{
	c = tolower(c);

	while (*s) {
        	if (tolower(*s) == c)
			return (char *)s;
		s++;
	}
	return NULL;
}

char *strnchr(const char *s, int c, size_t n)
{
	while (*s && n--) {
		if (*s == c)
			return (char *)s;
		s++;
	}
	return NULL;
}

char *strncasechr(const char *s, int c, size_t n)
{
	c = tolower(c);

	while (*s && n--) {
		if (tolower(*s) == c)
			return (char *)s;
		s++;
	}
	return NULL;
}

char *strnstr(const char *s1, const char *s2, size_t n)
{
	int c = *s2++;
	char *p;

	while (1) {
		p = strnchr(s1, c, n);
		if (!p)
			return NULL;

		n -= ++p - s1;
		s1 = p;
		if (!strncmp(s1, s2, n))
			break;
	}
	return (char *)--s1;
}

char *strstrn(const char *s1, const char *s2, size_t n)
{
	int c = *s2++;
	char *p;

	n--;
	while (1) {
		p = strchr(s1, c);
		if (!p)
			return NULL;

		s1 = ++p;
		if (!strncmp(s1, s2, n))
			break;
	}
	return (char *)--s1;
}

char *strncasestr(const char *s1, const char *s2, size_t n)
{
	int c = *s2++;
	char *p;

	while (1) {
		p = strncasechr(s1, c, n);
		if (!p)
			return NULL;

		n -= ++p - s1;
		s1 = p;
		if (!strncasecmp(s1, s2, n))
			break;
	}
	return (char *)--s1;
}

char *strcasestrn(const char *s1, const char *s2, size_t n)
{
	int c = *s2++;
	char *p;

	n--;
	while (1) {
		p = strcasechr(s1, c);
		if (!p)
			return NULL;

		s1 = ++p;
		if (!strncasecmp(s1, s2, n))
			break;
	}
	return (char *)--s1;
}
