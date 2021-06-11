#include<stdarg.h>
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<limits.h>
#include<float.h>
#include<ctype.h>
#include<math.h>
#include"assert.h"
#include"except.h"
#include"mem.h"
#include"fmt.h"

#define T fmt_t

struct buf{ 
    char   *buf;
    char   *bp;
    ssize_t size;
};


#define pad(n, c) do{ int nn = (n); \
    while (nn-- > 0)put((c), cl); \
    }while(0)

static int  outc(int c, void *cl);
static int  insert(int c, void *cl);
static int  append(int c, void *cl);
static void cvt_s(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);
static void cvt_d(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);
static void cvt_u(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);
static void cvt_o(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);
static void cvt_x(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);
static void cvt_p(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);
static void cvt_c(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);
static void cvt_f(int code, va_list *app,
                    int(*put)(int c, void *cl), void *cl,
                    unsigned char flags[], ssize_t width, ssize_t precision);

const except_t  OverflowException = {"Formatting Overflow"};

char       *fmt_flags = "-+ 0";

static T cvt[256] = {

    /*  0-  7   */  0,      0,      0,      0,      0,      0,      0,      0,
    /*  8- 15   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 16- 23   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 24- 31   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 32- 39   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 40- 47   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 48- 55   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 56- 63   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 64- 71   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 72- 79   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 80- 87   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 88- 95   */  0,      0,      0,      0,      0,      0,      0,      0,
    /* 96-103   */  0,      0,      0,  cvt_c,  cvt_d,  cvt_f,  cvt_f,  cvt_f,
    /*104-111   */  0,      0,      0,      0,      0,      0,      0,  cvt_o,
    /*112-119   */  cvt_p,  0,      0,  cvt_s,      0,  cvt_u,      0,      0,
    /*120-127   */  cvt_x,  0,      0,      0,      0,      0,      0,      0,
};




void
fmt_fmt(int (*put)(int c, void *cl),
        void *cl,
        const char *fmt, 
        ...)
{
    va_list ap;

    va_start(ap, fmt);
    fmt_vfmt(put, cl, fmt, ap);
    va_end(ap);
}


void
fmt_print(const char *fmt, ...) //printf
{
    va_list ap;

    va_start(ap, fmt);
    fmt_vfmt(outc, stdout, fmt, ap);
    va_end(ap);
}


void fmt_fprint(FILE *stream,  const char *fmt, ...) //fprintf
{
    va_list ap;

    va_start(ap, fmt);
    fmt_vfmt(outc, stream, fmt, ap);
    va_end(ap);
}


ssize_t
fmt_sfmt(char *buf, 
            ssize_t size,
            const char *fmt, 
            ...) //sprintf
{
    va_list ap;
    ssize_t len;

    va_start(ap, fmt);
    len = fmt_vsfmt(buf, size, fmt, ap);
    va_end(ap);
    return len;
}


ssize_t
fmt_vsfmt(char *buf,
            ssize_t size,
            const char *fmt,
            va_list ap) //vsprintf
{
    struct buf cl;

    assert(buf);
    assert(size > 0);
    assert(fmt);

    cl.buf = cl.bp = buf;
    cl.size = size;

    fmt_vfmt(insert, &cl, fmt, ap);
    insert(0, &cl);

    return cl.bp - cl.buf - 1;
}


char *
fmt_string(const char *fmt, ...)
{
    char *str;
    va_list ap;

    assert(fmt);
    va_start(ap, fmt);
    str = fmt_vstring(fmt, ap);
    va_end(ap);

    return str;
}


char *
fmt_vstring(const char *fmt, va_list ap)
{
    struct buf cl;

    assert(fmt);
    cl.size = 256;
    cl.buf = cl.bp = ALLOC(cl.size);

    fmt_vfmt(append, &cl, fmt, ap);
    append(0, &cl);
    return RESIZE(cl.buf, cl.bp - cl.buf);
}


