#include "fmt.h"

#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <float.h>
#include <ctype.h> 
#include <math.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/*
 * Dave Hanson's Fmt printf replacement library
 *  
 * This code is almost verbatim from CI&I. However, Hanson's 
 * text doesn't support integer size qualification (%hd, %Lx, etc).
 * I've added support for this; just before the conversion
 * specifier (the d or u or f or q or whatever) you can use
 * L, l, or h for long long, long, or short. 
 *
 * [NTF]
 * This code is no longer verbatim from CI&I, because the CI&I code sucks in
 * numerous ways. We have fixed bugs and added enhancements, but it should be
 * rewritten in C++ soon.
 */

static void *xrealloc(void *ptr, size_t n);
static void *xalloc(size_t s);

static int outc(int c, void *cl);
static int insert(int c, void *cl);
static int append(int c, void *cl);

static void cvt_s(fmt_code_info_t *);
static void cvt_x(fmt_code_info_t *);
static void cvt_b(fmt_code_info_t *);
static void cvt_c(fmt_code_info_t *);
static void cvt_d(fmt_code_info_t *);
static void cvt_E(fmt_code_info_t *);
static void cvt_i(fmt_code_info_t *);
static void cvt_f(fmt_code_info_t *);
static void cvt_o(fmt_code_info_t *);
static void cvt_p(fmt_code_info_t *);
static void cvt_u(fmt_code_info_t *);
static void cvt_a(fmt_code_info_t *);

struct buf {
	char *buf;
	char *bp;
	int size;
};

static char *Fmt_flags = "-+ 0";
static char *Fmt_sizes = "lLh";

/* ------------------------------------------------------------------- */

/* predefined conversion functions */

static cvt_array_t default_cvt = { {       /* corresponds to ASCII character codes */
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 0 - 7     */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 8 - 15    */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 16 - 23   */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 24 - 31   */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 32 - 39   */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 40 - 47   */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 48 - 55   */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 56 - 63   */ 
	{0}, {0}, {0}, {0}, {0}, {cvt_E}, {0}, {0}, 		/* 64 - 71   */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 72 - 79   */ 
	{0}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 80 - 87   */ 
	{cvt_x}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 88 - 95   */ 
	{0}, {cvt_a}, {cvt_b}, {cvt_c}, {cvt_d}, {cvt_f}, {cvt_f}, {cvt_f}, /* - 103 */ 
	{0}, {cvt_i}, {0}, {0}, {0}, {0}, {0}, {cvt_o}, 	/* 104 - 111 */ 
	{cvt_p}, {0}, {0}, {cvt_s}, {0}, {cvt_u}, {0}, {0},	/* 112 - 119 */
	{cvt_x}, {0}, {0}, {0}, {0}, {0}, {0}, {0}, 		/* 120 - 127 */ 
} };

/* quote matching characters.
 * basically, anything with an end quote of 0 isn't possible as a quote.
 * so NUL and alphanumerics can't be quote characters.
 * ()[]<>{}`' pairs match their partner as the end quote.
 * other characters just match themselves as the end quote.
 */

static unsigned char quotes[256] = {
	  0,   1,   2,   3,   4,   5,   6,   7,		/*  0 -  7   */ 
	  8,   0,   0,   0,   0,   0,  14,  15,		/*  8 - 15   */ 
	 16,  17,  18,  19,  20,  21,  22,  23,		/* 16 - 23   */ 
	 24,  25,  26,  27,  28,  29,  30,  31,		/* 24 - 31   */ 
	  0,  33,  34,  35,  36,  37,  38, '`',		/* 32 - 39   */ 
	')', '(',  42,  43,  44,  45,  46,  47,		/* 40 - 47   */ 
	  0,   0,   0,   0,   0,   0,   0,   0,		/* 48 - 55   */ 
	  0,   0,  58,  59, '>',  61, '<',  63,		/* 56 - 63   */ 
	 64,   0,   0,   0,   0,   0,   0,   0,		/* 64 - 71   */ 
	  0,   0,   0,   0,   0,   0,   0,   0,		/* 72 - 79   */ 
	  0,   0,   0,   0,   0,   0,   0,   0,		/* 80 - 87   */ 
	  0,   0,   0, ']',  92, '[',  94,  95,		/* 88 - 95   */ 
	'\'',  0,   0,   0,   0,   0,   0,   0,		/* 96 - 103  */ 
	  0,   0,   0,   0,   0,   0,   0,   0,		/* 104 - 111  */ 
	  0,   0,   0,   0,   0,   0,   0,   0,		/* 112 - 119  */ 
	  0,   0,   0, '}', 124, '{', 126, 127,		/* 120 - 127  */ 
};

