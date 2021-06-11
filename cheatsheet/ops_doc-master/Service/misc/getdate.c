#define _GNU_SOURCE 500
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
    struct tm *tmp;
    int j;

    for (j = 1; j < argc; j++) {
        tmp = getdate(argv[j]);

        if (tmp == NULL) {
            printf("Call %d failed; getdate_err = %d\n",
                   j, getdate_err);
            continue;
        }

        printf("Call %d (\"%s\") succeeded:\n", j, argv[j]);
        printf("    tm_sec   = %d\n", tmp->tm_sec);
        printf("    tm_min   = %d\n", tmp->tm_min);
        printf("    tm_hour  = %d\n", tmp->tm_hour);
        printf("    tm_mday  = %d\n", tmp->tm_mday);
        printf("    tm_mon   = %d\n", tmp->tm_mon);
        printf("    tm_year  = %d\n", tmp->tm_year);
        printf("    tm_wday  = %d\n", tmp->tm_wday);
        printf("    tm_yday  = %d\n", tmp->tm_yday);
        printf("    tm_isdst = %d\n", tmp->tm_isdst);
    }

    exit(EXIT_SUCCESS);
}

/*

$ TFILE=$PWD/tfile
$ echo '%A' > $TFILE       # Full weekday name
$ echo '%T' >> $TFILE      # ISO date (YYYY-MM-DD)
$ echo '%F' >> $TFILE      # Time (HH:MM:SS)
$ date
$ export DATEMSK=$TFILE
$ ./a.out Tuesday '2009-12-28' '12:22:33'
Sun Sep  7 06:03:36 CEST 2008
Call 1 ("Tuesday") succeeded:
    tm_sec   = 36
    tm_min   = 3
    tm_hour  = 6
    tm_mday  = 9
    tm_mon   = 8
    tm_year  = 108
    tm_wday  = 2
    tm_yday  = 252
    tm_isdst = 1
Call 2 ("2009-12-28") succeeded:
    tm_sec   = 36
    tm_min   = 3
    tm_hour  = 6
    tm_mday  = 28
    tm_mon   = 11
    tm_year  = 109
    tm_wday  = 1
    tm_yday  = 361
    tm_isdst = 0
Call 3 ("12:22:33") succeeded:
    tm_sec   = 33
    tm_min   = 22
    tm_hour  = 12
    tm_mday  = 7
    tm_mon   = 8
    tm_year  = 108
    tm_wday  = 0
    tm_yday  = 250
    tm_isdst = 1
*/