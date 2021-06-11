#include "format/fmt.h"
#include <stdlib.h>
#include <string.h>

/* -------------------------------------------------------- */

stringvec_t *
fmt_start(size_t len) {
	stringvec_t *v = malloc(sizeof(*v));
	return(fmt_starts(v, len));
}

/* -------------------------------------------------------- */

stringvec_t *
fmt_starts(stringvec_t *v, size_t len) {
	v->base = malloc(len);
	v->len = len;
	v->off = 0;
	v->base[0] = '\0';
	return(v);
}

/* -------------------------------------------------------- */

static void
need(stringvec_t *v, size_t more) {
	while(v->off + more >= v->len) {
		v->len *= 2;
		v->base = realloc(v->base, v->len);
	}
}

/* -------------------------------------------------------- */

void
fmt_build(stringvec_t *v, int len, char *fmt, ...) {
	va_list ap;
	need(v, len);
	va_start(ap, fmt);
	v->off += fmt_vsfmt(&(v->base)[v->off], len, fmt, ap);
	va_end(ap);
}

/* -------------------------------------------------------- */

char *
fmt_finalize(stringvec_t *v, size_t *len) {
	char *ret = v->base;
	if (len)
		*len = v->off;
	memset(v, 0, sizeof(*v));
	return(ret);
}

/* -------------------------------------------------------- */

void
fmt_release(stringvec_t **vp) {
	stringvec_t *v = *vp;
	*vp = NULL;
	
	free(v->base);
	free(v);
}

/* ------------------------------------------------------------ */

char *
fmt_convert(stringvec_t **vp) {
	stringvec_t *v = *vp;     
	size_t l = 0; 
	char *ret = fmt_finalize(v, &l);
	*vp = NULL;
	free(v);
	return(ret);
}
