#ifndef STR_INCLUDED
#define STR_INCLUDED

#include <stdarg.h>
#include <stdint.h>

#include "token.h"

#define Str_acatv(s, ...) Str_acatvx(s, __VA_ARGS__, NULL)

extern char*    Str_asub    (const char *s, size_t i, size_t j);
extern char*    Str_adup    (const char *s);
extern char*    Str_acat    (const char *s1, const char *s2);
extern char*    Str_acatvx  (const char *s, ...);
extern char*    Str_areverse(const char *s);
extern char*    Str_amap    (const char *s, const char *from, const char *to);

extern char*    Str_asprintf(const char *fmt, ...);

extern char**   Str_split(char* s, const char* delimiters, unsigned empties, size_t* n);

#endif
