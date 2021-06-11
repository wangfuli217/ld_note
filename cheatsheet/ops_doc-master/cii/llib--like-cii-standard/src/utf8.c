#include <stdlib.h>

/* See big description at end of file */
#include "assert.h"
#include "mem.h"
#include "string.h"
#include "utf8.h"
#include "portable.h"
#include "safeint.h"

/* The table below explain most of the below functions
00000000 -- 0000007F: 	0xxxxxxx
00000080 -- 000007FF: 	110xxxxx 10xxxxxx
00000800 -- 0000FFFF: 	1110xxxx 10xxxxxx 10xxxxxx
00010000 -- 001FFFFF: 	11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
*/

Except_T u8_conversion_failed = {"Conversion failed"};

typedef unsigned char Boolean; /* 0 or 1 */
typedef uint32_t UTF32; /* at least 32 bits */
typedef uint16_t UTF16; /* at least 16 bits */
typedef unsigned char UTF8; /* typically 8 bits */

/* Some fundamental constants */
#define UNI_REPLACEMENT_CHAR (UTF32)0x0000FFFD
#define UNI_MAX_BMP (UTF32)0x0000FFFF
#define UNI_MAX_UTF16 (UTF32)0x0010FFFF

typedef enum {
    conversionOK,   /* conversion successful */
    sourceExhausted, /* partial character in source, but hit end */
    targetExhausted, /* insufficient room in target for conversion */
    sourceIllegal  /* source sequence is illegal/malformed */
} ConversionResult;

typedef enum {
    strictConversion = 0,
    lenientConversion
} ConversionFlags;

static const int halfShift  = 10; /* used for shifting by 10 bits */

static const UTF32 halfBase = 0x0010000UL;
static const UTF32 halfMask = 0x3FFUL;

#define UNI_SUR_HIGH_START  (UTF32)0xD800
#define UNI_SUR_HIGH_END    (UTF32)0xDBFF
#define UNI_SUR_LOW_START   (UTF32)0xDC00
#define UNI_SUR_LOW_END     (UTF32)0xDFFF
#define false    0
#define true     1


/*
* Index into the table below with the first byte of a UTF-8 sequence to
* get the number of trailing bytes that are supposed to follow it.
* Note that *legal* UTF-8 values can't have 4 or 5-bytes. The table is
* left as-is for anyone who may want to do such conversion, which was
* allowed in earlier algorithms.
*/
static const char trailingBytesForUTF8[256] = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
};

/*
* Magic values subtracted from a buffer value during UTF8 conversion.
* This table contains as many values as there might be trailing bytes
* in a UTF-8 sequence.
*/
static const UTF32 offsetsFromUTF8[6] = { 0x00000000UL, 0x00003080UL, 0x000E2080UL,
    0x03C82080UL, 0xFA082080UL, 0x82082080UL };

/*
* Once the bits are split out into bytes of UTF-8, this is a mask OR-ed
* into the first byte, depending on how many bytes follow.  There are
* as many entries in this table as there are UTF-8 sequence types.
* (I.e., one byte sequence, two byte... etc.). Remember that sequencs
* for *legal* UTF-8 will be 4 or fewer bytes total.
*/
static const UTF8 firstByteMark[7] = { 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC };

/* The interface converts a whole buffer to avoid function-call overhead.
* Constants have been gathered. Loops & conditionals have been removed as
* much as possible for efficiency, in favor of drop-through switches.
* (See "Note A" at the bottom of the file for equivalent code.)
* If your compiler supports it, the "isLegalUTF8" call can be turned
* into an inline function.
*/