void
fmt_vfmt(int (*put)(int c, void *cl),
            void *cl,
            const char *fmt, 
            va_list ap)
{
    unsigned char c, flags[256];
    ssize_t width, precision;
    int n, d;
    va_list ap_copy;

    assert(put);
    assert(fmt);

    while(*fmt)
        if(*fmt != '%' || '%' == *++fmt)
            put((unsigned char) *fmt++, cl);
        else{
            width = INT_MIN;
            precision = INT_MIN;

            memset(flags, '\0', sizeof(flags));
            //<get optional flags>
            if(fmt_flags){
                c = *fmt;
                for(; c && strchr(fmt_flags, c); c = *++fmt){
                    assert(flags[c] < 255);
                    flags[c]++;
                }
            }

            //<get optional filed width>
            if('*' == *fmt || isdigit(*fmt)){

                //<n <- next argument or scan digit>    
                if('*' == *fmt){
                    n = va_arg(ap, int);
                    assert(n != INT_MIN);
                    fmt ++;
                }else
                    for(n = 0; isdigit(*fmt); fmt++){
                        d = *fmt - '0';
                        assert(n <= (INT_MAX - d) / 10);

                        n = 10 * n + d;
                    }
                width = n;
            }

            //<get optional precision>
            if('.' == *fmt && ('*' == *++fmt || isdigit(*fmt))){
            
                //<n <- next argument or scan digit>    
                if('*' == *fmt){
                    n = va_arg(ap, int);
                    assert(n != INT_MIN);
                    fmt ++;
                }else
                    for(n = 0; isdigit(*fmt); fmt++){
                        d = *fmt - '0';
                        assert(n <= (INT_MAX - d) / 10);

                        n = 10 * n + d;
                    }
                precision = n;
            }

            c = *fmt++;
            assert(cvt[c]);
            va_copy(ap_copy, ap);
            (*cvt[c])(c, &ap_copy, put, cl, flags, width, precision);
            va_end(ap_copy);
        }
}




T
fmt_register(int code, T convert)
{
    T old;

    assert(0 < code
        && code < (int)(sizeof(cvt) / sizeof(cvt[0])));

    old = cvt[code];
    cvt[code] = convert;

    return old;
}


void
fmt_putd(const char *str,
            ssize_t len,
            int (*put)(int c, void *cl),
            void *cl,
            unsigned char flags[256],
            ssize_t width,
            ssize_t precision)
{
    int sign, n, i;

    assert(str);
    assert(len >= 0);
    assert(flags);

    //<normalize width and flags>
    if(INT_MIN == width)
        width = 0;
    if(width < 0){
        flags['-'] = 1;
        width = -width;
    }

    //<compute the sign>
    if(len > 0 && ('-' == *str || '+' == *str)){
        sign = *str++;
        len--;
    }else if(flags['+'])
        sign = '+';
    else if(flags[' '])
        sign = ' ';
    else
        sign = 0;


    //<emit str justified in width>
    if(precision < 0)
        precision = 1;
    if(len < precision)
        n = precision;
    else if(0 == precision && 1 == len && '0' == str[0])
        n = 0;
    else 
        n = len;
    if(sign)
        n++;
    if(flags['-']){
        if(sign)
            put(sign, cl);
    }else if(flags['0']){
        if(sign)
            put(sign, cl);
        pad(width - n, '0');
    }else{
        pad(width - n, ' ');
        if(sign)
            put(sign, cl);
    }

    pad(precision - len, '0');
    //<emit str[0..len-1]>
    for(i = 0; i < len; i++)
        put((unsigned char) *str++, cl);

    if(flags['-'])
        pad(width - n, ' ');
}

void        fmt_puts(const char *str,
                                ssize_t len,
                                int (*put)(int c, void *cl),
                                void *cl,
                                unsigned char flags[256],
                                ssize_t width,
                                ssize_t precision)
{
    int i;

    assert(str);
    assert(len >= 0);
    assert(flags);

    //<normalize width and flags>

    if(precision >= 0 && precision < len)
        len = precision;
    if(!flags['-'])
        pad(width - len, ' ');

    //<emit str[0..len-1]>
    for(i = 0; i < len; i++)
        put((unsigned char) *str++, cl);

    if(flags['-'])
        pad(width - len, ' ');
}



