/*
 * =====================================================================================
 *
 *       Filename:  lstrstr.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  10/22/2008 12:27:45 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Zhenghua Dai (Zhenghua Dai), djx.zhenghua@gamil.com
 *        Company:  dzh
 *
 * =====================================================================================
 */
#include <stdio.h>
#include <stdlib.h>
#include "inlinefunc.h"
#include <emmintrin.h>
char* lstrchr(const char *str,char c);



size_t strlen_d(const char *str) 
{

	const char *char_ptr=str;
	const unsigned int *longword_ptr;
	register unsigned int longword, himagic, lomagic;

	for (char_ptr = str; ((unsigned int)char_ptr 
				& (sizeof(unsigned int) - 1)) != 0;
			++char_ptr) {
		if (*char_ptr == '\0')
			return char_ptr - str;
	}

	longword_ptr = (unsigned int*)char_ptr;

	himagic = 0x80808080L;
	lomagic = 0x01010101L;

	while (1) {

		longword = *longword_ptr++;

		if (((longword - lomagic) & himagic) != 0) {

			const char *cp = (const char*)(longword_ptr - 1);

			if (cp[0] == 0)
				return cp - str;
			if (cp[1] == 0)
				return cp - str + 1;
			if (cp[2] == 0)
				return cp - str + 2;
			if (cp[3] == 0)
				return cp - str + 3;
		}
	}
}

size_t strlen_l(const char *str) 
{

	const char *char_ptr=str;
	const unsigned long long *longword_ptr;
	register unsigned long long longword, himagic, lomagic;

	for (char_ptr = str; ((unsigned long long)char_ptr 
				& (sizeof(unsigned long long) - 1)) != 0;
			++char_ptr) {
		if (*char_ptr == '\0')
			return char_ptr - str;
	}

	longword_ptr = (unsigned long long*)char_ptr;

	//himagic = 0x80808080L;
	//lomagic = 0x01010101L;

	while (1) {

		longword = *longword_ptr++;

		if (haszerobytel(longword) != 0) {

			const char *cp = (const char*)(longword_ptr - 1);

			if (cp[0] == 0)
				return cp - str;
			if (cp[1] == 0)
				return cp - str + 1;
			if (cp[2] == 0)
				return cp - str + 2;
			if (cp[3] == 0)
				return cp - str + 3;
			if (cp[4] == 0)
				return cp - str + 4;
			if (cp[5] == 0)
				return cp - str + 5;
			if (cp[6] == 0)
				return cp - str + 6;
			if (cp[7] == 0)
				return cp - str + 7;
		}
	}
}
#    define bsf(x) __builtin_ctz(x)
	size_t
rb_strlen(const char *p)
{
	const char *const top = p;
	__m128i c16 = _mm_set1_epi8(0);
	/* 16 byte alignment */
	size_t ip = (size_t)(p);
	size_t n = ip & 15;
	if (n > 0) {
		ip &= ~15;
		__m128i x = *(const __m128i*)ip;
		__m128i a = _mm_cmpeq_epi8(x, c16);
		unsigned int mask = _mm_movemask_epi8(a);
		mask &= -(1 << n);
		if (mask) {
			return bsf(mask) - n;
		}
		p += 16 - n;
	}
	for (;;) {
		__m128i x = *(const __m128i*)&p[0];
		__m128i y = *(const __m128i*)&p[16];
		__m128i a = _mm_cmpeq_epi8(x, c16);
		__m128i b = _mm_cmpeq_epi8(y, c16);
		unsigned int mask = (_mm_movemask_epi8(b) << 16) | _mm_movemask_epi8(a);
		if (mask) {
			return p + bsf(mask) - top;
		}
		p += 32;
	}
}

#if 0
	size_t
rb_strlenSSE(const char *p)
{
	const char *const top = p;
	__m128i c16 = _mm_set1_epi8(0);
	/* 16 byte alignment */
	size_t ip = reinterpret_cast(p);
	size_t n = ip & 15;
	if (n > 0) {
		ip &= ~15;
		__m128i x = *(const __m128i*)ip;
		__m128i a = _mm_cmpeq_epi8(x, c16);
		unsigned long mask = _mm_movemask_epi8(a);
		mask &= 0xffffffffUL << n;
		if (mask) {
			return bsf(mask) - n;
		}
		p += 16 - n;
	}
	/*
	 *         thanks to egtra-san
	 *             */
	assert((reinterpret_cast(p) & 15) == 0);
	if (reinterpret_cast(p) & 31) {
		__m128i x = *(const __m128i*)&p[0];
		__m128i a = _mm_cmpeq_epi8(x, c16);
		unsigned long mask = _mm_movemask_epi8(a);
		if (mask) {
			return p + bsf(mask) - top;
		}
		p += 16;
	}
	assert((reinterpret_cast(p) & 31) == 0);
	for (;;) {
		__m128i x = *(const __m128i*)&p[0];
		__m128i y = *(const __m128i*)&p[16];
		__m128i a = _mm_cmpeq_epi8(x, c16);
		__m128i b = _mm_cmpeq_epi8(y, c16);
		unsigned long mask = (_mm_movemask_epi8(b) << 16) | _mm_movemask_epi8(a);
		if (mask) {
			return p + bsf(mask) - top;
		}
		p += 32;
	}
}
#endif
