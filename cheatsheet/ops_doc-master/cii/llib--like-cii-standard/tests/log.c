#include <log.h>
#include <test.h>

unsigned test_log() {
    int dbg = debug_level;
    FILE* file = dbgstream;

    log_set(NULL, LOG_DISABLE);
    log("Don't print this number: %i\n", 10);

    log_set(stderr, LOG_INFO);
    /*log("Print this number: %i", 10); */

    log_set(NULL, LOG_DISABLE);
    log("Don't print this number: %i\n", 10);

    log_set(file, dbg);

    return TEST_SUCCESS;
}