static
ConversionResult ConvertUTF16toUTF8 (
    const UTF16** sourceStart, const UTF16* sourceEnd,
    UTF8** targetStart, UTF8* targetEnd, ConversionFlags flags) {

        ConversionResult result = conversionOK;
        const UTF16* source = *sourceStart;
        UTF8* target = *targetStart;

        while ((sourceEnd != NULL && source < sourceEnd) || (sourceEnd == NULL && *source != 0x0000)) {

            UTF32 ch;
            unsigned short bytesToWrite = 0;
            const UTF32 byteMask = 0xBF;
            const UTF32 byteMark = 0x80;
            const UTF16* oldSource = source; /* In case we have to back up because of target overflow. */
            ch = *source++;

            /* If we have a surrogate pair, convert to UTF32 first. */
            if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END) {
                /* If the 16 bits following the high surrogate are in the source buffer... */
                if (sourceEnd == NULL || source < sourceEnd) {
                    UTF32 ch2 = *source;
                    /* If it's a low surrogate, convert to UTF32. */
                    if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END) {
                        ch = ((ch - UNI_SUR_HIGH_START) << halfShift)
                            + (ch2 - UNI_SUR_LOW_START) + halfBase;
                        ++source;
                    } else if (flags == strictConversion) { /* it's an unpaired high surrogate */
                        --source; /* return to the illegal value itself */
                        result = sourceIllegal;
                        break;
                    }
                } else { /* We don't have the 16 bits following the high surrogate. */
                    --source; /* return to the high surrogate */
                    result = sourceExhausted;
                    break;
                }
            } else if (flags == strictConversion) {
                /* UTF-16 surrogate values are illegal in UTF-32 */
                if (ch >= UNI_SUR_LOW_START && ch <= UNI_SUR_LOW_END) {
                    --source; /* return to the illegal value itself */
                    result = sourceIllegal;
                    break;
                }
            }

            /* Figure out how many bytes the result will require */
            if (ch < (UTF32)0x80) {      bytesToWrite = 1;
            } else if (ch < (UTF32)0x800) {     bytesToWrite = 2;
            } else if (ch < (UTF32)0x10000) {   bytesToWrite = 3;
            } else if (ch < (UTF32)0x110000) {  bytesToWrite = 4;
            } else {       bytesToWrite = 3;
            ch = UNI_REPLACEMENT_CHAR;
            }

            target += bytesToWrite;
            if (target > targetEnd) {
                source = oldSource; /* Back up source pointer! */
                target -= bytesToWrite; result = targetExhausted; break;
            }

            switch (bytesToWrite) { /* note: everything falls through. */
            case 4: *--target = (UTF8)((ch | byteMark) & byteMask); ch >>= 6;
            case 3: *--target = (UTF8)((ch | byteMark) & byteMask); ch >>= 6;
            case 2: *--target = (UTF8)((ch | byteMark) & byteMask); ch >>= 6;
            case 1: *--target =  (UTF8)(ch | firstByteMark[bytesToWrite]);
            default:(void)0;
            }
            target += bytesToWrite;
        }

        *sourceStart = source;
        *targetStart = target;
        return result;
}

/*
* Utility routine to tell whether a sequence of bytes is legal UTF-8.
* This must be called with the length pre-determined by the first byte.
* If not calling this from ConvertUTF8to*, then the length can be set by:
*  length = trailingBytesForUTF8[*source]+1;
* and the sequence is illegal right away if there aren't that many bytes
* available.
* If presented with a length > 4, this returns false.  The Unicode
* definition of UTF-8 goes up to 4-byte sequences.
*/

inline static Boolean isLegalUTF8(const UTF8 *source, int length) {
    UTF8 a;
    const UTF8 *srcptr = source+length;
    switch (length) {
    default: return false;
        /* Everything else falls through when "true"... */
    case 4: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
    case 3: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
    case 2: if ((a = (*--srcptr)) > 0xBF) return false;

        switch (*source) {
            /* no fall-through in this inner switch */
        case 0xE0: if (a < 0xA0) return false; break;
        case 0xED: if (a > 0x9F) return false; break;
        case 0xF0: if (a < 0x90) return false; break;
        case 0xF4: if (a > 0x8F) return false; break;
        default:   if (a < 0x80) return false;
        }

    case 1: if (*source >= 0x80 && *source < 0xC2) return false;
    }
    if (*source > 0xF4) return false;
    return true;
}


/*
* Exported function to return whether a UTF-8 sequence is legal or not.
* This is not used here; it's just exported.
*/
/*
static
Boolean isLegalUTF8Sequence(const UTF8 *source, const UTF8 *sourceEnd) {
    int length = trailingBytesForUTF8[*source]+1;
    if (source+length > sourceEnd) {
        return false;
    }
    return isLegalUTF8(source, length);
}
*/

