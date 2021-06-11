#ifndef __ZUNKFS_UTIL_H__
#define __ZUNKFS_UTIL_H__

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

/*
 * Logging
 */
int set_logging (const char *params);
int dup_log_fd (int to);
void __zprintf (char level, const char *funct, int line, const char *fmt, ...);

extern FILE *zunkfs_log_fp;
extern char zunkfs_log_level;

#define zprintf(level, function, line, fmt...) ({ \
	int ___ret = 0; \
	if (zunkfs_log_fp && (level) <= zunkfs_log_level) { \
		int ___saved_errno = errno; \
		__zprintf(level, function, line, fmt); \
		errno = ___saved_errno; \
		___ret = 1; \
	} \
	___ret; \
})

#define ZUNKFS_ERROR	0
#define ZUNKFS_WARNING	1
#define ZUNKFS_TRACE	2

#define WARNING(x...) zprintf(ZUNKFS_WARNING, __FUNCTION__, __LINE__, x)
#define ERROR(x...)   zprintf(ZUNKFS_ERROR, __FUNCTION__, __LINE__, x)
#define TRACE(x...)   zprintf(ZUNKFS_TRACE, __FUNCTION__, __LINE__, x)

#define panic(x...) do { \
	if (!zprintf(ZUNKFS_ERROR, __FUNCTION__, __LINE__, x)) \
		fprintf(stderr, x); \
	abort(); \
} while(0)

#define warn_once(x...) do { \
	static int once = 1; \
	if (once) { \
		WARNING(x); \
		once = 0; \
	} \
} while(0)

#define COMPILER_ASSERT(cond, cond_name) \
static inline void __attribute__((unused)) COMPILER_ASSERT_##cond_name(void) { \
	switch(0) { \
	case (cond): \
	case 0: \
		break; \
	} \
}

/*
 * Linux-ish pointer error handling.
 */
extern void *const __errptr;

#define MAX_ERRNO	256

#ifndef NDEBUG
#include <string.h>

static inline void *__ERR_PTR (int err, const char *funct, int line) {
    if (err > 0 && err < MAX_ERRNO) {
        zprintf ('E', funct, line, "%s\n", strerror (err));
        return (void *) (__errptr + err);
    }
    return NULL;
}

static inline int __PTR_ERR (const void *ptr, const char *funct, int line) {
    int err = (ptr - __errptr);
    if (err > 0 && err < MAX_ERRNO)
        zprintf ('E', funct, line, "%s\n", strerror (err));
    return err;
}

#define ERR_PTR(err) __ERR_PTR(err, __FUNCTION__, __LINE__)
#define PTR_ERR(ptr) __PTR_ERR(ptr, __FUNCTION__, __LINE__)
#else
static inline void *ERR_PTR (int err) {
    return (void *) (__errptr + err);
}

static inline int PTR_ERR (const void *ptr) {
    return ptr - __errptr;
}
#endif

static inline int IS_ERR (const void *ptr) {
    return ptr >= __errptr && ptr < __errptr + MAX_ERRNO;
}

#define STR_OR_ERROR(str) IS_ERR(str) ? strerror(PTR_ERR(str)) : str

/*
 * Misc...
 */
#define container_of(ptr, type, memb) \
	((type *)((unsigned long)(ptr) - (unsigned long)&((type *)0)->memb))

char *sprintf_new (const char *fmt, ...);

/*
 * Socket helpers
 */
struct sockaddr_in;

struct sockaddr_in *__string_sockaddr_in (const char *str, struct sockaddr_in *sa);

#define string_sockaddr_in(addr_str) \
	__string_sockaddr_in(addr_str, alloca(sizeof(struct sockaddr_in)))

/*
 * Portability stuff...
 */
#ifndef MAP_NOCACHE             /* OSX mmap flag */
#define MAP_NOCACHE 0
#endif

#ifndef MAP_POPULATE            /* Linux mmap flag */
#define MAP_POPULATE 0
#endif

extern size_t strnlen (const char *s, size_t maxlen);
extern int fls (int i);
extern void sranddev (void);
extern int posix_madvise (void *, size_t, int);
extern int posix_fadvise (int, off_t, off_t, int);

#ifndef POSIX_MADV_WILLNEED
#define POSIX_MADV_WILLNEED 0
#endif

#ifndef POSIX_FADV_RANDOM
#define POSIX_FADV_RANDOM 0
#endif

#endif
