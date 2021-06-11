#include "firebert.h"
#include "bfmt.h"
#include <ctype.h>

/* ------------------------------------------------------------ */

/*
 * b		signed u8 byte 
 * B		u8 byte
 * h		signed u16 halfword
 * H		u16 halfword
 * l    	signed u32 longword
 * L    	u32 longword
 * q    	signed u64 quadword
 * Q    	u64 quadword
 * S    	buffer
 * P 		allocated buffer
 * O		pointer to buffer memory
 * .		discard byte
 *  
 * [0-9]* 	size
 * #		max size follows
 * x 		little endian on the wire (reswap)
 * &    	save to length register
 * _ 		scan the value but don't save it
 */

int
bscanf(u_char *buf, size_t len, const char *fmt, ...) {
	va_list ap;
	size_t size_reg = 0;
	u_char *cp = buf;
	u_char *ep = &buf[len];
	int ret = 0;

	enum {
		BS_SWAP = 0x1,
		BS_SAVE = 0x2,
		BS_SKIP = 0x5
	};	

	va_start(ap, fmt);

	while(*fmt && cp < ep) {
		if(*fmt == '%') {
			void *spp = NULL;
			unsigned flags = 0;
			unsigned char c;
			size_t n = 0;
			size_t size = 0;
			size_t max_size = ~0;	
			size_t (*fn)(u_int32_t val) = NULL;

			for(c = *++fmt; c && strchr("x&__", c); c = *++fmt) {
				switch(c) {
				case 'x':
					flags |= BS_SWAP;
					break;
				case '&':
					flags |= BS_SAVE;
					break;
				case '_':
					flags |= BS_SKIP;
					break;
				case '+':
					fn = va_arg(ap, void*);
					break;
				}
			}

			for(n = 0; isdigit(*fmt); fmt++) {
				int d = *fmt - '0';
				n = 10 * n + d;		
			}

			if(n) size_reg = n;

			if(*fmt == '#') {
				fmt += 1;
				for(n = 0; isdigit(*fmt); fmt++) {
					int d = *fmt - '0';
					n = 10 * n + d;
				}
	
				if(n) max_size = n;
			}

			switch(tolower(*fmt)) { 
			case 'b': 
			case '.': size = 1; break;       
			case 'h': size = 2; break;
			case 'l': size = 4; break;
			case 'q': size = 8; break;
			case 'p':
			case 'o':
			case 's': size = size_reg; break;
			default:
				assert(!"valid size code");
				break;			       		
			}

			if((cp + size) > ep) 
				break;

			if(flags & BS_SKIP || *fmt == '.') 
				cp += size;
			else {
#define SAVE(t) {					\
	t v = va_arg(ap, t);				\
	spp = v;					\
	memcpy((u_char *)v, cp, size);			\
  	switch(size) {					\
	case 2: *v = ntohs(*v);	break;			\
 	case 4: *v = ntohl(*v);	break;			\
	case 8: *v = ntohll(*v); break;	 		\
	default: break;					\
       	}						\
	if(flags & BS_SWAP) {				\
		switch(size) { 				\
		case 2: *v = swp16(*v); break;		\
		case 4: *v = swp32(*v);	break;		\
		case 8: *v = swp64(*v);	break;		\
		default:				\
			break;				\
		}					\
	}	   					\
	if(flags & BS_SAVE) {				\
		if(fn) size_reg = fn(*v);		\
		else size_reg = *v;			\
	}						\
	cp += size;					\
} break
				switch(*fmt) {
				case 'b': SAVE(char*);
				case 'B': SAVE(u_char*);
				case 'h': SAVE(int16_t*);
				case 'H': SAVE(u_int16_t*);
				case 'l': SAVE(int32_t*);
				case 'L': SAVE(u_int32_t*);
				case 'q': SAVE(int64_t*);
       				case 'Q': SAVE(u_int64_t*);
				case 'O': {
					u_char **sp = va_arg(ap,u_char **);
					*sp = cp;
					cp += size;
					break;
				}
       				case 'P': {
					u_char **sp = va_arg(ap, u_char **);
					*sp = malloc(max_size < size ? max_size : size);
					memcpy(*sp, cp, max_size < size ? max_size : size);
					cp += size;
					break;
				}

				case 'S': {
					u_char *sp = va_arg(ap, u_char *);
					memcpy(sp, cp, max_size < size ? max_size : size);
					cp += size;
					break;       	
				}

				default:	
					assert(!"valid format code");
					break;
				}				

				ret += 1;
			}
		}

		fmt++;
	}

	va_end(ap);
	return(ret);
}