static
ConversionResult ConvertUTF8toUTF16 (
        const UTF8** sourceStart, const UTF8* sourceEnd,
        UTF16** targetStart, UTF16* targetEnd, ConversionFlags flags) {

    ConversionResult result = conversionOK;
    const UTF8* source = *sourceStart;
    UTF16* target = *targetStart;

    while ((sourceEnd != NULL && source < sourceEnd) || (sourceEnd == NULL && *source != 0x0000)) {
        UTF32 ch = 0;
        unsigned short extraBytesToRead = (short unsigned) trailingBytesForUTF8[*source];
        if (sourceEnd != NULL && source + extraBytesToRead >= sourceEnd) {
            result = sourceExhausted;
            break;
        }

        /* Do this check whether lenient or strict */
        if (! isLegalUTF8(source, extraBytesToRead+1)) {
            result = sourceIllegal;
            break;
        }
        /*
        * The cases all fall through. See "Note A" below.
        */
        switch (extraBytesToRead) {
        case 5: ch += *source++; ch <<= 6; /* remember, illegal UTF-8 */
        case 4: ch += *source++; ch <<= 6; /* remember, illegal UTF-8 */
        case 3: ch += *source++; ch <<= 6;
        case 2: ch += *source++; ch <<= 6;
        case 1: ch += *source++; ch <<= 6;
        case 0: ch += *source++;
        default:(void)0;
        }
        ch -= offsetsFromUTF8[extraBytesToRead];

        if (target >= targetEnd) {
            source -= (extraBytesToRead+1); /* Back up source pointer! */
            result = targetExhausted; break;
        }

        if (ch <= UNI_MAX_BMP) { /* Target is a character <= 0xFFFF */
            /* UTF-16 surrogate values are illegal in UTF-32 */
            if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
                if (flags == strictConversion) {
                    source -= (extraBytesToRead+1); /* return to the illegal value itself */
                    result = sourceIllegal;
                    break;
                } else {
                    *target++ = UNI_REPLACEMENT_CHAR;
                }
            } else {
                *target++ = (UTF16)ch; /* normal case */
            }
        } else if (ch > UNI_MAX_UTF16) {
            if (flags == strictConversion) {
                result = sourceIllegal;
                source -= (extraBytesToRead+1); /* return to the start */
                break; /* Bail out; shouldn't continue */
            } else {
                *target++ = UNI_REPLACEMENT_CHAR;
            }
        } else {
            /* target is a character in range 0xFFFF - 0x10FFFF. */
            if (target + 1 >= targetEnd) {
                source -= (extraBytesToRead+1); /* Back up source pointer! */
                result = targetExhausted; break;
            }
            ch -= halfBase;
            *target++ = (UTF16)((ch >> halfShift) + UNI_SUR_HIGH_START);
            *target++ = (UTF16)((ch & halfMask) + UNI_SUR_LOW_START);
        }
    }
    *sourceStart = source;
    *targetStart = target;
    return result;
}

uint16_t* u8_to_u16(const char* src) {
    size_t len, wlen;
    uint16_t* buf, *start;
    ConversionResult result;

    assert(src);

    len = strlen((const char*)src);

    safe_sum_sisi(len, 1);
    safe_mul_sisi(len + 1, sizeof(UTF16));
    wlen = (len + 1) * sizeof(UTF16);
    buf = ALLOC(wlen);

    start = buf;
    result = ConvertUTF8toUTF16((const UTF8**)(&src), NULL, &buf, buf + wlen, lenientConversion);
    if(result == conversionOK) {
        *buf = '\0';
        REALLOC(start, (size_t)((char*)buf - (char*)start + 2));
        return start;
    } else {
        RAISE_PTR(u8_conversion_failed);
    }
}

size_t u16_strlen(const UTF16* s) {
    size_t n = 0;

    assert(s);

    while(*s++) {
        safe_sum_sisi(n, 1);
        n++;
    }
    return n;
}

char* u16_to_u8(const uint16_t* src) {
    UTF8* start;
    size_t wlen;
    ConversionResult result;
    UTF8* buf;

    assert(src);

    /* . utf16 string has at most N chars (at most because of possible surrogate values
       . each char could be represented as 4 bytes in UTF8
       . hence a buffer with N * 4 should be big enough (excluding the string terminator)

    */
    wlen = u16_strlen(src);
    safe_sum_sisi(wlen, 1);
    safe_mul_sisi(wlen + 1, 4);

    wlen = wlen * 4;
    buf = ALLOC((wlen + 1) * 4);

    start = buf;
    result = ConvertUTF16toUTF8(&src, NULL, &buf, buf + wlen, lenientConversion);

    if(result == conversionOK) {
        *buf = '\0';
        REALLOC(start, (size_t)(buf - start + 1));
        return (char*)start;
    } else {
        RAISE_PTR(u8_conversion_failed);
    }
}


/* is c the start of a utf8 sequence? High 2 bits are 0x or 11*/
#define isutf(c) (((c)&0xC0) != 0x80)

