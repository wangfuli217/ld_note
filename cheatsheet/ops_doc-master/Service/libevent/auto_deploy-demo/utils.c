#include "utils.h"
#include <stdio.h>
#include <time.h>

int get_format_timestamp (char *op, int size) {
    if (NULL == op) {
        return -1;
    }
    time_t timer;
    struct tm *tm_info;

    time (&timer);
    tm_info = localtime (&timer);

    strftime (op, size, "%Y:%m:%d %H:%M:%S", tm_info);

    return 0;
}
