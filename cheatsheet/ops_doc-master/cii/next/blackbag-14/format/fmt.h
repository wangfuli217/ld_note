#ifndef _FMT_INCLUDED_
#define _FMT_INCLUDED_

/*
 * Dave Hanson's Fmt printf replacement library from CI&I
 *
 * For the most part this is taken directly from the book.
 * The interface is very much like printf --- use  
 * fmt_fprint as fprintf and fmt_vsfmt as snprintf.
 * 
 * -- tqbf
 */

#include <stdarg.h>
#include <stdio.h>

/* --- */

/* add a new code handler */
typedef char *(*simplefmt_t)(void *arg);
void fmt_add(int c, simplefmt_t f);

/* printf() */
void fmt_print(const char *fmt, ...);

/* fprintf(stderr, ...) */
void fmt_eprint(const char *fmt, ...);

/* fprintf() */
void fmt_fprint(FILE *fp, const char *fmt, ...);

/* vfprintf() */
void fmt_vfprint(FILE *fp, const char *fmt, va_list ap);

/* snprintf() / sprintf() */
int fmt_sfmt(char *buf, int size, const char *fmt, ...);

/* vsnprintf() / vsprintf() */
int fmt_vsfmt(char *buf, int size, const char *fmt, va_list ap);

/* asprintf() */
char *fmt_string(const char *fmt, ...);

/* vasprintf() */
char *fmt_vstring(const char *fmt, va_list ap);

typedef struct {
	char *base;
	size_t off;
	size_t len;
} stringvec_t;

/* allocate a stringvec */
stringvec_t *fmt_start(size_t len);

/* pass in a stringvec (on the stack, probably) */
stringvec_t *fmt_starts(stringvec_t *vec, size_t len);

/* build up a string incrementally by using vector realloc idiom */
void fmt_build(stringvec_t *vec, int size, char *fmt, ...);

/* get resultant string */
char *fmt_finalize(stringvec_t *vec, size_t *len);

/* get rid of a stringvec. DO NOT CALL THIS IF YOU ARE HOLDING A 
 * POINTER TO fmt_finalize() RESULTS.
 */
void fmt_release(stringvec_t **vp);

/* get rid of a stringvec but rescue its string value */
char *fmt_convert(stringvec_t **vp);

/* --- */

/* Add new fmt code API */ 

typedef int (*putfunc_t) (int c, void *cl);

typedef struct {
	int                 code;
	void               *cl;
	va_list            *app;
	putfunc_t           put;
	void               *put_cl;
	int                 width;
	int                 prec;
	const char         *arg;
	size_t              arg_len;
	struct cvt_array_t *cvt;
	unsigned char       flags[256];
} fmt_code_info_t;

typedef void (*fmt_t) (fmt_code_info_t *);

typedef struct {
	fmt_t          handler;
	int            arg;
	void          *cl;
	void         (*cl_free)(void *);
} fmt_handler_info_t;

typedef struct cvt_array_t {
     fmt_handler_info_t cvt[256];
} cvt_array_t;

void new_cvt(cvt_array_t *ncvt);

void fmt_puts(const char *, int, fmt_code_info_t *);
void fmt_putd(const char *, int, fmt_code_info_t *);

fmt_handler_info_t fmt_register(int code, fmt_t cvt);
fmt_handler_info_t fmt_register_specific(cvt_array_t *cvt, int code, fmt_t);
fmt_handler_info_t fmt_register_verbose(int code, fmt_handler_info_t);
fmt_handler_info_t fmt_register_verbose_specific(cvt_array_t *cvt, int code, fmt_handler_info_t);

void fmt_fmt(putfunc_t put, void *cl, const char *fmt, ...);
void fmt_vfmt(putfunc_t put, void *cl, const char *fmt, va_list ap);

/* Pass the formatter array in with the rest of the args. This
 * was added so that a class wrapper for fmt that encapsulated
 * local extensions could be written. 
 */

char *fmt_vstring_specific(cvt_array_t *cvt, const char *fmt, va_list ap);
char *fmt_string_specific(cvt_array_t *cvt, const char *fmt, ...);
int fmt_vsfmt_specific(cvt_array_t *cvt, char *buf, int size, const char *fmt, va_list ap);
int fmt_sfmt_specific(cvt_array_t *cvt, char *buf, int size, const char *fmt, ...);
void fmt_fprint_specific(cvt_array_t *cvt, FILE *fp, const char *fmt, ...);
void fmt_eprint_specific(cvt_array_t *cvt, const char *fmt, ...);
void fmt_print_specific(cvt_array_t *cvt, const char *fmt, ...);
void fmt_vfmt_specific(cvt_array_t *cvt, putfunc_t put, void *cl, const char *fmt, va_list ap);
void fmt_fmt_specific(cvt_array_t *cvt, putfunc_t put, void *cl, const char *fmt, ...);

#endif
