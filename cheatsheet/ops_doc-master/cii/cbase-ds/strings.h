/**
 * File: strings.h
 * Author: ZhuXindi
 * Date: 2017-06-19
 */

#ifndef _STRINGS_H
#define _STRINGS_H

#include <stdlib.h>

char *strtrim(char *s);

char *strtoupper(char *s);
char *strntoupper(char *s, size_t n);
char *strtolower(char *s);
char *strntolower(char *s, size_t n);

char *strcasechr(const char *s, int c);
char *strnchr(const char *s, int c, size_t n);
char *strncasechr(const char *s, int c, size_t n);

char *strnstr(const char *s1, const char *s2, size_t n);
char *strstrn(const char *s1, const char *s2, size_t n);
char *strncasestr(const char *s1, const char *s2, size_t n);
char *strcasestrn(const char *s1, const char *s2, size_t n);

#endif /* _STRINGS_H */
