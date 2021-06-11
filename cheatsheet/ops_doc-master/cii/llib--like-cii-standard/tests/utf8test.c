#include <stdint.h>
#include <string.h>

#include "test.h"
#include "log.h"
#include "locale.h"
#include "str.h"
#include "mem.h"
#include "utf8.h"

int test(char* str) {    
    char* au8buf;
    uint16_t* au16buf;

    /* even chcp 65001 (utf-8) and Lucide Console don't print arabic and chinese
       you need to redirect to a text file to see them.
    */
    au16buf = u8_to_u16(str);
    au8buf  = u16_to_u8(au16buf);

    test_assert_str(au8buf, str);
    log("%s : redirect stderr to  a file with 2> to see utf-8 chars", au8buf);

    FREE(au16buf);
    FREE(au8buf);

    return TEST_SUCCESS;
}

/* Chinese characters for "zhongwen" ("Chinese language"). 2 chars */
static char kChineseSampleText[]     = {-28, -72, -83, -26, -106, -121, 0};

/* Arabic "al-arabiyya" ("Arabic"). */
static char kArabicSampleText[]      = {-40, -89, -39, -124, -40, -71, -40, -79, -40, -88, -39, -118, -40, -87, 0};

/* Spanish word "canon" with an "n" with "~" on top and an "o" with an acute accent. 5 chars*/
static char kSpanishSampleText[]     = {99, 97, -61, -79, -61, -77, 110, 0};

static char kAscii[]                 = "0123456789";

#define mytest(str) if(test(str) == TEST_FAILURE) return TEST_FAILURE;

unsigned test_utf8_roundtrip() {

#ifdef _WIN32 /* windows doesn't support utf-8 locale */
    char* locale = setlocale(LC_ALL, "");
    test_assert(!u8_is_locale_utf8(locale));
    setlocale(LC_ALL, locale);
#endif

    mytest(kChineseSampleText);
    mytest(kArabicSampleText);
    mytest(kSpanishSampleText);

    return TEST_SUCCESS;
}

unsigned test_utf8_len() {
    test_assert_int(u8_strlen_in_chars(kChineseSampleText), 2);
    test_assert_int(u8_strlen_in_chars(kArabicSampleText), 7);
    test_assert_int(u8_strlen_in_chars(kSpanishSampleText), 5);
    return TEST_SUCCESS;
}

#define trev(s, r) t = u8_reverse(s); test_assert_str(t, r); FREE(t);

unsigned test_utf8_rev() {
    char* t;
    char revSpanish[] = {110, -61, -77, -61, -79, 97, 99, 0};
    char revChin[] = {-26, -106, -121, -28, -72, -83 ,0};

    trev("0123", "3210");
    trev("0", "0");
    trev("", "");
    trev(kSpanishSampleText, revSpanish);
    trev(kChineseSampleText, revChin);

    return TEST_SUCCESS;
}

int test_utf8_sub() {
    char* cu = u8_sub(kSpanishSampleText, 2, 4);
    char ce[] = {-61, -79, -61, -77, 0};
    char* au = u8_sub(kAscii, 2, 4);
    char* a = Str_asub(kAscii, 2, 4);

    test_assert_str(au, a);
    test_assert_str(ce, cu);

    FREE(cu);
    FREE(au);
    FREE(a);
    return TEST_SUCCESS;
}
