// Timer.c 

#include "Timer.h"
#include <stdlib.h>
#include <sys/time.h>
#include <sys/resource.h>

static struct rusage this_old_us_time;
static struct rusage this_new_us_time;
static struct timeval this_old_wc_time;
static struct timeval this_new_wc_time;

int Timer_start () {
    if (gettimeofday (&this_old_wc_time, 0) == -1 || getrusage (RUSAGE_SELF, &this_old_us_time) == -1)
        return -1;
    else
        return 0;
}

int Timer_elapsedWallclockTime (double *wc) {
    if (gettimeofday (&this_new_wc_time, 0) == -1)
        return -1;
    *wc = (this_new_wc_time.tv_sec - this_old_wc_time.tv_sec)
        + (this_new_wc_time.tv_usec - this_old_wc_time.tv_usec) / 1000000.0;
    return 0;
}

int Timer_elapsedUserTime (double *ut) {
    if (getrusage (RUSAGE_SELF, &this_new_us_time) == -1)
        return -1;

    *ut = (this_new_us_time.ru_utime.tv_sec - this_old_us_time.ru_utime.tv_sec)
        + ((this_new_us_time.ru_utime.tv_usec - this_old_us_time.ru_utime.tv_usec) / 1000000.0);
    return 0;
}

int Timer_elapsedSystemTime (double *st) {
    if (getrusage (RUSAGE_SELF, &this_new_us_time) == -1)
        return -1;

    *st = (this_new_us_time.ru_stime.tv_sec - this_old_us_time.ru_stime.tv_sec)
        + ((this_new_us_time.ru_stime.tv_usec - this_old_us_time.ru_stime.tv_usec) / 1000000.0);
    return 0;
}

int Timer_elapsedTime (double *wallclock, double *user_time, double *system_time) {
    if (Timer_elapsedWallclockTime (wallclock) == -1)
        return -1;
    if (getrusage (RUSAGE_SELF, &this_new_us_time) == -1)
        return -1;
    *user_time = (this_new_us_time.ru_utime.tv_sec - this_old_us_time.ru_utime.tv_sec)
        + ((this_new_us_time.ru_utime.tv_usec - this_old_us_time.ru_utime.tv_usec) / 1000000.0);

    *system_time = (this_new_us_time.ru_stime.tv_sec - this_old_us_time.ru_stime.tv_sec)
        + ((this_new_us_time.ru_stime.tv_usec - this_old_us_time.ru_stime.tv_usec) / 1000000.0);

    return 0;
}
