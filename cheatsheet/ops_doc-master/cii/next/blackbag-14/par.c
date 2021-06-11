#include "firebert.h"
#include "par.h"
#include "bfmt.h"
#include "pair.h"

/* I AM NEVER WRITING THIS PIECE OF CODE AGAIN.
 */

struct prd_s {
	void *d;
	prd_reader r;

	u_char *tbuf;
	u_char *tw;
	size_t  tcur;
	size_t  ttot;		
};

/* ------------------------------------------------------------ */

prd_t *
prd_new(prd_reader h, void *arg) {
	prd_t *p = calloc(1, sizeof(*p));
	p->d = arg;
	p->r = h;
	p->ttot = 1024;	       
	p->tbuf = malloc(p->ttot);
	return(p);
}

/* ------------------------------------------------------------ */

int
prd_consume(prd_t *p, prd_recognizer r, prd_consumer h, void *arg) {
	int ret = -1;
	size_t rv = 0;

	if(1024 > (size_t) (p->ttot - p->tcur)) {
		u_char *nb = NULL;
		size_t  ns = p->ttot + 1024;
		nb = malloc(ns);
		memcpy(nb, p->tbuf, p->tcur);
		p->ttot = ns;
		free(p->tbuf);
		p->tbuf = nb;			
	}

	if((rv = p->r(&(p->tbuf)[p->tcur], 1024, p->d)) > 0) {
		u_char *cp = p->tbuf;
	 	size_t  have = 0;
		size_t  len = 0;
		
		p->tcur += rv;
		have = p->tcur;
		ret = 0;

		while(have && r(cp, have, &len) && len <= have) {
		        h(cp, len, arg);
				
			have -= len;
			cp   += len;
			ret += 1;
		}

		if(have && ret) {
			/* move remainder to front of buf
			 */
			memcpy(p->tbuf, cp, have);
			p->tcur = have;
		} else if(!have) {
			/* reset buf, nothing left 
			 */
			p->tcur = 0;
		}
	}

	return(ret);
}

/* ------------------------------------------------------------ */

void
prd_release(prd_t **pp) {
	prd_t *p = *pp;
	
	free(p->tbuf);
	free(p);

	*pp = 0;		
}


/* ------------------------------------------------------------ */

int
prd_recognize_netbuf(u_char *bp, size_t l, size_t *lp) {
	int ret = 0;
	u_char *ep = &bp[l];

	if(&bp[4] < ep) {
		ret = 1;
		*lp = ld32(&bp, ep);
	}

	return(ret);
}

/* ------------------------------------------------------------ */

struct pwr_s {
	void *d;
	pwr_writer w;

	u_char *tbuf;
	u_char *tw;
	size_t tcur;
	size_t tsz;
};

/* ------------------------------------------------------------ */

pwr_t *
pwr_new(pwr_writer h, void *arg) {
	pwr_t *ret = calloc(1, sizeof(*ret));
	ret->d = arg;
	ret->w = h;
	
	return(ret);
}

/* ------------------------------------------------------------ */

int
pwr_produce(pwr_t *p, u_char *buf, size_t l) {
	u_char *wp = buf;
	size_t  wl = l, rr = 0;		
	int ret = -1;

	if(p->tbuf) {
		if(l > (p->tsz - p->tcur)) {
			u_char *nb = NULL;
			size_t ns = p->tsz;
			size_t wdelt = (size_t) (p->tw - p->tbuf);
			while((ns - p->tcur) < l) ns *= 2;
			p->tsz = ns;
			nb = malloc(p->tsz);
			memcpy(nb, p->tbuf, p->tcur);
			free(p->tbuf);
			p->tbuf = nb;
			p->tw = p->tbuf + wdelt;
		}

		memcpy(&(p->tbuf)[p->tcur], buf, l);
		p->tcur += l;       
		
		wp = p->tw;
		wl = (size_t) (&(p->tbuf)[p->tcur] - wp);		
	}

	if((rr = p->w(wp, wl, p->d)) == wl)
		ret = 0;

	if(rr != -1) {
		if(p->tbuf) {
			p->tw += rr;
			if(p->tw == &(p->tbuf)[p->tcur]) {
				assert(ret == 0);

				free(p->tbuf);
				p->tw = 0;
				p->tsz = 0;
				p->tcur = 0;
			} else
				ret = 1;
		} else if(rr < wl) {
			p->tsz = (wl - rr);
			p->tcur = p->tsz;
			p->tbuf = malloc(p->tsz);
			memcpy(p->tbuf, &wp[rr], p->tsz);		
			p->tw = p->tbuf;
		
			ret = 1;
		}
	}

	return(ret);
}

/* ------------------------------------------------------------ */

int
pwr_flush(pwr_t *p) {
	int ret = 1;

	if(p->tbuf) {
		u_char *wp = p->tw;
		size_t wl = (size_t) (&(p->tbuf)[p->tcur] - wp); 
		size_t rr = 0;

		if((rr = p->w(wp, wl, p->d)) == wl) 
			ret = 0;
		if(rr != -1) {
			p->tw += rr;
			if(p->tw == &(p->tbuf)[p->tcur]) {
				assert(ret == 0);

				free(p->tbuf);
				p->tw = 0;
				p->tsz = 0;
				p->tcur = 0;
			} 
		} else
			ret = -1;
	} else 
		ret = 0;

	return(ret);
}

/* ------------------------------------------------------------ */

void
pwr_release(pwr_t **pp) {
	pwr_t *p = *pp;
	if(p) { 
		free(p->tbuf);
		free(p);
	}

	*pp = 0;
}

/* ------------------------------------------------------------ */

size_t
prd_read_wrapper(u_char *bp, size_t l, void *arg) {
	int fd = (int) p2v(arg);
	return(read(fd, bp, l));
}

/* ------------------------------------------------------------ */

size_t 
pwr_write_wrapper(u_char *bp, size_t l, void *arg) {
	int fd = (int) p2v(arg);
	size_t ret = write(fd, bp, l);
	if(ret == -1) {
		switch(errno) {
		case ENOSPC:
		case EAGAIN:
			ret = 0;
			break;
		default:
			break;
		}
	}

	return(ret);
}
