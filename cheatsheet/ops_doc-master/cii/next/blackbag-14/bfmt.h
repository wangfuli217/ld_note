#ifndef BFMT_INCLUDED
#define BFMT_INCLUDED

#include <stdarg.h>

/*
 * parse fixnums and buffers from a buffer of bytes, a la sscanf();
 * the following format syntax applies:
 *
 *	%<flags*><wirelen*><#maxlen*><typecode>
 *
 * where: 
 * 	flags is any optional combination of:
 *		x -> little endian on the wire (reswap)
 *		& -> this val is also the length of the next buffer
 *		+ -> you will never use this, but, take a 
 *		     ptr to size_t xfrm(u_int32_t val) to retrieve
 *		     size. Added for SMB. 
 * 		_ -> scan the value but don't save it
 *
 * 	wirelen is optionally the byte length of the buffer on the wire
 *
 * 	maxlen is optionally the maximum number of bytes to copy 
 *
 * 	typecode is any one of:
 *		.      	skip this byte
 *		b/B	signed/UNSIGNED byte
 *		h/H	signed/UNSIGNED u16
 *		l/L	signed/UNSIGNED u32
 *		q/Q	signed/UNSIGNED u64
 * 		P	a buffer saved in u_char **arg, allocated with malloc
 * 		O 	a pointer into the parsing buffer via u_char **arg
 *		S	a buffer saved in u_char *arg directly
 *
 *	for P and S, either provide a hardcoded "wirelen" param, or
 *	set the "&" flag on a previous value to get the length to copy.
 * 	
 *	for P and S, you should ALWAYS be setting a #<maxlen>, else
 *	somebody's bullshit packet is going to segfault your code.
 * 
 * 	returns the number of values successfully parsed. 
 */

int bscanf(u_char *buf, size_t len, const char *fmt, ...);

/*
 * the opposite of bscanf: write values out to a buffer
 * 
 * type codes are the same as bscanf, except:
 * 	- no 'P'
 * 	- no '.'
 * 	- new code 'z' writes 1 zero byte
 *
 * flags include:
 * 	- x (reswap)
 *	- _ (skip --- see how big buffer needs to be)
 * 	- @ (read length from next arg)
 * 
 * the 'S' type code is prefixed with a hardcoded length, as in bscanf.
 * 
 * bsfmt also allows you to write hardcoded hex or decimal constants,
 * with the following rules:
 * 
 * 	- hexnums are prefixed with '\\'
 * 
 * 	- output size defaults to 32 bits, is changed via
 * 	  '.<size>'
 * 
 * 	so for example "x\6a.16" will write u_int16_t 0x6a in 
 * 	little-endian.
 */

size_t bsfmt(u_char *buf, size_t len, const char *fmt, ...);

/* because PPC, SPARC, and ARM no-op ntohs/ntohl
 */

#define swp16(x) 	    ((((uint16_t)(x) & 0xff00) >> 8) | \
                             (((uint16_t)(x) & 0x00ff) << 8))

#define swp32(x) 	    ((((uint32_t)(x) & 0xff000000) >> 24) | \
                             (((uint32_t)(x) & 0x00ff0000) >>  8) | \
                             (((uint32_t)(x) & 0x0000ff00) <<  8) | \
                             (((uint32_t)(x) & 0x000000ff) << 24))

#define swp64(x) 	    ((((uint64_t)(x) & 0xff00000000000000ULL) >> 56) | \
                             (((uint64_t)(x) & 0x00ff000000000000ULL) >> 40) | \
                             (((uint64_t)(x) & 0x0000ff0000000000ULL) >> 24) | \
                             (((uint64_t)(x) & 0x000000ff00000000ULL) >>  8) | \
                             (((uint64_t)(x) & 0x00000000ff000000ULL) <<  8) | \
                             (((uint64_t)(x) & 0x0000000000ff0000ULL) << 24) | \
                             (((uint64_t)(x) & 0x000000000000ff00ULL) << 40) | \
                             (((uint64_t)(x) & 0x00000000000000ffULL) << 56))

#if __DARWIN_BYTE_ORDER == __DARWIN_BIG_ENDIAN
#define ntohll(x) (x)
#define htonll(x) (x)
/*
 * need to force the swap for protocols like SMB where the wire order
 * is little-endian; read "big to little short", etc.
 */
#define btols(x) swp16(x)
#define btoll(x) swp32(x)
#define btolll(x) swp64(x)
#define ltobs(x) swp16(x)
#define ltobl(x) swp32(x)
#define ltobll(x) swp64(x)
#else
#define ntohll(x) (x)
#define htonll(x) (x)
#define btols(x) (x)
#define btoll(x) (x)
#define btolll(x) (x)
#define ltobs(x) (x)
#define ltobl(x) (x)
#define ltobll(x) (x)
#endif

/*
 * cursor loads: return the value at specified bit width, increment
 * cp, check against end-ptr (ep = &cp[len]). These functions are 
 * always safe. Check cp <= ep to ensure all loads were within bounds.
 */
u_int8_t	    ld8(u_char **cp, u_char *ep);
u_int16_t	    ld16(u_char **cp, u_char *ep);
u_int32_t	    ld24(u_char **cp, u_char *ep);
u_int32_t	    ld32(u_char **cp, u_char *ep);
u_int64_t	    ld64(u_char **cp, u_char *ep);

/*
 * cursor stores: set the value at specified bit width. As above,
 * safe, checked against end-ptr
 */
void		    st8(u_int8_t val, u_char **cp, u_char *ep);
void		    st16(u_int16_t val, u_char **cp, u_char *ep);
void		    st24(u_int32_t val, u_char **cp, u_char *ep);
void		    st32(u_int32_t val, u_char **cp, u_char *ep);
void		    st64(u_int64_t val, u_char **cp, u_char *ep);

/*
 * NBO/HBO version of loads (returns HBO)
 */
u_int8_t	    nld8(u_char **cp, u_char *ep);
u_int16_t	    nld16(u_char **cp, u_char *ep);
u_int32_t	    nld32(u_char **cp, u_char *ep);
u_int32_t	    nld24(u_char **cp, u_char *ep);
u_int64_t	    nld64(u_char **cp, u_char *ep);

/*
 * NBO/HBO stores (takes HBO, sets NBO)
 */
#define		    nst8(x, y, z)  st8(x, y, z)
#define		    nst16(x, y, z) st16(htons(x), y, z)
#define		    nst24(x, y, z) st24(htonl(x), y, z)
#define		    nst32(x, y, z) st32(htonl(x), y, z)
#define		    nst64(x, y, z) st64(htonll(x), y, z)

/*
 * For SMB and the like, on PPC ntohx is no-op'd so these
 * force the reverse swap on BE arch. Return HBO from LE.
 */
u_int8_t	    lld8(u_char **cp, u_char *ep);
u_int16_t	    lld16(u_char **cp, u_char *ep);
u_int32_t	    lld24(u_char **cp, u_char *ep);
u_int32_t	    lld32(u_char **cp, u_char *ep);
u_int64_t	    lld64(u_char **cp, u_char *ep);

/*
 * HBO/LE stores (take HBO, set LE)
 */
#define		    lst8(x, y, z)  st8(x, y, z)
#define		    lst16(x, y, z) st16(btols(x), y, z)
#define		    lst24(x, y, z) st24(btoll(x), y, z)
#define		    lst32(x, y, z) st32(btoll(x), y, z)
#define		    lst64(x, y, z) st64(btolll(x), y, z)

#endif