/* ------------------------------------------------------------------- */

/* Output function (stdio) */

static int 
outc(int c, void *cl) {
	FILE *f = (FILE *) cl;

	return(putc(c, f));
}

/* ------------------------------------------------------------------- */

/* Output function (string, no resize) */

static int 
insert(int c, void *cl) {
	struct buf *p = (struct buf *) cl;

	char *end = p->buf + p->size - (c?1:0); // allow the last character to be written only if it's 0
	if(p->bp >= end) {
		return(-c); 	/* XXX deal with exceptions */
	}

	*p->bp++ = c;

	return(c); 
}

/* ------------------------------------------------------------------- */

/* Output function (string, resize) */

static int 
append(int c, void *cl) {
	struct buf *p = (struct buf *) cl;

	/* double the allocation when we run out of space */

	if(p->bp >= p->buf + p->size) {
		p->buf = xrealloc(p->buf, 2 * p->size);

		p->bp = p->buf + p->size;

		p->size *= 2;	
	}

	*p->bp++ = c;

	return(c);
}

/* ------------------------------------------------------------------- */

void new_cvt(cvt_array_t *ncvt) {
    *ncvt = default_cvt;

    return;
}

/* ------------------------------------------------------------------- */

static void
fmt_simple_wrapper(fmt_code_info_t *arg) {
	void *a = va_arg(*arg->app, void *);
	simplefmt_t fn = arg->cl;
	char *str = fn(a);
	fmt_puts(str, strlen(str), arg);
}

/* ------------------------------------------------------------------- */

void
fmt_add(int c, simplefmt_t fn) {
	fmt_handler_info_t f;
	f.handler = fmt_simple_wrapper;
	f.cl = fn;
	f.cl_free = NULL;
	f.arg = 0;
	fmt_register_verbose(c, f);
}

/* ------------------------------------------------------------------- */

fmt_handler_info_t fmt_register(int code, fmt_t ncvt) {
	return fmt_register_specific(&default_cvt, code, ncvt);
}

/* Register so we can use a non-global array of formatters. - dk
 */
fmt_handler_info_t fmt_register_specific(cvt_array_t *cvt, int code, fmt_t ncvt) {
	fmt_handler_info_t new_info;
	memset(&new_info, 0, sizeof new_info);
	new_info.handler = ncvt;
	return fmt_register_verbose_specific(cvt, code, new_info);
}

/* ------------------------------------------------------------------- */

fmt_handler_info_t fmt_register_verbose(int code, fmt_handler_info_t ncvt) {
	return fmt_register_verbose_specific(&default_cvt, code, ncvt);
}

/* Use this as our replacement for fmt_register_verbose so we can use a 
 * non-global array of formatters. - dk
 */ 
fmt_handler_info_t fmt_register_verbose_specific(cvt_array_t *cvt, int code, fmt_handler_info_t ncvt) {
        fmt_handler_info_t old;

	assert(0 < code && code < (int)(sizeof(cvt->cvt) / sizeof(cvt->cvt[0])));

	old = cvt->cvt[code];
	cvt->cvt[code] = ncvt;

	return(old);
}

/* ------------------------------------------------------------------- */

/* Non-v* fmt functions simply wrap the v* versions */

void 
fmt_fmt(putfunc_t put, void *cl, const char *fmt, ...) {
	va_list ap;

	va_start(ap, fmt);

	fmt_vfmt(put, cl, fmt, ap);

	va_end(ap);

	return;
}

