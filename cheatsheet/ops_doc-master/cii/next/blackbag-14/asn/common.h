#ifndef COMMON_INCLUDED
#define COMMON_INCLUDED

extern u_int32_t 	ASN_Length;
extern int 		ASN_Length_Override;
extern u_int32_t	ASN_Tag;
extern int		ASN_Class;
extern int		ASN_Type;
extern FILE *		ASN_Out;
extern int		ASN_Raw;

char *asnopts(char *inopts);
int   asnopt(int c);

#endif