/* returns length of next utf-8 sequence */
static
unsigned u8_seqlen(const char *s)
{
    return (unsigned) trailingBytesForUTF8[(unsigned int)(unsigned char)s[0]] + 1;
}

/* charnum => byte offset */
static
size_t u8_offset(const char *str, unsigned charnum)
{
    size_t offs=0;

    assert(str);

    while (charnum > 0 && str[offs]) {
        /* walk fwd until it find starts of utf seq (by executing subsequent ors if previous failed) */
        (void)(isutf(str[++offs]) || isutf(str[++offs]) ||
               isutf(str[++offs]) || ++offs);
        charnum--;
    }
    return offs;
}

/* byte offset => charnum */
size_t u8_charnum(const char *s, unsigned offset)
{
    size_t charnum = 0, offs=0;
    assert(s);

    while (offs < offset && s[offs]) {
        (void)(isutf(s[++offs]) || isutf(s[++offs]) ||
               isutf(s[++offs]) || ++offs);
        charnum++;
    }
    return charnum;
}

/* number of characters */
size_t u8_strlen_in_chars(const char *s)
{
    size_t count = 0;
    size_t i = 0;
    assert(s);

    while (u8_nextchar(s, &i) != 0) {
        safe_sum_sisi(count, 1);
        count++;
    }

    return count;
}

/* reads the next utf-8 sequence out of a string, updating an index */
uint32_t u8_nextchar(const char *s, unsigned *i)
{
    uint32_t ch = 0;
    int sz = 0;

    // The original code below is buggy if you pass an *i that points to the final 0 in the string
    // Adding this check fixes the problem, but the whole function prototype is error prone
    // There should be a separate way to tell the caller that the string has ended.
    if (s[*i] == 0)
        return 0;

    assert(s);

    do {
        ch <<= 6;
        ch += (unsigned char)s[(*i)++];
        sz++;
    } while (s[*i] && !isutf(s[*i]));
    ch -= offsetsFromUTF8[sz-1];

    return ch;
}

void u8_inc(const char *s, unsigned *i)
{
    assert(s);

    (void)(isutf(s[++(*i)]) || isutf(s[++(*i)]) ||
           isutf(s[++(*i)]) || ++(*i));
}

void u8_dec(const char *s, unsigned *i)
{
    assert(s);

    (void)(isutf(s[--(*i)]) || isutf(s[--(*i)]) ||
           isutf(s[--(*i)]) || --(*i));
}

char *u8_strchr(char *s, uint32_t ch, unsigned *charn)
{
    unsigned i = 0, lasti=0;
    uint32_t c;

    assert(s);
    assert(charn);

    *charn = 0;
    while (s[i]) {
        c = u8_nextchar(s, &i);
        if (c == ch) {
            return &s[lasti];
        }
        lasti = i;
        (*charn)++;
    }
    return NULL;
}

char *u8_memchr(char *s, uint32_t ch, size_t sz, unsigned *charn)
{
    size_t i = 0, lasti=0;
    uint32_t c;
    int csz;

    assert(s);
    assert(charn);

    *charn = 0;
    while (i < sz) {
        c = 0;
        csz = 0;
        do {
            c <<= 6;
            c += (unsigned char)s[i++];
            csz++;
        } while (i < sz && !isutf(s[i]));
        c -= offsetsFromUTF8[csz-1];

        if (c == ch) {
            return &s[lasti];
        }
        lasti = i;
        (*charn)++;
    }
    return NULL;
}

unsigned u8_is_locale_utf8(const char *locale)
{
    /* this code based on libutf8 */
    const char* cp = locale;

    assert(locale);

    for (; *cp != '\0' && *cp != '@' && *cp != '+' && *cp != ','; cp++) {
        if (*cp == '.') {
            const char* encoding = ++cp;
            for (; *cp != '\0' && *cp != '@' && *cp != '+' && *cp != ','; cp++)
                ;
            if ((cp-encoding == 5 && !strncmp(encoding, "UTF-8", 5))
                || (cp-encoding == 4 && !strncmp(encoding, "utf8", 4)))
                return 1; /* it's UTF-8 */
            break;
        }
    }
    return 0;
}

char *u8_sub (const char *s, size_t i, size_t j) {
    char *str, *p;

    assert(s);
    assert(i <= j);

    i = u8_offset(s, i);
    j = u8_offset(s, j);
    p = str = ALLOC(j - i + 1);

    while (i < j)
        *p++ = s[i++];

    *p = '\0';
    return str;
}

