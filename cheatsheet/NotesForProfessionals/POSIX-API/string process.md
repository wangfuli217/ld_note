---
title: 字符串和数学操作
comments: true
---

# 字符判断函数

    int isalnum(int c);
    int isalpha(int c);
    int iscntrl(int c);
    int isdigit(int c);
    int isgraph(int c);
    int islower(int c);
    int isprint(int c);
    int ispunct(int c);
    int isspace(int c);
    int isupper(int c);
    int isxdigit(int c);

    int isascii(int c);
    int isblank(int c);

<!--more-->

    int isalnum_l(int c, locale_t locale);
    int isalpha_l(int c, locale_t locale);
    int isblank_l(int c, locale_t locale);
    int iscntrl_l(int c, locale_t locale);
    int isdigit_l(int c, locale_t locale);
    int isgraph_l(int c, locale_t locale);
    int islower_l(int c, locale_t locale);
    int isprint_l(int c, locale_t locale);
    int ispunct_l(int c, locale_t locale);
    int isspace_l(int c, locale_t locale);
    int isupper_l(int c, locale_t locale);
    int isxdigit_l(int c, locale_t locale);

    int isascii_l(int c, locale_t locale);
    int iswxdigit(wint_t wc);
    int iswctype(wint_t wc, wctype_t desc);
    int iswspace(wint_t wc);
    int iswdigit(wint_t wc);
    int iswcntrl(wint_t wc);
    int iswblank(wint_t wc);
    int iswalpha(wint_t wc);
    int iswalnum(wint_t wc);
    int iswupper(wint_t wc);
    int iswspace(wint_t wc);
    int iswpunct(wint_t wc);
    int iswprint(wint_t wc);
    int iswlower(wint_t wc);
    int iswgraph(wint_t wc);
    int iswdigit(wint_t wc);
    int iswcntrl(wint_t wc);
    int iswalnum(wint_t wc);

