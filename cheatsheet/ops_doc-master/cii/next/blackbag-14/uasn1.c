#include "firebert.h"
#include "uasn1.h"
#include "log.h"

struct asn_s {
	u_char *bp;
	u_char *cp;
	u_char *ep;
};

// ------------------------------------------------------------ 

pair_t 
asn_encoding(asn_t *a) {
	pair_t ret;
	ret.key = a->cp;
	ret.value = a->ep;
	return(ret);
}

// ------------------------------------------------------------ 

asn_t *
asn_reader(u_char *bp, u_char *ep) {
	asn_t *a = malloc(sizeof(*a));
	a->bp = bp;
	a->ep = ep;
	a->cp = bp;
	return(a);
}

// ------------------------------------------------------------ 

asn_t *
asn_writer(u_char *bp, u_char *ep) {
	asn_t *a = malloc(sizeof(*a));
	a->bp = bp;
	a->ep = ep;
	a->cp = ep;
	return(a);
}

// ------------------------------------------------------------ 

void
asn_release(asn_t **app) {
	asn_t *ap = *app;
	*app = 0;
	free(ap);
}

// ------------------------------------------------------------ 

static inline int
_under(asn_t *a) {
	return(!(a->cp >= a->bp));
}

// ------------------------------------------------------------ 

static inline int
_over(asn_t *a) {
	return(!(a->cp < a->ep));
}

// ------------------------------------------------------------ 

u_char *
asn_mark(asn_t *a) {
	return(a->cp);
}

// ------------------------------------------------------------ 

int
asn_over(asn_t *a) {
	return(_over(a));
}

// ------------------------------------------------------------ 

/* writes go backwards through the buffer. every time we write 
 * something, the cursor is left where the length should go.
 */
static inline void
_outb(asn_t *a, u_char b) {
	if(!_under(a)) {
		a->cp -= 1;
	       	a->cp[0] = b;
	}       
}

// ------------------------------------------------------------ 

static inline int
_inb(asn_t *a) {
	int ret = -1;
	if(!_over(a)) {
		ret = a->cp[0];
		a->cp += 1;
	}
	return(ret);	       
}

// ------------------------------------------------------------ 

void
asn_unbound(asn_t *a, u_char *ep) {
	a->ep = ep;
}

// ------------------------------------------------------------ 

u_char *
asn_bound(asn_t *a, size_t sz) {
	u_char *ret = a->ep;
	a->ep = a->cp + sz;
	
	if(_over(a)) {
		a->ep = ret;
		ret = NULL;
	}

	return(ret);
}

// ------------------------------------------------------------ 

void
asn_write_tag(asn_t *a, u_int32_t tag) {
	_outb(a, ((u_char)tag) & 0x7f /* EOT --- "last" byte, LSB */);

	for(tag >>= 7; tag; tag >>= 7) 
		_outb(a, ((u_char)tag & 0x7f) | 0x80 /* no EOT */);
}

// ------------------------------------------------------------ 

int
asn_read_tag(asn_t *a) {
	int ret = -1;

	if(!_over(a)) {
		u_char b = 0;
		ret = 0;

		do {
			ret = (ret << 7) | ((b = _inb(a)) & 0x7F);
		} while(!_over(a) && (b & 0x80) == 0x80);
	}

	return(ret);
}

// ------------------------------------------------------------ 

void
asn_write_id(asn_t *a, int class, int constructed, u_int32_t tag) {
	u_int32_t t = tag;

	if(t > 31) {
		asn_write_tag(a, tag);
		t = 31;
	}
		
	_outb(a, (class << 6)|(constructed << 5)|t);
}

// ------------------------------------------------------------ 

int
asn_read_id(asn_t *a, int *class, int *constructed) {
	int ret = -1;

	if(!_over(a)) {
		u_char b = _inb(a);
		*class = (b>>6)&3;
		*constructed = (b>>5)&1;
		ret = b & 31;
		if(ret == 31)
			ret = asn_read_tag(a);
	}

	return(ret);
}