char *u8_reverse(const char*s) {
    size_t len;
    char* str, *p;

    assert(s);

    len = strlen(s);
    str = p = ALLOC(len + 1);
    *(str+len) = '\0';

    while(len) {
        const char* r;
        size_t sl;

        u8_dec(s, &len);
        r = s + len;
        sl = u8_seqlen(r);
        memcpy(p, r, sl);
        p += sl;
    }

    return str;

}

unsigned u8_vprintf(const char *fmt, va_list ap)
{
    unsigned sz=0;
    char *buf;
    uint16_t *wcs;
    signed cnt;
    size_t cntsz;

    assert(fmt);

    sz = 512;
    buf = ALLOC(sz);
    cnt = vsnprintf(buf, sz, fmt, ap);

    cntsz = safe_cast_su(cnt);

    safe_sum_sisi(cntsz, 3);
    cntsz += 2;

    if (cntsz >= sz) {
        signed new_cnt;
        size_t new_cntsz;

        REALLOC(buf, cntsz + 1);
        new_cnt = vsnprintf(buf, cntsz, fmt, ap);
        new_cntsz = safe_cast_su(new_cnt);

        assert(new_cntsz <= cntsz + 2);
    }
    wcs = u8_to_u16(buf);
    wprintf(L"%s", (wchar_t*)wcs);

    FREE(buf);
    FREE(wcs);
    return cntsz;
}

unsigned u8_printf(const char *fmt, ...)
{
    unsigned cnt;
    va_list args;

    va_start(args, fmt);

    cnt = u8_vprintf(fmt, args);

    va_end(args);
    return cnt;
}

#if 0

/* assuming src points to the character after a backslash, read an
   escape sequence, storing the result in dest and returning the number of
   input characters processed */
int u8_read_escape_sequence(const char *src, uint32_t *dest);

/* given a wide character, convert it to an ASCII escape sequence stored in
   buf, where buf is "sz" bytes. returns the number of characters output. */
int u8_escape_wchar(char *buf, int sz, uint32_t ch);

/* convert a string "src" containing escape sequences to UTF-8 */
int u8_unescape(char *buf, int sz, char *src);

/* convert UTF-8 "src" to ASCII with escape sequences.
   if escape_quotes is nonzero, quote characters will be preceded by
   backslashes as well. */
int u8_escape(char *buf, int sz, char *src, int escape_quotes);

/* utility predicates used by the above */
int octal_digit(char c);
int hex_digit(char c);

int octal_digit(char c)
{
    return (c >= '0' && c <= '7');
}

int hex_digit(char c)
{
    return ((c >= '0' && c <= '9') ||
            (c >= 'A' && c <= 'F') ||
            (c >= 'a' && c <= 'f'));
}

/* assumes that src points to the character after a backslash
   returns number of input characters processed */
int u8_read_escape_sequence(const char *str, uint32_t *dest)
{
    uint32_t ch;
    char digs[9]="\0\0\0\0\0\0\0\0";
    int dno=0, i=1;

    ch = (uint32_t)str[0];    /* take literal character */
    if (str[0] == 'n')
        ch = L'\n';
    else if (str[0] == 't')
        ch = L'\t';
    else if (str[0] == 'r')
        ch = L'\r';
    else if (str[0] == 'b')
        ch = L'\b';
    else if (str[0] == 'f')
        ch = L'\f';
    else if (str[0] == 'v')
        ch = L'\v';
    else if (str[0] == 'a')
        ch = L'\a';
    else if (octal_digit(str[0])) {
        i = 0;
        do {
            digs[dno++] = str[i++];
        } while (octal_digit(str[i]) && dno < 3);
        ch = strtol(digs, NULL, 8);
    }
    else if (str[0] == 'x') {
        while (hex_digit(str[i]) && dno < 2) {
            digs[dno++] = str[i++];
        }
        if (dno > 0)
            ch = strtol(digs, NULL, 16);
    }
    else if (str[0] == 'u') {
        while (hex_digit(str[i]) && dno < 4) {
            digs[dno++] = str[i++];
        }
        if (dno > 0)
            ch = strtol(digs, NULL, 16);
    }
    else if (str[0] == 'U') {
        while (hex_digit(str[i]) && dno < 8) {
            digs[dno++] = str[i++];
        }
        if (dno > 0)
            ch = strtol(digs, NULL, 16);
    }
    *dest = ch;

    return i;
}