# utility

    int toupper(int c);
    int tolower(int c);

    int toupper_l(int c, locale_t locale);
    int tolower_l(int c, locale_t locale);

    #include <wctype.h>

    wint_t towupper(wint_t wc);

    wint_t towupper_l(wint_t wc, locale_t locale);
    #include <wctype.h>

    wint_t towlower(wint_t wc);

    wint_t towlower_l(wint_t wc, locale_t locale);
    wint_t towctrans(wint_t wc, wctrans_t desc);
    wctrans_t wctrans(const char *name);
    int toascii(int c);

    #include <math.h>
    int finite(double x);
    int finitef(float x);
    int finitel(long double x);

    int isinf(double x);
    int isinff(float x);
    int isinfl(long double x);

    int isnan(double x);
    int isnanf(float x);
    int isnanl(long double x);

    double nan(const char *tagp);
    float nanf(const char *tagp);
    long double nanl(const char *tagp);

    int fpclassify(x);
    int isfinite(x);
    int isnormal(x);
    int isnan(x);
    int isinf(x);
    int signbit(x);
    double copysign(double x, double y);
    float copysignf(float x, float y);
    long double copysignl(long double x, long double y);

    #include <stdlib.h>
    int abs(int j);
    long int labs(long int j);
    long long int llabs(long long int j);
    #include <inttypes.h>
    intmax_t imaxabs(intmax_t j);

    int isgreater(x, y);
    int isgreaterequal(x, y);
    int isless(x, y);
    int islessequal(x, y);
    int islessgreater(x, y);
    int isunordered(x, y);

    double nearbyint(double x);
    float nearbyintf(float x);
    long double nearbyintl(long double x);
    double rint(double x);
    float rintf(float x);
    long double rintl(long double x);
    double trunc(double x);
    float truncf(float x);
    long double truncl(long double x);
    double nearbyint(double x);
    float nearbyintf(float x);
    long double nearbyintl(long double x);
    double rint(double x);
    float rintf(float x);
    long double rintl(long double x);
    double round(double x);
    float roundf(float x);
    long double roundl(long double x);
    long int lround(double x);
    long int lroundf(float x);
    long int lroundl(long double x);
    long long int llround(double x);
    long long int llroundf(float x);
    long long int llroundl(long double x);
    long int lrint(double x);
    long int lrintf(float x);
    long int lrintl(long double x);
    long long int llrint(double x);
    long long int llrintf(float x);
    long long int llrintl(long double x);
    double floor(double x);
    float floorf(float x);
    long double floorl(long double x);
    double ceil(double x);
    float ceilf(float x);
    long double ceill(long double x);
    double cabs(double complex z);
    float cabsf(float complex z);
    long double cabsl(long double complex z);

    double fabs(double x);
    float fabsf(float x);
    long double fabsl(long double x);

    #include <stdlib.h>
    int abs(int j);
    long int labs(long int j);
    long long int llabs(long long int j);
    #include <inttypes.h>
    intmax_t imaxabs(intmax_t j);

    #include <complex.h>
    double cimag(double complex z);
    float cimagf(float complex z);
    long double cimagl(long double complex z);

    double hypot(double x, double y);
    float hypotf(float x, float y);
    long double hypotl(long double x, long double y);

    double sqrt(double x);
    float sqrtf(float x);
    long double sqrtl(long double x);

    double cbrt(double x);
    float cbrtf(float x);
    long double cbrtl(long double x);

    double complex csqrt(double complex z);
    float complex csqrtf(float complex z);
    long double complex csqrtl(long double complex z);

    double complex cexp(double complex z);
    float complex cexpf(float complex z);
    long double complex cexpl(long double complex z);

    double complex cpow(double complex x, complex double z);
    float complex cpowf(float complex x, complex float z);
    long double complex cpowl(long double complex x, complex long double z);

    double complex clog(double complex z);
    float complex clogf(float complex z);
    long double complex clogl(long double complex z);

    double complex clog2(double complex z);
    float complex clog2f(float complex z);
    long double complex clog2l(long double complex z);

    double complex clog10(double complex z);
    float complex clog10f(float complex z);
    long double complex clog10l(long double complex z);

    double complex cexp2(double complex z);
    float complex cexp2f(float complex z);
    long double complex cexp2l(long double complex z);

    double pow(double x, double y);
    float powf(float x, float y);
    long double powl(long double x, long double y);

    div_t div(int numerator, int denominator);
    ldiv_t ldiv(long numerator, long denominator);
    lldiv_t lldiv(long long numerator, long long denominator);
    #include <inttypes.h>
    imaxdiv_t imaxdiv(intmax_t numerator, intmax_t denominator);

    double remainder(double x, double y);
    float remainderf(float x, float y);
    long double remainderl(long double x, long double y);
    /* Obsolete synonyms */
    double drem(double x, double y);
    float dremf(float x, float y);
    long double dreml(long double x, long double y);

    double fmod(double x, double y);
    float fmodf(float x, float y);
    long double fmodl(long double x, long double y);

    double remquo(double x, double y, int *quo);
    float remquof(float x, float y, int *quo);
    long double remquol(long double x, long double y, int *quo);

    double logb(double x);
    float logbf(float x);
    long double logbl(long double x);

    double log(double x);
    float logf(float x);
    long double logl(long double x);

    double log10(double x);
    float log10f(float x);
    long double log10l(long double x);

    double log2(double x);
    float log2f(float x);
    long double log2l(long double x);

    double log1p(double x);
    float log1pf(float x);
    long double log1pl(long double x);

    double exp(double x);
    float expf(float x);
    long double expl(long double x);

    double exp2(double x);
    float exp2f(float x);
    long double exp2l(long double x);

    double expm1(double x);
    float expm1f(float x);
    long double expm1l(long double x);

    double exp10(double x);
    float exp10f(float x);
    long double exp10l(long double x);

    int ilogb(double x);
    int ilogbf(float x);
    int ilogbl(long double x);

    double significand(double x);
    float significandf(float x);
    long double significandl(long double x);

    double scalb(double x, double exp);
    float scalbf(float x, float exp);
    long double scalbl(long double x, long double exp);

    float scalblnf(float x, long int exp);
    long double scalblnl(long double x, long int exp);

    double scalbn(double x, int exp);
    float scalbnf(float x, int exp);
    long double scalbnl(long double x, int exp);

    double ldexp(double x, int exp);
    float ldexpf(float x, int exp);
    long double ldexpl(long double x, int exp);

    double modf(double x, double *iptr);
    float modff(float x, float *iptr);
    long double modfl(long double x, long double *iptr);

    double frexp(double x, int *exp);
    float frexpf(float x, int *exp);
    long double frexpl(long double x, int *exp);

    INFINITY
    NAN
    HUGE_VAL
    HUGE_VALF
    HUGE_VALL

