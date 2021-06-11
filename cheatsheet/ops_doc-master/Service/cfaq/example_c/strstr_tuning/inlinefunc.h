#ifndef __INLINE_FUNC_HEADER__
#define __INLINE_FUNC_HEADER__
static const unsigned int magic_bits = 0x7efefeffL;
static inline int haszerobyte(unsigned int a)
{
register unsigned long himagic = 0x80808080L;
register unsigned long lomagic = 0x01010101L;
	//return ((((a+ magic_bits) ^ ~a) & ~magic_bits));
	return ((a- lomagic) & himagic);
}
static inline long long haszerobytel(unsigned long long a)
{
register unsigned long long himagic = 0x8080808080808080L;
register unsigned long long lomagic = 0x0101010101010101L;
	//return ((((a+ magic_bits) ^ ~a) & ~magic_bits));
	return ((a- lomagic) & himagic);
}
#endif