#ifdef __GNUC__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat"
#pragma GCC diagnostic ignored "-Wformat-extra-args"
#endif

int u8_escape_wchar(char *buf, int sz, uint32_t ch)
{
    if (ch == L'\n')
        return snprintf(buf, sz, "\\n");
    else if (ch == L'\t')
        return snprintf(buf, sz, "\\t");
    else if (ch == L'\r')
        return snprintf(buf, sz, "\\r");
    else if (ch == L'\b')
        return snprintf(buf, sz, "\\b");
    else if (ch == L'\f')
        return snprintf(buf, sz, "\\f");
    else if (ch == L'\v')
        return snprintf(buf, sz, "\\v");
    else if (ch == L'\a')
        return snprintf(buf, sz, "\\a");
    else if (ch == L'\\')
        return snprintf(buf, sz, "\\\\");
    else if (ch < 32 || ch == 0x7f)
        return snprintf(buf, sz, "\\x%hhX", (unsigned char)ch);
    else if (ch > 0xFFFF)
        return snprintf(buf, sz, "\\U%.8X", (uint32_t)ch);
    else if (ch >= 0x80 && ch <= 0xFFFF)
        return snprintf(buf, sz, "\\u%.4hX", (unsigned short)ch);

    return snprintf(buf, sz, "%c", (char)ch);
}
#ifdef __GNUC__
#pragma GCC diagnostic pop
#endif

int u8_escape(char *buf, int sz, const  char *src, unsigned escape_quotes)
{
    int c=0, i=0, amt;

    while (src[i] && c < sz) {
        if (escape_quotes && src[i] == '"') {
            amt = snprintf(buf, sz - c, "\\\"");
            i++;
        }
        else {
            amt = u8_escape_wchar(buf, sz - c, u8_nextchar(src, &i));
        }
        c += amt;
        buf += amt;
    }
    if (c < sz)
        *buf = '\0';
    return c;
}

/* convert a string with literal \uxxxx or \Uxxxxxxxx characters to UTF-8
   example: u8_unescape(mybuf, 256, "hello\\u220e")
   note the double backslash is needed if called on a C string literal */
int u8_unescape(char *buf, int sz, char *src)
{
    int c=0, amt;
    uint32_t ch;
    char temp[4];

    while (*src && c < sz) {
        if (*src == '\\') {
            src++;
            amt = u8_read_escape_sequence(src, &ch);
        }
        else {
            ch = (uint32_t)*src;
            amt = 1;
        }
        src += amt;
        amt = u8_wc_toutf8(temp, ch);
        if (amt > sz-c)
            break;
        memcpy(&buf[c], temp, amt);
        c += amt;
    }
    if (c < sz)
        buf[c] = '\0';
    return c;
}

#define UNI_MAX_UTF32 (UTF32)0x7FFFFFFF
#define UNI_MAX_LEGAL_UTF32 (UTF32)0x0010FFFF


/* Keeping these around in case I need to support other conversions*/
ConversionResult ConvertUTF8toUTF32 (
    const UTF8** sourceStart, const UTF8* sourceEnd,
    UTF32** targetStart, UTF32* targetEnd, ConversionFlags flags) {
        ConversionResult result = conversionOK;
        const UTF8* source = *sourceStart;
        UTF32* target = *targetStart;
        while (source < sourceEnd) {
            UTF32 ch = 0;
            unsigned short extraBytesToRead = trailingBytesForUTF8[*source];
            if (source + extraBytesToRead >= sourceEnd) {
                result = sourceExhausted; break;
            }
            /* Do this check whether lenient or strict */
            if (! isLegalUTF8(source, extraBytesToRead+1)) {
                result = sourceIllegal;
                break;
            }
            /*
            * The cases all fall through. See "Note A" below.
            */
            switch (extraBytesToRead) {
            case 5: ch += *source++; ch <<= 6;
            case 4: ch += *source++; ch <<= 6;
            case 3: ch += *source++; ch <<= 6;
            case 2: ch += *source++; ch <<= 6;
            case 1: ch += *source++; ch <<= 6;
            case 0: ch += *source++;
            }
            ch -= offsetsFromUTF8[extraBytesToRead];

            if (target >= targetEnd) {
                source -= (extraBytesToRead+1); /* Back up the source pointer! */
                result = targetExhausted; break;
            }
            if (ch <= UNI_MAX_LEGAL_UTF32) {
                /*
                * UTF-16 surrogate values are illegal in UTF-32, and anything
                * over Plane 17 (> 0x10FFFF) is illegal.
                */
                if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
                    if (flags == strictConversion) {
                        source -= (extraBytesToRead+1); /* return to the illegal value itself */
                        result = sourceIllegal;
                        break;
                    } else {
                        *target++ = UNI_REPLACEMENT_CHAR;
                    }
                } else {
                    *target++ = ch;
                }
            } else { /* i.e., ch > UNI_MAX_LEGAL_UTF32 */
                result = sourceIllegal;
                *target++ = UNI_REPLACEMENT_CHAR;
            }
        }
        *sourceStart = source;
        *targetStart = target;
        return result;
}