# 其它转字符串


# 字符串转其它

    int atoi(const char *nptr);
    long atol(const char *nptr);
    long long atoll(const char *nptr);
    #include <stdlib.h>
    double atof(const char *nptr);

    double strtod(const char *nptr, char **endptr);
    float strtof(const char *nptr, char **endptr);
    long double strtold(const char *nptr, char **endptr);
    unsigned long int strtoul(const char *nptr, char **endptr, int base);
    unsigned long long int strtoull(const char *nptr, char **endptr, int base);
    long int strtol(const char *nptr, char **endptr, int base);
    long long int strtoll(const char *nptr, char **endptr, int base);
    intmax_t strtoimax(const char *nptr, char **endptr, int base);
    uintmax_t strtoumax(const char *nptr, char **endptr, int base);

    #include <stddef.h>
    #include <inttypes.h>
    intmax_t wcstoimax(const wchar_t *nptr, wchar_t **endptr, int base);
    uintmax_t wcstoumax(const wchar_t *nptr, wchar_t **endptr, int base);

    int strfromd(char *restrict str, size_t n, const char *restrict format, double fp);
    int strfromf(char *restrict str, size_t n, const char *restrict format, float fp);
    int strfroml(char *restrict str, size_t n, const char *restrict format, long double fp);

# 字符串操作

    int strcoll(const char *s1, const char *s2);

    int strcmp(const char *s1, const char *s2);
    int strncmp(const char *s1, const char *s2, size_t n);
    int strcasecmp(const char *s1, const char *s2);
    int strncasecmp(const char *s1, const char *s2, size_t n);
    char *strcpy(char *dest, const char *src);
    char *strncpy(char *dest, const char *src, size_t n);

    int bcmp(const void *s1, const void *s2, size_t n);
    void bcopy(const void *src, void *dest, size_t n);
    void bzero(void *s, size_t n);
    void *memccpy(void *dest, const void *src, int c, size_t n);
    void *memchr(const void *s, int c, size_t n);
    int memcmp(const void *s1, const void *s2, size_t n);
    void *memcpy(void *dest, const void *src, size_t n);
    void *memfrob(void *s, size_t n);
    void *memmem(const void *needle, size_t needlelen, const void *haystack, size_t haystacklen);
    void *memmove(void *dest, const void *src, size_t n);
    void *memset(void *s, int c, size_t n);
    char *strcat(char *dest, const char *src);
    char *strncat(char *dest, const char *src, size_t n);

    void swab(const void *from, void *to, ssize_t n);

    void bzero(void *s, size_t n);
    #include <string.h>
    void explicit_bzero(void *s, size_t n);

    #include <strings.h>
    int ffs(int i);
    #include <string.h>
    int ffsl(long int i);
    int ffsll(long long int i);

    #include <strings.h>

    int strcasecmp(const char *s1, const char *s2);
    int strncasecmp(const char *s1, const char *s2, size_t n);
    char *index(const char *s, int c);
    char *rindex(const char *s, int c);
    #include <string.h>

    char *stpcpy(char *dest, const char *src);
    char *strcat(char *dest, const char *src);
    char *strchr(const char *s, int c);
    int strcmp(const char *s1, const char *s2);
    int strcoll(const char *s1, const char *s2);
    char *strcpy(char *dest, const char *src);
    size_t strcspn(const char *s, const char *reject);
    char *strdup(const char *s);
    char *strfry(char *string);
    size_t strlen(const char *s);
    char *strncat(char *dest, const char *src, size_t n);
    int strncmp(const char *s1, const char *s2, size_t n);
    char *strncpy(char *dest, const char *src, size_t n);
    char *strpbrk(const char *s, const char *accept);
    char *strrchr(const char *s, int c);
    char *strsep(char **stringp, const char *delim);
    size_t strspn(const char *s, const char *accept);
    char *strstr(const char *haystack, const char *needle);
    char *strtok(char *s, const char *delim);
    size_t strxfrm(char *dest, const char *src, size_t n);

    char *strdup(const char *s);
    char *strndup(const char *s, size_t n);
    char *strdupa(const char *s);
    char *strndupa(const char *s, size_t n);
    char *stpcpy(char *dest, const char *src);

    char *strstr(const char *haystack, const char *needle);
    char *strcasestr(const char *haystack, const char *needle);
    size_t strspn(const char *s, const char *accept);
    size_t strcspn(const char *s, const char *reject);