/* ------------------------------------------------------------ */

size_t
bsfmt(u_char *buf, size_t len, const char *fmt, ...) {
	int ret = 0;
	va_list ap;
	u_char *cp = buf, *ep = &buf[len];

	enum { 
		BS_SWAP = 0x1, 
		BS_SKIP = 0x2,
		BS_ARGL = 0x4	       
	};

	va_start(ap, fmt); 

	while(*fmt && cp < ep) {
		unsigned char c;
		u_int64_t val = 0;
		int valset = 0;
		unsigned flags = 0;
		int arg = 0;
	
		if(*fmt == '%') {
			arg = 1;
			fmt++;
		}

		for(c = *fmt; c && strchr("x@_", c); c = *++fmt) {
			switch(c) {
			case 'x': flags |= BS_SWAP; break;
			case '_': flags |= BS_SKIP; break;
			case '@': flags |= BS_ARGL; break;
       			default: assert(0); break;
			}
		}				

		if(!arg) {

			if(*fmt == '\\') {
				u_int64_t n = 0;
				fmt += 1;
				for(n = 0; isxdigit(*fmt); fmt++) {
					int d = *fmt - '0';
					n = 16 * n + d;
				}

				val = n;
				valset = 1;
			} else if(isdigit(*fmt)) {
				u_int64_t n = 0;

				for(n = 0; isdigit(*fmt); fmt++) {
					int d = *fmt - '0';
					n = 10 * n + d;
				}
	
				val = n;
				valset = 1;
			}

			if(valset) {
				int bsz = 32;

				if(*fmt == '.') {
					int n = 0;
					fmt += 1;
				
					for(n = 0; isdigit(*fmt); fmt++) {
						int d = *fmt - '0';
						n = 10 * n + d;
					}

					bsz = n;
				}

				bsz /= 8;
				if((cp + bsz) > ep)
					break;
				switch(bsz) {
#define I(x) (x)
#define WRITENUM(t, f, f2) {             		\
	t v = (t)val;					\
      	v = f(v);					\
	if(flags & BS_SWAP) v = f2(v);			\
	if(!(flags & BS_SKIP)) memcpy(cp, (u_char *)&v, sizeof v);	\
	cp += sizeof v;					\
} break
				case 1: WRITENUM(u_char, I, I);
				case 2: WRITENUM(u_int16_t, htons, swp16);
				case 4: WRITENUM(u_int32_t, htonl, swp32);
				case 8: WRITENUM(u_int64_t, htonll, swp64);
				default:
					break;
				}
			} 
		} else {

       			size_t size_reg = 0;
			size_t n = 0;
			int size = 0;

			/* XXX handle sub-byte */
		
			for(n = 0; isdigit(*fmt); fmt++) {
				int d = *fmt - '0';
				n = 10 * n + d;
			}
	
			size_reg = n;

			switch(tolower(*fmt)) {
			case 'z': 
			case 'b': size = 1; break;
			case 'h': size = 2; break;
			case 'l': size = 4; break;
			case 'q': size = 8; break;
			case 's': size = size_reg;
				  if(flags & BS_ARGL) 
					size = va_arg(ap, size_t);
				  break;
			default:  break;
			}

			if((cp + size) > ep) 
				break;

			switch(*fmt) {
#define BLIT(tt, f, f2) val = (u_int64_t) (va_arg(ap, tt)); WRITENUM(tt, f, f2);  
// XXX this signedness stuff is silly.
			case 'b': val = (u_int64_t)(va_arg(ap, int)); WRITENUM(char, I, I);
			case 'B': val = (u_int64_t)(va_arg(ap, int)); WRITENUM(u_char, I, I);
			case 'h': val = (u_int64_t)(va_arg(ap, int)); WRITENUM(int16_t, htons, swp16);
			case 'H': val = (u_int64_t)(va_arg(ap, int)); WRITENUM(u_int16_t, htons, swp16);
			case 'l': BLIT(int32_t, htons, swp32);
			case 'L': BLIT(u_int32_t, htons, swp32);
			case 'q': BLIT(int64_t, htons, swp64);
			case 'Q': BLIT(u_int64_t, htons, swp64);
			case 'z': *cp++ = 0; break;
			case 'S': {
				u_char *bp = va_arg(ap, u_char *);		      
				if(!(flags & BS_SKIP)) 
					memcpy(cp, bp, size);
				cp += size;				     
			} break;
			default:
				assert(!"valid format character");
				break;
			}

			fmt++;
		}
	}

	if(!*fmt) ret = (size_t)(cp - buf);

	return(ret);
}