// ------------------------------------------------------------ 

/* length encoding in ASN.1 is a huge pain in the ass 
 */
void
asn_write_length(asn_t *a, u_int32_t len) {
	u_char h = 0;       

	if(len <= 127) {
		h = len;
	} else 
		while(len) {
			_outb(a, (u_char)len);
			len >>= 8;
			h = 128 | ((h & 0x7F) + 1);
		}

	_outb(a, h);
}

// ------------------------------------------------------------ 

void
asn_write_undef(asn_t *a) {
	_outb(a, 0x80);
}

// ------------------------------------------------------------ 

void
asn_write_term(asn_t *a) {
	_outb(a, 0);
	_outb(a, 0);
}

// ------------------------------------------------------------ 

/* -1 in this case means undefined and it can happen normally
 */
ssize_t 
asn_read_length(asn_t *a) {
	ssize_t ret = -1;
	if(!_over(a)) {
		u_char b = _inb(a);
		if(b != 0x80) {
			if(b <= 127) {
				ret = b;
			} else {
				int cnt = b & 127;
				ret = 0;
				while(cnt--) 
					ret = (ret << 8) | _inb(a);
			}
		}
	}
	return(ret);
}

// ------------------------------------------------------------ 

int
asn_is_term(asn_t *a) {
	int ret = 0;

	if(!_over(a)) {
		if(_inb(a) == 0) {
			if(!_over(a)) {
				if(_inb(a) == 0) {
					a->cp -= 2;
					ret = 1;
				}
			}
		} else
			a->cp -= 1;
	}

	return(ret);
}

// ------------------------------------------------------------ 

void
asn_read_term(asn_t *a) {
	_inb(a);
	_inb(a);
}

// ------------------------------------------------------------ 

void
asn_write_bool(asn_t *a, int v) {
	_outb(a, v ? 0xFF : 0);
}

// ------------------------------------------------------------ 

int
asn_read_bool(asn_t *a) {
	switch(_inb(a)) {
	case 0xFF:
		return 1;
	case 0:
		return 0;
	default:
		break;
	}

	return(-1);
}

// ------------------------------------------------------------ 

/* integer encoding in ASN.1 is a huge pain in the ass 
 */
void
asn_write_int(asn_t *a, int64_t v) {
	u_char b = 0;

	if(v < 0) {
		do {
			b = (u_char) v;
			v >>= 8;
			_outb(a, b);
		} while(v != -1 || (b&0x80) != 0x80);
	} else {
		do {
			b = (u_char) v;
			v >>= 8;
			_outb(a, b);
		} while(v || (b&0x80));
	}	
}

// ------------------------------------------------------------ 

int64_t
asn_read_int(asn_t *a) {
	int64_t ret = -666;

	if(!_over(a)) {
		ret = 0;
		do { 
			ret = (ret << 8) | _inb(a);
		} while(!_over(a));
	}

	return(ret);
}

// ------------------------------------------------------------ 

void
asn_write_bits(asn_t *a, u_char *bits, int count) {
	size_t buflen = count / 8;
	u_char unused = 8 - (count % 8);
	u_char *out = &bits[buflen];

	if(unused == 8) unused = 0;

	if(unused)
		out++;

	while(out >= bits) 
		_outb(a, --(*--out));

	_outb(a, unused);
}

// ------------------------------------------------------------ 

pair_t
asn_read_bits(asn_t *a) {
	pair_t ret = { NULL, NULL };

	return(ret); /* XXX broken */

	if(!_over(a)) {
		int unused = _inb(a);
		size_t l = 0;

		if(!_over(a)) {
			u_char *rb = malloc((size_t)(a->ep - a->cp)), *cp = rb;

			while(!_over(a)) 
				*cp++ = _inb(a);

			l = ((size_t)(cp - rb) * 8) - unused;

			ret.key = rb;
			ret.value = v2p(l);			
		}
	}

	return(ret);
}