ConversionResult ConvertUTF32toUTF8 (
    const UTF32** sourceStart, const UTF32* sourceEnd,
    UTF8** targetStart, UTF8* targetEnd, ConversionFlags flags) {
        ConversionResult result = conversionOK;
        const UTF32* source = *sourceStart;
        UTF8* target = *targetStart;
        while (source < sourceEnd) {
            UTF32 ch;
            unsigned short bytesToWrite = 0;
            const UTF32 byteMask = 0xBF;
            const UTF32 byteMark = 0x80;
            ch = *source++;
            if (flags == strictConversion ) {
                /* UTF-16 surrogate values are illegal in UTF-32 */
                if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
                    --source; /* return to the illegal value itself */
                    result = sourceIllegal;
                    break;
                }
            }
            /*
            * Figure out how many bytes the result will require. Turn any
            * illegally large UTF32 things (> Plane 17) into replacement chars.
            */
            if (ch < (UTF32)0x80) {      bytesToWrite = 1;
            } else if (ch < (UTF32)0x800) {     bytesToWrite = 2;
            } else if (ch < (UTF32)0x10000) {   bytesToWrite = 3;
            } else if (ch <= UNI_MAX_LEGAL_UTF32) {  bytesToWrite = 4;
            } else {       bytesToWrite = 3;
            ch = UNI_REPLACEMENT_CHAR;
            result = sourceIllegal;
            }

            target += bytesToWrite;
            if (target > targetEnd) {
                --source; /* Back up source pointer! */
                target -= bytesToWrite; result = targetExhausted; break;
            }
            switch (bytesToWrite) { /* note: everything falls through. */
            case 4: *--target = (UTF8)((ch | byteMark) & byteMask); ch >>= 6;
            case 3: *--target = (UTF8)((ch | byteMark) & byteMask); ch >>= 6;
            case 2: *--target = (UTF8)((ch | byteMark) & byteMask); ch >>= 6;
            case 1: *--target = (UTF8) (ch | firstByteMark[bytesToWrite]);
            }
            target += bytesToWrite;
        }
        *sourceStart = source;
        *targetStart = target;
        return result;
}

ConversionResult ConvertUTF32toUTF16 (
    const UTF32** sourceStart, const UTF32* sourceEnd,
    UTF16** targetStart, UTF16* targetEnd, ConversionFlags flags) {
        ConversionResult result = conversionOK;
        const UTF32* source = *sourceStart;
        UTF16* target = *targetStart;
        while (source < sourceEnd) {
            UTF32 ch;
            if (target >= targetEnd) {
                result = targetExhausted; break;
            }
            ch = *source++;
            if (ch <= UNI_MAX_BMP) { /* Target is a character <= 0xFFFF */
                /* UTF-16 surrogate values are illegal in UTF-32; 0xffff or 0xfffe are both reserved values */
                if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_LOW_END) {
                    if (flags == strictConversion) {
                        --source; /* return to the illegal value itself */
                        result = sourceIllegal;
                        break;
                    } else {
                        *target++ = UNI_REPLACEMENT_CHAR;
                    }
                } else {
                    *target++ = (UTF16)ch; /* normal case */
                }
            } else if (ch > UNI_MAX_LEGAL_UTF32) {
                if (flags == strictConversion) {
                    result = sourceIllegal;
                } else {
                    *target++ = UNI_REPLACEMENT_CHAR;
                }
            } else {
                /* target is a character in range 0xFFFF - 0x10FFFF. */
                if (target + 1 >= targetEnd) {
                    --source; /* Back up source pointer! */
                    result = targetExhausted; break;
                }
                ch -= halfBase;
                *target++ = (UTF16)((ch >> halfShift) + UNI_SUR_HIGH_START);
                *target++ = (UTF16)((ch & halfMask) + UNI_SUR_LOW_START);
            }
        }
        *sourceStart = source;
        *targetStart = target;
        return result;
}