void 
fmt_fmt_specific(cvt_array_t *cvt, putfunc_t put, void *cl, const char *fmt, ...) {
	va_list ap;

	va_start(ap, fmt);

	fmt_vfmt_specific(cvt, put, cl, fmt, ap);

	va_end(ap);

	return;
}

/* ------------------------------------------------------------------- */

void
fmt_vfmt(putfunc_t put, void *cl, const char *fmt, va_list ap) {
	fmt_vfmt_specific(&default_cvt, put, cl, fmt, ap);
}

void
fmt_vfmt_specific(cvt_array_t *cvt, putfunc_t put, void *cl, const char *fmt, va_list ap) {
	assert(put && fmt);

	while(*fmt) {
		/* non-formatting characters, just output */

		if(*fmt != '%' || *++fmt == '%') 
			put((unsigned char)*fmt++, cl);
		else {
			/* format an argument */

			unsigned char c;
			fmt_code_info_t info;
			memset(&info, 0, sizeof info);
			info.width = INT_MIN;
			info.prec = INT_MIN;
			info.cvt = cvt;

			/* optional flags */			

			{
				unsigned char c = *fmt;

				for(; c && strchr(Fmt_flags, c); c = *++fmt) {
					assert(info.flags[c] < 255);
					
					info.flags[c]++;
				}
			}

			/* optional field width */

			if(*fmt == '*' || isdigit(*fmt)) {
				int n;

				/* n <- next argument or scan digits */

#define SCANDIGITS(fmt) do {					\
	if(*fmt == '*') {					\
		n = va_arg(ap, int);				\
		assert(n != INT_MIN);				\
		fmt++;						\
	} else for(n = 0; isdigit(*fmt); fmt++) {		\
		int d = *fmt - '0';				\
		assert(n <= (INT_MAX - d) / 10);		\
		n = 10 * n + d;					\
	} 							\
	} while(0)
	
				SCANDIGITS(fmt);

				info.width = n;
	
			}

			/* optional precision */

			if(*fmt == '.' 
			&&(*++fmt == '*' || isdigit(*fmt))) {
				int n;

				/* n <- next argument or scan digits */

				SCANDIGITS(fmt);

				info.prec = n;
			}

			/* optional size specifier */
			if (strchr(Fmt_sizes, *fmt) && cvt->cvt[(int)fmt[1]].handler)
				info.flags[(int)*fmt++] = 1;

			/* execute format directive */

			c = *fmt++;

			if(!cvt->cvt[c].handler) {
				fprintf(stderr, "*** BAD FMT CHARACTER `%c'\n", c);
				return;
			}

			/* optional argument */
			if (cvt->cvt[c].arg) {
				unsigned char end_quote = quotes[(int)*fmt];
				if (end_quote) {
					info.arg = ++fmt;
					fmt = strchr(fmt, end_quote);
					if (!fmt) {
						fprintf(stderr, "*** ARGUMENT NOT FINISHED FOR FMT CHARACTER `%c'\n", c);
						return;
					}
					info.arg_len = fmt++ - info.arg;
				}
			}
	
			info.code = c;
			info.cl = cvt->cvt[c].cl;
			info.app = &ap;
			info.put = put;
			info.put_cl = cl;

			(cvt->cvt[c].handler)(&info);
		}	
	}

	return;
}

#undef SCANDIGITS

/* ------------------------------------------------------------------- */

void
fmt_print(const char *fmt, ...) {
	va_list ap;

	va_start(ap, fmt);
	
	fmt_vfmt(outc, stdout, fmt, ap);

	va_end(ap);

	return;
}

void
fmt_print_specific(cvt_array_t *cvt, const char *fmt, ...) {
	va_list ap;

	va_start(ap, fmt);
	
	fmt_vfmt_specific(cvt, outc, stdout, fmt, ap);

	va_end(ap);

	return;
}

/* ------------------------------------------------------------------- */

void
fmt_eprint(const char *fmt, ...) {
	va_list ap;

	va_start(ap, fmt);
	
	fmt_vfmt(outc, stderr, fmt, ap);

	va_end(ap);

	fflush(stderr);

	return;
}

