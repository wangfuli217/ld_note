#ifndef LOG_INCLUDED
#define LOG_INCLUDED

#include <stdio.h>

#include "portable.h" /* for thread_local */
#include "utils.h"

BEGIN_DECLS

#define LOG_DISABLE  (0)
#define LOG_FATAL    (1)
#define LOG_ERR      (2)
#define LOG_WARN     (3)
#define LOG_INFO     (4)
#define LOG_DBG      (5)
#define LOG_END      (6)

extern void get_time(char*);

#pragma warning (disable: 4127)

#define LOG_LEVEL(level, ...)   STMT_START {\
                                    if (level <= debug_level && dbgstream) { \
                                        char buf[80]; get_time(buf); \
                                        fprintf(dbgstream, buf); \
                                        fprintf(dbgstream," %-10s:%-5.d    ", __FILE__, __LINE__); \
                                        fprintf(dbgstream, __VA_ARGS__); \
                                        fprintf(dbgstream, "\n"); \
                                        fflush(dbgstream); \
                                    } \
                                } STMT_END

#define log(...)        LOG_LEVEL(LOG_INFO, __VA_ARGS__)
#define log_fatal(...)  LOG_LEVEL(LOG_FATAL, __VA_ARGS__)
#define log_err(...)    LOG_LEVEL(LOG_ERROR, __VA_ARGS__)
#define log_warn(...)   LOG_LEVEL(LOG_WARN, __VA_ARGS__)
#define log_info(...)   LOG_LEVEL(LOG_INFO, __VA_ARGS__)
#define log_dbg(...)    LOG_LEVEL(LOG_DBG, __VA_ARGS__)

extern thread_local FILE *dbgstream;
extern thread_local unsigned  debug_level;

/* If FILE is NULL, set it to stderr, if level is NULL, set it to 0 */

extern void log_set(FILE* where, unsigned level);

END_DECLS

#endif