ConversionResult ConvertUTF16toUTF32 (
    const UTF16** sourceStart, const UTF16* sourceEnd,
    UTF32** targetStart, UTF32* targetEnd, ConversionFlags flags) {
        ConversionResult result = conversionOK;
        const UTF16* source = *sourceStart;
        UTF32* target = *targetStart;
        UTF32 ch, ch2;
        while (source < sourceEnd) {
            const UTF16* oldSource = source; /*  In case we have to back up because of target overflow. */
            ch = *source++;
            /* If we have a surrogate pair, convert to UTF32 first. */
            if (ch >= UNI_SUR_HIGH_START && ch <= UNI_SUR_HIGH_END) {
                /* If the 16 bits following the high surrogate are in the source buffer... */
                if (source < sourceEnd) {
                    ch2 = *source;
                    /* If it's a low surrogate, convert to UTF32. */
                    if (ch2 >= UNI_SUR_LOW_START && ch2 <= UNI_SUR_LOW_END) {
                        ch = ((ch - UNI_SUR_HIGH_START) << halfShift)
                            + (ch2 - UNI_SUR_LOW_START) + halfBase;
                        ++source;
                    } else if (flags == strictConversion) { /* it's an unpaired high surrogate */
                        --source; /* return to the illegal value itself */
                        result = sourceIllegal;
                        break;
                    }
                } else { /* We don't have the 16 bits following the high surrogate. */
                    --source; /* return to the high surrogate */
                    result = sourceExhausted;
                    break;
                }
            } else if (flags == strictConversion) {
                /* UTF-16 surrogate values are illegal in UTF-32 */
                if (ch >= UNI_SUR_LOW_START && ch <= UNI_SUR_LOW_END) {
                    --source; /* return to the illegal value itself */
                    result = sourceIllegal;
                    break;
                }
            }
            if (target >= targetEnd) {
                source = oldSource; /* Back up source pointer! */
                result = targetExhausted; break;
            }
            *target++ = ch;
        }
        *sourceStart = source;
        *targetStart = target;
#ifdef CVTUTF_DEBUG
        if (result == sourceIllegal) {
            fprintf(stderr, "ConvertUTF16toUTF32 illegal seq 0x%04x,%04x\n", ch, ch2);
            fflush(stderr);
        }
#endif
        return result;
}

#endif

/* ---------------------------------------------------------------------

    Conversions between UTF32, UTF-16, and UTF-8.

    Several functions are included here, forming a complete set of
    conversions between the three formats.  UTF-7 is not included
    here, but is handled in a separate source file.

    Each of these routines takes pointers to input buffers and output
    buffers.  The input buffers are const.

    Each routine converts the text between *sourceStart and sourceEnd,
    putting the result into the buffer between *targetStart and
    targetEnd. Note: the end pointers are *after* the last item: e.g.
    *(sourceEnd - 1) is the last item.

    The return result indicates whether the conversion was successful,
    and if not, whether the problem was in the source or target buffers.
    (Only the first encountered problem is indicated.)

    After the conversion, *sourceStart and *targetStart are both
    updated to point to the end of last text successfully converted in
    the respective buffers.

    Input parameters:
    sourceStart - pointer to a pointer to the source buffer.
        The contents of this are modified on return so that
        it points at the next thing to be converted.
    targetStart - similarly, pointer to pointer to the target buffer.
    sourceEnd, targetEnd - respectively pointers to the ends of the
        two buffers, for overflow checking only.

    These conversion functions take a ConversionFlags argument. When this
    flag is set to strict, both irregular sequences and isolated surrogates
    will cause an error.  When the flag is set to lenient, both irregular
    sequences and isolated surrogates are converted.

    Whether the flag is strict or lenient, all illegal sequences will cause
    an error return. This includes sequences such as: <F4 90 80 80>, <C0 80>,
    or <A0> in UTF-8, and values above 0x10FFFF in UTF-32. Conformant code
    must check for illegal sequences.

    When the flag is set to lenient, characters over 0x10FFFF are converted
    to the replacement character; otherwise (when the flag is set to strict)
    they constitute an error.

    Output parameters:
    The value "sourceIllegal" is returned from some routines if the input
    sequence is malformed.  When "sourceIllegal" is returned, the source
    value will point to the illegal value that caused the problem. E.g.,
    in UTF-8 when a sequence is malformed, it points to the start of the
    malformed sequence.

------------------------------------------------------------------------ */