void
fmt_eprint_specific(cvt_array_t *cvt, const char *fmt, ...) {
	va_list ap;

	va_start(ap, fmt);
	
	fmt_vfmt_specific(cvt, outc, stderr, fmt, ap);

	va_end(ap);

	fflush(stderr);

	return;
}

/* ------------------------------------------------------------------- */

void
fmt_fprint(FILE *fp, const char *fmt, ...) {
	va_list ap;

	assert(fp);

	va_start(ap, fmt);
	
	fmt_vfmt(outc, fp, fmt, ap);

	va_end(ap);

	return;
}

void
fmt_vfprint(FILE *fp, const char *fmt, va_list ap)
{
	assert(fp);
	fmt_vfmt(outc, fp, fmt, ap);
}

void
fmt_fprint_specific(cvt_array_t *cvt, FILE *fp, const char *fmt, ...) {
	va_list ap;

	assert(fp);

	va_start(ap, fmt);
	
	fmt_vfmt_specific(cvt, outc, fp, fmt, ap);

	va_end(ap);

	return;
}

/* ------------------------------------------------------------------- */

int
fmt_sfmt(char *buf, int size, const char *fmt, ...) {
	va_list ap;
	int len;

	va_start(ap, fmt);

	len = fmt_vsfmt(buf, size, fmt, ap);

	va_end(ap);

	return(len);
}

int
fmt_sfmt_specific(cvt_array_t *cvt, char *buf, int size, const char *fmt, ...) {
	va_list ap;
	int len;

	va_start(ap, fmt);

	len = fmt_vsfmt_specific(cvt, buf, size, fmt, ap);

	va_end(ap);

	return(len);
}

/* ------------------------------------------------------------------- */

int
fmt_vsfmt(char *buf, int size, const char *fmt, va_list ap) {
	return fmt_vsfmt_specific(&default_cvt, buf, size, fmt, ap);
}

int
fmt_vsfmt_specific(cvt_array_t *cvt, char *buf, int size, const char *fmt, va_list ap) {
	struct buf cl;

	assert(buf && size > 0 && fmt);

	cl.buf = cl.bp = buf;

	cl.size = size;

	fmt_vfmt_specific(cvt, insert, &cl, fmt, ap);

	/* NUL termination */

	insert(0, &cl);

	return(cl.bp - cl.buf - 1);
}

/* ------------------------------------------------------------------- */

char *
fmt_string(const char *fmt, ...) {
	char *str = NULL;
	va_list ap;

	assert(fmt);

	va_start(ap, fmt);

	str = fmt_vstring(fmt, ap);

	va_end(ap);

	return(str);
}

char *
fmt_string_specific(cvt_array_t *cvt, const char *fmt, ...) {
	char *str = NULL;
	va_list ap;

	assert(fmt);

	va_start(ap, fmt);

	str = fmt_vstring_specific(cvt, fmt, ap);

	va_end(ap);

	return(str);
}

/* ------------------------------------------------------------------- */

char *
fmt_vstring(const char *fmt, va_list ap) {
	return fmt_vstring_specific(&default_cvt, fmt, ap);
}

char *
fmt_vstring_specific(cvt_array_t *cvt, const char *fmt, va_list ap) {
	struct buf cl;

	assert(fmt);

	cl.size = 256;
	cl.buf = cl.bp = xalloc(cl.size);

	fmt_vfmt_specific(cvt, append, &cl, fmt, ap);

	append(0, &cl);

	return(xrealloc(cl.buf, cl.bp - cl.buf));
}

/* ------------------------------------------------------------------- */
/* ------------------------------------------------------------------- */

#define PAD(n, c) do { 			\
	int nn = (n);			\
	while(nn-- > 0) 		\
		info->put((c), info->put_cl); 		\
	} while(0)