static int  outc(int c, void *cl)
{
    FILE *f = cl;

    return putc(c, f);
}


static
int
insert(int c, void *cl)
{
    struct buf *p = cl;

    if(p->bp >= p->buf + p->size)
        RAISE(OverflowException, "");

    *p->bp++ = c;
    return c;
}

static int  append(int c, void *cl)
{
    struct buf *p = cl;
    
    if(p->bp >= p->buf + p->size){
        RESIZE(p->buf, 2 * p->size);
        p->bp = p->buf + p->size;
        p->size *= 2;
    }
    *p->bp++ = c;
    return c;
}


static
void 
cvt_s(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    char *str = va_arg(*app, char *);

    assert(str);

    fmt_puts(str, strlen(str), put, cl, flags, width, precision);
}

static 
void 
cvt_d(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    int val;
    unsigned long m;
    char buf[43];
    char *p = buf + sizeof(buf);

    val = va_arg(*app, int);
    
    if(INT_MIN == val)
        m = INT_MIN + 1U;
    else if(val < 0)
        m = -val;
    else
        m = val;

    do{
        *--p = m % 10 + '0';
    }while((m /= 10) > 0);

    if(val < 0)
        *--p = '-';

    fmt_putd(p, (buf + sizeof(buf)) - p, put, cl, flags, width, precision);
}


static 
void 
cvt_u(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    char buf[43];
    char *p = buf + sizeof(buf);
    unsigned long m = va_arg(*app, unsigned long);

    do{
        *--p = m % 10 + '0';
    }while((m /= 10) > 0);

    fmt_putd(p, (buf + sizeof(buf)) - p, put, cl, flags, width, precision);
}


static 
void 
cvt_o(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    char buf[43];
    char *p = buf + sizeof(buf);
    unsigned long m = va_arg(*app, unsigned long);

    do{
        *--p = (m & 0x7) + '0';
    }while((m >>= 3) != 0);

    fmt_putd(p, (buf + sizeof(buf)) - p, put, cl, flags, width, precision);
}


static 
void 
cvt_x(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    char buf[43];
    char *p = buf + sizeof(buf);
    unsigned long m = va_arg(*app, unsigned long);

    do{
        *--p = "0123456789abcdef"[m & 0xf];
    }while((m >>= 4) != 0);

    fmt_putd(p, (buf + sizeof(buf)) - p, put, cl, flags, width, precision);
}


static 
void 
cvt_p(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    char buf[43];
    char *p = buf + sizeof(buf);
    unsigned long m = va_arg(*app, unsigned long);

    precision = INT_MIN;

    do{
        *--p = "0123456789abcdef"[m & 0xf];
    }while((m >>= 4) != 0);

    fmt_putd(p, (buf + sizeof(buf)) - p, put, cl, flags, width, precision);
}


static 
void 
cvt_c(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    //<normalize width 160>
    if(INT_MIN == width)
        width = 0;
    if(width < 0){
        flags['-'] = 1;
        width = -width;
    }

    if(!flags['-'])
        pad(width - 1, ' ');
    put((unsigned char) va_arg(*app, int), cl);
    if(flags['-'])
        pad(width - 1, ' ');
}


static 
void 
cvt_f(int code, va_list *app,
        int(*put)(int c, void *cl), void *cl,
        unsigned char flags[], ssize_t width, ssize_t precision)
{
    static char fmt[] = "%.dd?";
    char buf[DBL_MAX_10_EXP + 1 + 1 + 99 + 1];

    if(precision < 0)
        precision = 6;
    if('g' == code && 0 == precision)
        precision = 1;

    //<fomat a double argument into buf>
    assert(precision <= 99);
    fmt[4] = code;
    fmt[3] =    precision % 10 + '0';
    fmt[2] = (precision / 10) % 10 + '0';
    sprintf(buf, fmt, va_arg(*app, double));

    fmt_putd(buf, strlen(buf), put, cl, flags, width, precision);
}
