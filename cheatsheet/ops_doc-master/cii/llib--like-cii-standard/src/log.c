#include <time.h>

#include "assert.h"
#include "log.h"

thread_local FILE *dbgstream         = NULL;
thread_local unsigned  debug_level   = LOG_DISABLE;

void log_set(FILE* where, unsigned level) {
    assert(level < LOG_END);

    if(!where) where = stderr;
    if(!level) level = LOG_DISABLE;

    dbgstream   = where;
    debug_level = level;
}

void get_time(char* buffer) {
    time_t t;
    struct tm* tinfo;

    time(&t);
    tinfo = localtime(&t);
    strftime(buffer, 80, "%Y-%m-%d %H:%M:%S", tinfo);
}
