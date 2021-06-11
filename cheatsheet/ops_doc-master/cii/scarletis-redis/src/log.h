#ifndef LOG_H
#define LOG_H

#include <stddef.h>

void s_log(const char *s);

void s_err(const char *s);

void s_prt(const void *p, size_t len);

#endif
