#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int
main(void)
{
    struct tm tm;
    char buf[255];

    strptime("2001-11-12 18:31:01", "%Y-%m-%d %H:%M:%S", &tm);
    strftime(buf, sizeof(buf), "%d %b %Y %H:%M", &tm);
    puts(buf);
    exit(EXIT_SUCCESS);
}