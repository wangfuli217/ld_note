#ifndef LOG_H
#define LOG_H

#include <stdarg.h>

/* Handy shorthand:
 * %E, passed an integer, expands to strerror(integer).
 * %i, passed a u_int32_t, expands to ipstring(u_int32_t).
 */

void log_fatal(const char *fmt, ...) /*@modifies nothing@*/;
void log_warn(const char *fmt, ...) /*@modifies nothing@*/;
void log_status(const char *fmt, ...) /*@modifies nothing@*/;
void log_trace(const char *fmt, ...) /*@modifies nothing@*/;
void log_code(const char *fmt, ...) /*@modifies nothing@*/; 

typedef enum loglevel_e {
	LOG_FATAL = 0,
	LOG_WARN,
	LOG_STATUS,
	LOG_TRACE,
	LOG_CODE
} loglevel_t;

/* like assert, but logs.
 */
void log_cond(int cond, loglevel_t l, const char *fmt, ...);

loglevel_t log_level_get(void);
void log_level_set(loglevel_t l);

#endif /* LOG_H */
