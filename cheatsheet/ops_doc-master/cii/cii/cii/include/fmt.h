#ifndef FMT_INCLUDE
#define FMT_INCLUDE

#include<stdarg.h>
#include<stdio.h>
#include"except.h"

#define T fmt_t
typedef void (*T)(int code, 
                    va_list *app,
                    int (*put)(int c, void *cl),
                    void *cl,
                    unsigned char flags[256],
                    ssize_t width,
                    ssize_t precision);


extern  char       *fmt_flags;

extern  const except_t  OverflowException;


extern  void        fmt_fmt(int (*put)(int c, void *cl),
                            void *cl,
                            const char *fmt, ...);

extern  void        fmt_vfmt(int (*put)(int c, void *cl),
                            void *cl,
                            const char *fmt, 
                            va_list ap);

extern  void        fmt_print(const char *fmt, ...);
extern  void        fmt_fprint(FILE *stream, 
                                const char *fmt, ...);
extern  ssize_t     fmt_sfmt(char *buf, 
                                ssize_t size,
                                const char *fmt, ...);
extern  ssize_t     fmt_vsfmt(char *buf,
                                ssize_t size,
                                const char *fmt,
                                va_list ap);

extern  char       *fmt_string(const char *fmt, ...);
extern  char       *fmt_vstring(const char *fmt, va_list ap);

extern  T           fmt_register(int code, T convert);

extern  void        fmt_putd(const char *str,
                                ssize_t len,
                                int (*put)(int c, void *cl),
                                void *cl,
                                unsigned char flags[256],
                                ssize_t width,
                                ssize_t precision);

extern  void        fmt_puts(const char *str,
                                ssize_t len,
                                int (*put)(int c, void *cl),
                                void *cl,
                                unsigned char flags[256],
                                ssize_t width,
                                ssize_t precision);
                

#undef T
#endif /*FMT_INCLUDE*/