void 
fmt_puts(const char *str, int len, fmt_code_info_t *info) {
	assert(str && len >= 0);

	/* normalize width */

	if(info->width == INT_MIN)
		info->width = 0;
	if(info->width < 0) {
		info->flags['-'] = 1;
	
		info->width = -info->width;		
	}

	/* normalize flags */

	if(info->prec >= 0)
		info->flags['0'] = 0;

	if(info->prec >= 0 && info->prec < len) 
		len = info->prec;

	/* left justify */

	if(!info->flags['-'])
		PAD(info->width - len, ' ');
	
	{
		int i;

		for(i = 0; i < len; i++) 
			info->put((unsigned char)*str++, info->put_cl);
	}

	/* right justify */

	if(info->flags['-']) 
		PAD(info->width - len, ' ');

	return;
}

/* ------------------------------------------------------------------- */

static void 
cvt_s  (fmt_code_info_t *info) {

	char *str = va_arg(*info->app, char *);
	int len;
	assert(str);

	len = strlen(str);
	if (info->prec != INT_MIN && info->prec < len)
	    len = info->prec;

	fmt_puts(str, len, info);

	return;
}

/* ------------------------------------------------------------------- */

static void cvt_E(fmt_code_info_t *info) {
	int errno = va_arg(*info->app, int);
	fmt_puts(strerror(errno), strlen(strerror(errno)), info);
}

/* ------------------------------------------------------------------- */
     
static void cvt_i(fmt_code_info_t *info) {
	char buf[32];
	u_int32_t addr = va_arg(*info->app, u_int32_t);
	struct in_addr ia;
	ia.s_addr = addr;
	fmt_sfmt(buf, sizeof(buf), "%s", inet_ntoa(ia)); 
	fmt_puts(buf, strlen(buf), info);
}

/* ------------------------------------------------------------------- */

static void cvt_d(fmt_code_info_t *info) {
	/* declare buf and p, initialize p */

	char buf[200];
	char *p = buf + sizeof(buf);

#define EMIT(m) do {				\
	if(val == INT_MIN)			\
		m = INT_MAX + 1U;		\
	else if(val < 0)			\
		m = -val;			\
	else					\
		m = val;			\
						\
	do 					\
		*--p = (char)(m % 10 + '0');		\
	while((m /= 10) > 0);			\
						\
	if(val < 0)				\
		*--p = '-';			\
	} while(0)				

	if(info->flags['L']) {
		int64_t val = va_arg(*info->app, int64_t);
		int64_t m;

		EMIT(m);
	} else if(info->flags['l']) {
		long val = va_arg(*info->app, long);
		long m;

		EMIT(m);
	} else if(info->flags['h']) {
		short valx;
		int val;
		int m;

		valx = (short) va_arg(*info->app, int);
		val = valx;

		EMIT(m);
	} else {
		int val = va_arg(*info->app, int);
		int m;

		EMIT(m);
	}

#undef EMIT

	fmt_putd(p, (buf + sizeof buf) - p, info);

	return;
}

/* ------------------------------------------------------------------- */

static void
cvt_u(fmt_code_info_t *info) {
	/* declare buf and p, initialize p */

	char buf[200];
	char *p = buf + sizeof(buf);

#define EMIT(m) do {				\
	do					\
		*--p = (char)(m % 10 + '0');		\
	while((m /= 10) > 0);			\
	} while(0)

	if(info->flags['L']) {
		u_int64_t m = va_arg(*info->app, u_int64_t);

		EMIT(m);
	} else if(info->flags['l']) {
		unsigned long m = va_arg(*info->app, unsigned long);

		EMIT(m);
	} else if(info->flags['h']) {
		unsigned short m;
		m = (unsigned short) va_arg(*info->app, unsigned);

		EMIT(m);
	} else {
		unsigned m = va_arg(*info->app, unsigned);

		EMIT(m);
	}

#undef EMIT

	fmt_putd(p, (buf + sizeof buf) - p, info);

	return;
}

/* ------------------------------------------------------------------- */

