#include "firebert.h"
#include "tbuf.h"
#include "util.h"
#include "freelist.h"

freelist_t *F = NULL;

// ------------------------------------------------------------ 

static tbuf_t *_get(void) {
	if(!F)
		F = freelist_new(sizeof(tbuf_t), 10);

	return(freelist_get(F));
}

// ------------------------------------------------------------ 

tbuf_t *
tbuf_init(tbuf_t *r, u_char *data, size_t len) {
	tbuf_t *ret = r;

	if(!data) {
		r->bp = malloc(50);
		r->tp = r->bp;
		r->ep = &(r->tp)[50];
	} else {
		r->bp = bufdup(data, len);
		r->tp = &(r->bp)[len];
		r->ep = r->tp;
	}

	return(ret);
}

// ------------------------------------------------------------ 

tbuf_t *
tbuf_empty(void) { 
	return tbuf_new(NULL, 0);
}

// ------------------------------------------------------------ 

tbuf_t *
tbuf_new(u_char *data, size_t len) {
	tbuf_t *r = _get();

	tbuf_init(r, data, len);

	return(r);
}

// ------------------------------------------------------------ 

void
tbuf_reset(tbuf_t *r) {
	r->tp = r->bp;
}

// ------------------------------------------------------------ 

void
tbuf_cat(tbuf_t *r, u_char *data, size_t len) {
	if((size_t)(r->ep - r->tp) < len) {
		size_t off = (size_t)(r->tp - r->bp);
		size_t tot = (size_t)(r->ep - r->bp);
	
		if(tot < len)
			tot = len;		

		r->bp = realloc(r->bp, tot * 2);
		r->tp = &(r->bp)[off];
		r->ep = &(r->bp)[tot * 2];
	} 

	 if(len == 1) {	
		r->tp[0] = data[0];
		r->tp++;	       
	} else {
		memcpy(r->tp, data, len);
		r->tp += len;
	}
}

// ------------------------------------------------------------ 

void
tbuf_add(tbuf_t *t, tbuf_t *other) { 
	size_t l = 0;
	u_char *buf = NULL;
	if((buf = tbuf_data(other, &l))) { 
		tbuf_cat(t, buf, l);
	}
}

// ------------------------------------------------------------ 

void
tbuf_hash(tbuf_t *t, u_char *out/*20*/) { 
	size_t l = 0;
	u_char *buf = NULL;
	if((buf = tbuf_data(t, &l))) { 
		sha1(buf, l, out);
	}	
}

// ------------------------------------------------------------ 

iopair_t 
tbuf_get(tbuf_t *t) { 
	iopair_t p;
	p.data = tbuf_data(t, &(p.len));
	return(p);
}

// ------------------------------------------------------------ 

void
tbuf_cats(tbuf_t *t, char *str) { 
	tbuf_cat(t, (u_char*)str, strlen(str));
}

// ------------------------------------------------------------ 

u_char *
tbuf_data(tbuf_t *t, size_t *l) {
	if(t) { 
		*l = (size_t)(t->tp - t->bp);
		return(t->bp);
	} else
		return(NULL);
}

// ------------------------------------------------------------ 

size_t
tbuf_length(tbuf_t *t) { 
	if(t) 
		return (size_t)(t->tp - t->bp);
	return(0);
}

// ------------------------------------------------------------ 

u_char *
tbuf_raw(tbuf_t **tp, size_t *l) {
	u_char *ret = tbuf_data(*tp, l);
	(*tp)->bp = NULL;       
	tbuf_release(tp);
	return(ret);
}

// ------------------------------------------------------------ 

void
tbuf_release(tbuf_t **tp) {
	tbuf_t *t = *tp;
	free(t->bp);
	freelist_free(F, (void**)tp);
}

// ------------------------------------------------------------ 

void
tbuf_catp(tbuf_t *t, char *fmt, ...) { 
	va_list ap;
	char buf[4096]; // lame!

	va_start(ap, fmt);

	fmt_vsfmt(buf, 4096, fmt, ap);
	tbuf_cats(t, buf);
}
