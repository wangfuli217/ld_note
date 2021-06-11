#include "dir.h"
#include "test.h"
#include "mem.h"
#include "log.h"

unsigned test_file() {
    dir_entry dir;
    char* file;
    unsigned n = 0;
    dir = Dir_open( ".");

    while ((file = Dir_next_entry(dir)) != NULL)
    {
        log("%s", file);
        n++;
        FREE(file);
    }

    Dir_close(dir);
    test_assert(n >= 2);

    return TEST_SUCCESS;
}