static void
cvt_o(fmt_code_info_t *info) {
	/* declare buf and p, initialize p */

	char buf[43];
	char *p = buf + sizeof(buf);

#define EMIT(m) do {					\
	do						\
		*--p = (char)((m & 0x7) + '0');			\
	while((m >>= 3) != 0);				\
	} while(0)				

	if(info->flags['L']) {
		u_int64_t m = va_arg(*info->app, u_int64_t);

		EMIT(m);
	} else if(info->flags['l']) {
		unsigned long m;
		m = va_arg(*info->app, unsigned long);

		EMIT(m);
	} else if(info->flags['h']) {
		unsigned short m;
		m = (unsigned short) va_arg(*info->app, unsigned);

		EMIT(m);
	} else {
		unsigned m = va_arg(*info->app, unsigned);

		EMIT(m);
	}
	
#undef EMIT	

	fmt_putd(p, (buf + sizeof buf) - p, info);

	return;
}

/* ------------------------------------------------------------------- */

static void 
cvt_x(fmt_code_info_t *info) {
	/* declare buf and p, initialize p */

	char buf[43];
	char *p = buf + sizeof(buf);

	/* emit m in hexidecimal */

#define EMIT(m) do {					\
	do {						\
		char *cset = NULL;			\
							\
		if(info->code == 'x')			\
			cset = "0123456789abcdef";	\
		else					\
			cset = "0123456789ABCDEF";	\
							\
		*--p = cset[m&0xf];			\
	} while((m >>= 4) != 0);			\
	} while(0)

	if(info->flags['L']) {
		u_int64_t m = va_arg(*info->app, u_int64_t);

		EMIT(m);
	} else if(info->flags['l']) {
		unsigned long m;
		m = va_arg(*info->app, unsigned long);

		EMIT(m);
	} else if(info->flags['h']) {
		unsigned short m;
		m = (unsigned short) va_arg(*info->app, unsigned);

		EMIT(m);
	} else {
		unsigned m = va_arg(*info->app, unsigned);

		EMIT(m);
	}

#undef EMIT

	fmt_putd(p, (buf + sizeof buf) - p, info);

	return;
}

/* ------------------------------------------------------------------- */

static void
cvt_a(fmt_code_info_t *info) {
	char buf[500];
	u_int64_t amount = 0;
	u_int32_t div = 0;
	char *qual = "";
	size_t l = 0;

	if(info->flags['L']) {
		amount = va_arg(*info->app, u_int64_t);
	} else {
		u_int32_t arg = va_arg(*info->app, u_int32_t);
		amount = arg;
	}

	if(amount > (1000*1000*1000)) {
		div = (1000*1000*1000);
		qual = "G";
	} else if(amount > (1000*1000)) {
		div = (1000*1000);
		qual = "M";
	} else if(amount > 1000) { 
		div = (1000);
		qual = "k";			       
	} else
		div = 1;      

	l = fmt_sfmt(buf, 500, "%.2f%s", ((double)amount/(double)div), qual);
	fmt_putd(buf, l, info);
}

// ------------------------------------------------------------ 

static void 
cvt_b(fmt_code_info_t *info) {
	/* declare buf and p, initialize p */

	char buf[100];
	char *p = buf + sizeof(buf);

	/* emit m in binary */

	char *cset = "01";

#define EMIT(m) do {					\
	do {						\
		*--p = cset[m&0x1];			\
	} while((m >>= 1) != 0);			\
	} while(0)

	if(info->flags['L']) {
		u_int64_t m = va_arg(*info->app, u_int64_t);

		EMIT(m);
	} else if(info->flags['l']) {
		unsigned long m = va_arg(*info->app, unsigned long);

		EMIT(m);
	} else if(info->flags['h']) {
		unsigned short m;
		m = (unsigned short) va_arg(*info->app, unsigned);

		EMIT(m);
	} else {
		unsigned m = va_arg(*info->app, unsigned);

		EMIT(m);
	}

#undef EMIT

	fmt_putd(p, (buf + sizeof buf) - p, info);

	return;
}

/* ------------------------------------------------------------------- */

