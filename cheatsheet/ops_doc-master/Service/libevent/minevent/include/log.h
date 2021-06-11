#ifndef _MIN_LOG_H_
#define _MIN_LOG_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>
#include <time.h>

#define _DEBUG
#define __QUOTE(x)      # x
#define  _QUOTE(x)      __QUOTE(x)

#define LOG_OUTPUT(std, fmt, ...) do {                                                  \
            time_t t = time(NULL);                                                      \
            struct tm *dm = localtime(&t);                                              \
                                                                                        \
            fprintf(std, "[%02d:%02d:%02d] %s:[" _QUOTE(__LINE__) "]\t       %-26s:"    \
                    fmt "\n", dm->tm_hour, dm->tm_min, dm->tm_sec, __FILE__, __func__,  \
                    ## __VA_ARGS__);                                                    \
            fflush(stdout);                                                             \
} while(0)

#ifdef _DEBUG
#define LOG_DEBUG(fmt, ...) LOG_OUTPUT(stdout, fmt, ## __VA_ARGS__)
#else
#define LOG_DEBUG(fmt, ...)
#endif

#define LOG_ERROR(fmt, ...) do {                    \
            LOG_OUTPUT(stderr, fmt, ## __VA_ARGS__);\
            exit(1);                                \
} while(0)

#ifdef __cplusplus
}
#endif
#endif
