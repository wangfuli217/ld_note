#ifndef _PORTABLE_H_
#define _PORTABLE_H_

#include <sys/select.h>
#include <inttypes.h>

static inline void portable_usleep(uint64_t usec) 
{
    struct timeval tv;
    tv.tv_sec = usec/1000000;
    tv.tv_usec = usec%1000000;
    select(0, NULL, NULL, NULL, &tv);
}

#endif