static void
cvt_p(fmt_code_info_t *info) {
	unsigned long m = (unsigned long) va_arg(*info->app, void *);

	/* declare buf and p, initialize p */

	char buf[43];
	char *p = buf + sizeof(buf);

	info->prec = INT_MIN;

	/* emit m in hexidecimal */

	do {
		char *cset = "0123456789ABCDEF";
		
		*--p = cset[m&0xf];
	} while((m >>= 4) != 0);

	fmt_putd(p, (buf + sizeof buf) - p, info);

	return;
}

/* ------------------------------------------------------------------- */

static void
cvt_c(fmt_code_info_t *info) {
	/* normalize width */

	if(info->width == INT_MIN) 
		info->width = 0;
	if(info->width < 0) {
		info->flags['-'] = 1;
		info->width = -info->width;
	}

	if(!info->flags['-'])
		PAD(info->width - 1, ' ');

	info->put((unsigned char)va_arg(*info->app, int), info->put_cl);

	if(info->flags['-']) 
		PAD(info->width - 1, ' ');

	return;
}

/* ------------------------------------------------------------------- */

/* pass the buck here to snprintf. This is fine for us, because 
   we're not making much use of floating point.
 */

static void
cvt_f(fmt_code_info_t *info) {
	char buf[DBL_MAX_10_EXP + 1 + 1 + 99 + 1];

	if(info->prec < 0)
		info->prec = 6;
	if(info->code == 'g' && info->prec == 0)
		info->prec = 1;

	/* format a double argument int buf */

	{
		static char fmt[] = "%.dd?";

		assert(info->prec <= 99);
	
		fmt[4] = info->code;
		fmt[3] = info->prec % 10 + '0';
		fmt[2] = (info->prec/10)%10 + '0';

		/* the machine's libc knows how to do this best. */

		snprintf(buf, sizeof(buf), fmt, va_arg(*info->app, double));

	}

	fmt_putd(buf, strlen(buf), info);

	return;
}

/* ------------------------------------------------------------------- */

void 
fmt_putd(const char *str, int len, fmt_code_info_t *info) {
	int sign; 
	
	assert(str && len >= 0 && info->flags);

	/* normalize width and info->flags */

	/* normalize width */

	if(info->width == INT_MIN) 
		info->width = 0;
	if(info->width < 0) {
		info->flags['-'] = 1;
		info->width = -info->width;
	}

	/* normalize info->flags */

	if(info->prec >= 0)
		info->flags['0'] = 0;

	/* compute the sign */

	if(len > 0 && (*str == '-' || *str == '+')) {
		sign = *str++;
		len--;
	} else if(info->flags['+'])
		sign = '+';
	  else if(info->flags[' '])
		sign = ' ';
	  else
		sign = 0;

	{
		/* emit str justified in width */

		int n;

		if(info->prec < 0)
			info->prec = 1;
		if(len < info->prec) 
			n = info->prec;
		else if(info->prec == 0 && len == 1 && str[0] == '0')
			n = 0;
		else
			n = len;

		if(sign)
			n++;

#define EMIT(sign) if(sign) info->put(sign, info->put_cl)
			
		if(info->flags['-']) {
			EMIT(sign);
		} else if(info->flags['0']) {
			EMIT(sign);
			PAD(info->width - n, '0');
		} else {
			PAD(info->width - n, ' ');
			EMIT(sign);
		}	

#undef EMIT

		PAD(info->prec - len, '0');
	
		/* emit str[0..len-1] */

		{
			int i;
	
			for(i = 0; i < len; i++)
				info->put((unsigned char)*str++, info->put_cl);
		}

		if(info->flags['-'])
			PAD(info->width - n, ' ');
	}
	
	return;	
}

/* ------------------------------------------------------------------- */

#if 0 

static void *
xcalloc(size_t nm, size_t size) {
	void *b = calloc(nm, size);

	assert(b);

	return(b);
}

#endif

/* ------------------------------------------------------------------- */

static void *
xalloc(size_t s) {
	void *b = malloc(s);

	assert(b);

	return(b);
}

/* ------------------------------------------------------------------- */

static void *
xrealloc(void *ptr, size_t n) {
	void *b = realloc(ptr, n);

	assert(b);

	return(b);
}

/* ------------------------------------------------------------------- */