/* ------------------------------------------------------------ */

u_int32_t 
ld24(u_char **cp, u_char *ep) { 
	u_int32_t ret = 0;

	if((*cp + 3) <= ep) 
		ret = ((*cp)[0]<<16)|((*cp)[1]<<8)|((*cp)[2]);

	return(ret);
}

/* ------------------------------------------------------------ */

u_int32_t 
ld32(u_char **cp, u_char *ep) {
	u_int32_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 4;
	}

	return(ret);
}

/* ------------------------------------------------------------ */

u_int16_t 
ld16(u_char **cp, u_char *ep) {
	u_int16_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 2;
	}

	return(ret);
}

/* ------------------------------------------------------------ */

u_int64_t 
ld64(u_char **cp, u_char *ep) {
	u_int64_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 8;
	}

	return(ret);
}

/* ------------------------------------------------------------ */

u_int8_t 
ld8(u_char **cp, u_char *ep) {
	u_int8_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		ret = **cp;
		*cp += 1;
	}

	return(ret);
}

/* ------------------------------------------------------------ */

void
st32(u_int32_t x, u_char **cp, u_char *ep) {
	if((*cp + sizeof x) <= ep) {
		memcpy(*cp, &x, sizeof x);
		*cp += 4;
	}
}

/* ------------------------------------------------------------ */

void
st16(u_int16_t x, u_char **cp, u_char *ep) {
	if((*cp + sizeof x) <= ep) {
		memcpy(*cp, &x, sizeof x);
		*cp += 2;
	}
}

/* ------------------------------------------------------------ */

void
st24(u_int32_t x, u_char **cp, u_char *ep) {
	if((*cp + (sizeof x) - 1) <= ep) {
		(*cp)[0] = (x>>16)&0xFF;
		(*cp)[1] = (x>>8)&0xFF;
		(*cp)[2] = (x>>0)&0xFF;
		*cp += 3;
	}
}

/* ------------------------------------------------------------ */

void
st64(u_int64_t x, u_char **cp, u_char *ep) {
	if((*cp + sizeof x) <= ep) {
		memcpy(*cp, &x, sizeof x);
		*cp += 8;
	}
}

/* ------------------------------------------------------------ */

void
st8(u_int8_t x, u_char **cp, u_char *ep) {
	if((*cp + sizeof x) <= ep) {
		**cp = x;
		*cp += 1;
	}
}

/* ------------------------------------------------------------ */

u_int32_t 
nld32(u_char **cp, u_char *ep) {
	u_int32_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 4;
	}

	return(ntohl(ret));
}

/* ------------------------------------------------------------ */

u_int16_t 
nld16(u_char **cp, u_char *ep) {
	u_int16_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 2;
	}

	return(ntohs(ret));
}

/* ------------------------------------------------------------ */

u_int64_t 
nld64(u_char **cp, u_char *ep) {
	u_int64_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 8;
	}

	return(ntohll(ret));
}

/* ------------------------------------------------------------ */

u_int8_t 
nld8(u_char **cp, u_char *ep) {
	u_int8_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		ret = **cp;
		*cp += 1;
	}

	return(ret);
}

/* ------------------------------------------------------------ */

u_int32_t 
lld32(u_char **cp, u_char *ep) {
	u_int32_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 4;
	}

	return(ltobl(ret));
}

/* ------------------------------------------------------------ */

u_int16_t 
lld16(u_char **cp, u_char *ep) {
	u_int16_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 2;
	}

	return(ltobs(ret));
}

/* ------------------------------------------------------------ */

u_int64_t 
lld64(u_char **cp, u_char *ep) {
	u_int64_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		memcpy(&ret, *cp, sizeof ret);
		*cp += 8;
	}

	return(ltobll(ret));
}

/* ------------------------------------------------------------ */

u_int8_t 
lld8(u_char **cp, u_char *ep) {
	u_int8_t ret = 0;
	
	if((*cp + sizeof ret) <= ep) {
		ret = **cp;
		*cp += 1;
	}

	return(ret);
}