// ------------------------------------------------------------ 

void
asn_write_string(asn_t *a, u_char *bp, u_char *ep) {
	for(ep -= 1; ep >= bp; ep--)
		_outb(a, *ep);
}

// ------------------------------------------------------------ 

pair_t
asn_read_string(asn_t *a) {
	pair_t ret = { NULL, NULL };

	if(!_over(a)) {
		u_char *cp = NULL;
		size_t l = 0;
		ret.key = malloc((size_t)(a->ep - a->cp));
		cp = ret.key;

		while(!_over(a)) 
			*cp++ = _inb(a);

		l = (size_t)(cp - ((u_char*) (ret.key)));
		ret.value = v2p(l);
	}

	return(ret);
}

// ------------------------------------------------------------ 

static void
_outarc(asn_t *a, u_int32_t to) {
	u_char last = to & 127;

	_outb(a, last);
		
	for(to >>= 7; to; to >>= 7) {		
		_outb(a, (to&127)|0x80);
	}

}

// ------------------------------------------------------------ 

static u_int32_t 
_inarc(asn_t *a) {
	u_int32_t ret = 0;

	while(!_over(a)) {
		u_char b = _inb(a);
		ret = (ret << 7) | (b & 0x7F);
		if((b & 0x80) != 0x80)
			break;
	}

	return(ret);	
}

// ------------------------------------------------------------ 

void
asn_write_oid(asn_t *a, u_int32_t *arcs, size_t nids) {
	if(nids >= 2) {
		size_t i = 0;
		/* compress the first 2 arcs */
		u_int32_t carc = arcs[0] * 40;
		carc += arcs[1];

		for(i = nids - 1; i > 1; i--) 
			_outarc(a, arcs[i]);

		_outarc(a, carc);
	} else 
		/* iso.org.you, bitch */;
}

// ------------------------------------------------------------ 

pair_t 
asn_read_oid(asn_t *a) {
	pair_t ret = { NULL, NULL };

	if(!_over(a)) {
		static u_int32_t oidbuf[1024]; // cheat
		int i = 0;

		/* first 2 arcs are compressed 
		 */
		u_int32_t carc = _inarc(a);

		if(carc < 40) {
			oidbuf[i++] = 0;
			oidbuf[i++] = carc;
		} else if(carc < 80) { 
			oidbuf[i++] = 1;
			oidbuf[i++] = carc - 40;
		} else {
			oidbuf[i++] = 2;
			oidbuf[i++] = carc - 80;
		}

		while(!_over(a)) 
			oidbuf[i++] = _inarc(a);

		ret.key = malloc(sizeof carc * i);
		memcpy(ret.key, oidbuf, sizeof carc * i);
		ret.value = v2p(i);
	}

	return(ret);
}

// ------------------------------------------------------------ 

#undef  X
#define X(x, y) { y, #x },

const char *
asn_strtag(u_int32_t op) {
	static char buf[255];
	char *ret = NULL;
	int i = 0;

	static struct stropcode { 
		u_int32_t c;
		char *n;
	} strops[] = {
		ASN1_TAGS
		{ 0xFF, NULL } 
	};
       
	for(i = 0; strops[i].n && !ret; i++) 
		if(strops[i].c == op)
			ret = strops[i].n;

	if(!ret) {
		fmt_sfmt(buf, 255, "unknown tag 0x%x", op);
		ret = buf;
	}

	return(ret);
}

// ------------------------------------------------------------ 

const char *
asn_strclass(u_int32_t op) {
	char *ret = NULL;
	int i = 0;

	static struct stropcode { 
		u_int32_t c;
		char *n;
	} strops[] = {
		ASN1_CLASSES
		{ 0xFF, NULL } 
	};
       
	for(i = 0; strops[i].n && !ret; i++) 
		if(strops[i].c == op)
			ret = strops[i].n;

	return(ret ? ret : "bad class");
}
