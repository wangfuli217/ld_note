#ifndef DEF_H
#define DEF_H

#include <time.h>

#define SCAR_PORT       6379
#define BUFF_LEN        4096
#define MAX_EVENT_COUNT 4096

static char *welcome =
"\033\[31mScarletis\033\[0m\n"
"Port: %d\n";

static time_t g_ticks = 0;

#endif
