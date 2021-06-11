#include "log.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctype.h>

#include "def.h"

void s_log(const char *s) {
    g_ticks = time(NULL);
    fprintf(stdout, "%.24s * %s\n", ctime(&g_ticks), s);
}

void s_err(const char *s) {
    g_ticks = time(NULL);
    fprintf(stderr, "%.24s # ", ctime(&g_ticks));
    perror(s);
    exit(EXIT_FAILURE);
}

void s_prt(const void *p, size_t len) {
    const char *s = (const char *)p;
    putchar('"');
    for (size_t i = 0; i != len; ++i)
        if (isprint(s[i]))
            putchar(s[i]);
        else
            printf("\033\[31m\\%02X\033\[0m", s[i]);
    putchar('"');
    printf("(%lu)", len);
}
