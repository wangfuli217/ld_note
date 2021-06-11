#ifndef UASN1_INCLUDED
#define UASN1_INCLUDED

#include "pair.h"

#define		ASN1_CLASSES					\
		X(U,			0x0)			\
       		X(A,			0x1)			\
		X(C,     		0x2)			\
		X(P,     		0x3)			
#undef		X
#define		X(x, y)		ASN1_##x = y,
enum {
		ASN1_CLASSES
};

static const int ASN1_PRIMITIVE =	0;
static const int ASN1_CONSTRUCTED = 	1;

#define		ASN1_TAGS					\
		X(EOC,			0x0)			\
       		X(BOOLEAN,		0x1)			\
		X(INTEGER,     		0x2)			\
		X(BITSTRING,   		0x3)			\
		X(OCTETSTRING, 		0x4)			\
		X(NULL,			0x5)			\
		X(OID,			0x6)			\
       		X(DESCRIPTOR,		0x7)			\
       		X(EXTERNAL,    		0x8)			\
       		X(REAL,    		0x9)			\
       		X(ENUMERATED,          	0xA)			\
       		X(UTF8STRING,  		0xC)			\
		X(SEQUENCE,    		0x10)			\
		X(SSET,			0x11)			\
		X(NUMSTRING,   		0x12)			\
		X(PRINTABLESTRING,     	0x13)			\
		X(T61STRING,     	0x14)			\
		X(VIDEOTEXSTRING,     	0x15)			\
		X(IA5STRING,     	0x16)			\
		X(UTCTIME,     		0x17)			\
		X(TIMESTRING,  		0x18)			\
		X(STRING,      		0x1B)			
#undef		X
#define		X(x, y)		ASN1_##x = y,
enum {
		ASN1_TAGS
};

typedef struct asn_s asn_t;

asn_t *		asn_reader(u_char *bp, u_char *ep);
asn_t *		asn_writer(u_char *bp, u_char *ep);
int		asn_over(asn_t *a);
void		asn_unbound(asn_t *a, u_char *ep);
u_char *	asn_mark(asn_t *a);
u_char *	asn_bound(asn_t *a, size_t sz);
void		asn_write_tag(asn_t *a, u_int32_t tag);
int		asn_read_tag(asn_t *a);
void		asn_write_id(asn_t *a, int class, int constructed, u_int32_t tag);
int		asn_read_id(asn_t *a, int *class, int *constructed);
void		asn_write_length(asn_t *a, u_int32_t len);
void		asn_write_undef(asn_t *a);
void		asn_write_term(asn_t *a);
ssize_t 	asn_read_length(asn_t *a);
int		asn_is_term(asn_t *a);
void		asn_read_term(asn_t *a);
void		asn_write_bool(asn_t *a, int v);
int		asn_read_bool(asn_t *a);
void		asn_write_int(asn_t *a, int64_t v);
int64_t		asn_read_int(asn_t *a);
void		asn_write_bits(asn_t *a, u_char *bits, int count);
pair_t		asn_read_bits(asn_t *a);
void		asn_write_string(asn_t *a, u_char *bp, u_char *ep);
pair_t		asn_read_string(asn_t *a);
void		asn_write_oid(asn_t *a, u_int32_t *arcs, size_t nids);
pair_t 		asn_read_oid(asn_t *a);
pair_t		asn_encoding(asn_t *a);
void		asn_release(asn_t **app);

const char *	asn_strclass(u_int32_t op);
const char *	asn_strtag(u_int32_t op);

#endif