# 宽字节操作

    int wcscasecmp(const wchar_t *s1, const wchar_t *s2);
    wchar_t *wcsncpy(wchar_t *dest, const wchar_t *src, size_t n);
    wchar_t *wcscpy(wchar_t *dest, const wchar_t *src);
    wchar_t *wcsdup(const wchar_t *s);
    wchar_t *wcscat(wchar_t *dest, const wchar_t *src);
    wchar_t *wcpcpy(wchar_t *dest, const wchar_t *src);
    wchar_t *wcsncat(wchar_t *dest, const wchar_t *src, size_t n);
    wchar_t *wcsstr(const wchar_t *haystack, const wchar_t *needle);
    wchar_t *wcschr(const wchar_t *wcs, wchar_t wc);

# 宽字节和多字节序列相互转换

## 宽字符和多字节序列相互转换

    size_t wcrtomb(char *s, wchar_t wc, mbstate_t *ps);

## 将宽字符转换为多字节序列

    size_t wcsrtombs(char *dest, const wchar_t **src, size_t len, mbstate_t *ps);

## 将宽字符串转换为多字节序列

    int mbsinit(const mbstate_t *ps);

# 字节序列转换

    bswap_16(x);
    bswap_32(x);
    bswap_64(x);

    #include <endian.h>

    uint16_t htobe16(uint16_t host_16bits);
    uint16_t htole16(uint16_t host_16bits);
    uint16_t be16toh(uint16_t big_endian_16bits);
    uint16_t le16toh(uint16_t little_endian_16bits);

    uint32_t htobe32(uint32_t host_32bits);
    uint32_t htole32(uint32_t host_32bits);
    uint32_t be32toh(uint32_t big_endian_32bits);
    uint32_t le32toh(uint32_t little_endian_32bits);

    uint64_t htobe64(uint64_t host_64bits);
    uint64_t htole64(uint64_t host_64bits);
    uint64_t be64toh(uint64_t big_endian_64bits);
    uint64_t le64toh(uint64_t little_endian_64bits);

# 内存操作

    #include <string.h>
    int memcmp(const void *s1, const void *s2, size_t n);
    int bcmp(const void *s1, const void *s2, size_t n);
    void *memset(void *s, int c, size_t n);
    void *memmove(void *dest, const void *src, size_t n);
    void *memcpy(void *dest, const void *src, size_t n);
    void *mempcpy(void *dest, const void *src, size_t n);
    void *memccpy(void *dest, const void *src, int c, size_t n);
    void *memmem(const void *haystack, size_t haystacklen, const void *needle, size_t needlelen);
    void *memchr(const void *s, int c, size_t n);
    void *memrchr(const void *s, int c, size_t n);
    void *rawmemchr(const void *s, int c);
    void *memfrob(void *s, size_t n);

## 宽字节内存

    int wmemcmp(const wchar_t *s1, const wchar_t *s2, size_t n);
    int wcscmp(const wchar_t *s1, const wchar_t *s2);
    wchar_t *wmemset(wchar_t *wcs, wchar_t wc, size_t n);
    wchar_t *wmemmove(wchar_t *dest, const wchar_t *src, size_t n);
    wchar_t *wmemcpy(wchar_t *dest, const wchar_t *src, size_t n);
    wchar_t *wmempcpy(wchar_t *dest, const wchar_t *src, size_t n);
