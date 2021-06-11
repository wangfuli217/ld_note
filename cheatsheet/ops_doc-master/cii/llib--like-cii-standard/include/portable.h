#ifndef PORTABLE_INCLUDED
#define PORTABLE_INCLUDED

#ifdef __GNUC__
#define MAXALIGN 8 /* Alignment used in the allocation functions */
#endif

#ifdef __GNUC__
#define inline inline
#else
#define inline _inline
#endif

/* Define thread_local for different gcc and msvc */
#ifdef __GNUC__
# define thread_local   __thread
#else
# ifdef _MSC_VER
#   define thread_local    __declspec(thread)
# else
#   define thread_local
# endif
#endif

/* Portable breakpoint expression (not statement) */
#if defined (_MSC_VER)
# define BREAKPOINT __debugbreak()
#elif defined (__GNUC__)
# define BREAKPOINT __builtin_trap()
#else
# include <signal.h>
# define BREAKPOINT        (raise (SIGTRAP))
#endif

#ifdef _WIN32
#ifdef NATIVE_EXCEPTIONS
extern void Except_hook_signal();
#endif
#endif

#ifndef _MSC_VER
#define ts_gmtime gmtime_r
#else
#define ts_gmtime gmtime
#endif

#ifdef _MSC_VER
#include <malloc.h>

#define Aligned_malloc  _aligned_malloc
#define Aligned_realloc _aligned_realloc
#define Aligned_free    _aligned_free

#elif __GNUC__
#include <stdlib.h>
#include <malloc.h>
#include <windows.h>

#define Aligned_malloc  __mingw_aligned_malloc
#define Aligned_realloc __mingw_aligned_realloc
#define Aligned_free    __mingw_aligned_free
#else
#define Aligned_free    free
#endif

#if defined(_MSC_VER)
  #define P_SIZE_T    "%Iu"
  #define P_SSIZE_T   "%Id"
  #define P_PTRDIFF_T "%Id"
#elif defined(__GNUC__)
  #define PR_SIZE_T    "%zu"
  #define PR_SSIZE_T   "%zd"
  #define PR_PTRDIFF_T "%zd"
#else
  #define PR_SIZE_T    "%zu"
  #define PR_SSIZE_T   "%zd"
  #define PR_PTRDIFF_T "%zd"
#endif

#include <stdio.h>
#include <stddef.h>

#ifdef _MSC_VER /* C99 compatible snprintf */

#define C_ASSERT(e) typedef char __C_ASSERT__[(e)?1:-1]
#include <stdarg.h>

#define snprintf c99_snprintf
#define vsnprintf c99_vsnprintf

inline int c99_vsnprintf(char* str, size_t size, const char* format, va_list ap)
{
    int count = -1;

    if (size != 0)
        count = _vsnprintf_s(str, size, _TRUNCATE, format, ap);
    if (count == -1)
        count = _vscprintf(format, ap);

    return count;
}

inline int c99_snprintf(char* str, size_t size, const char* format, ...)
{
    int count;
    va_list ap;

    va_start(ap, format);
    count = c99_vsnprintf(str, size, format, ap);
    va_end(ap);

    return count;
}

#endif // _MSC_VER

#ifdef __GNUC__
#define fast_c(x)      __builtin_expect(!!(x), 1)
#define slow_c(x)    __builtin_expect(!!(x), 0)
#else
#define fast_c(x)      x
#define slow_c(x)    x
#endif

#ifdef _MSC_VER
#define C_ASSERT(e) typedef char __C_ASSERT__[(e)?1:-1]
#endif

#ifdef _WIN32
#define strncasecmp _strnicmp
#define stat64 _stat64
#endif

#endif /* PORTABLE_INCLUDED */
