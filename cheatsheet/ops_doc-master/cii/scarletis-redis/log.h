#ifndef LOG_H
#define LOG_H

static const char *welcome =
"Scarletis\n"
"Port: %d\n"
"\n";

static time_t g_ticks;

void s_log(const char *s);

void s_err(const char *s);

void s_prt(const void *s, size_t len);

#endif
