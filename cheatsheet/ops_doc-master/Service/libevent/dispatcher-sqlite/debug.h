#ifndef __DEBUG_H__
#define __DEBUG_H__

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>
#include <time.h>

#ifdef _NDEDUG
#define ph_debug(M, ...)
#else
#define ph_debug(M, ...) elog(0, "DEBUG %s:%d: " M "\n", \
  __FILE__, __LINE__, ##__VA_ARGS__)
#endif

#define ph_clean_errno() (errno == 0 ? "None" :strerror(errno))

#define ph_log_err(M, ...) elog(1, "[ERROR] (%s:%d: errno:%s) " M "\n", \
  __FILE__, __LINE__, ph_clean_errno(), ##__VA_ARGS__)

#define ph_log_warn(M, ...) elog(0, "[WARN] (%s:%d: errno:%s) " M "\n", \
  __FILE__, __LINE__, ph_clean_errno(), ##__VA_ARGS__)

#define ph_log_info(M, ...) elog(0, "[INFO] (%s:%d) " M "\n", \
  __FILE__, __LINE__, ##__VA_ARGS__)

#define ph_check(A, M, ...) if (!(A)) { \
  ph_log_err(M , ##__VA_ARGS__); \
  errno = 0; \
  goto error;\
}

#define ph_sentinel(M, ...) { \
  ph_log_err(M, ##__VA_ARGS__); \
  errno = 0; \
  goto error; \
}

#define ph_check_mem(A) ph_check((A), "Out of memory.")

#define ph_check_debug(A, M, ...) if (!(A)) { \
  ph_debug(M, ##__VA_ARGS__); \
  errno = 0; \
  goto error; \
}

static void elog (int fatal, const char *fmt, ...) {
    va_list ap;

#if defined(_NDEDUG)
    if (!fatal) {               /* Do not show debug message */
        return;
    }
#endif

    time_t t = time (NULL);
    struct tm *dm = localtime (&t);

    (void) fprintf (stderr, "[%02d:%02d:%02d] :\t", dm->tm_hour, dm->tm_min, dm->tm_sec);

    va_start (ap, fmt);
    vfprintf (stderr, fmt, ap);
    va_end (ap);

    fputc ('\n', stderr);

    if (fatal) {
        exit (EXIT_FAILURE);
    }
}

#endif
