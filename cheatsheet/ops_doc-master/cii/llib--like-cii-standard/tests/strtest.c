#include <stddef.h>

#include "str.h"
#include "test.h"
#include "mem.h"

#define tcat(s1, s2, r) t = Str_acat(s1, s2); test_assert_str(t, r); FREE(t);
#define tsub(s, i, j, r) t = Str_asub(s, i, j); test_assert_str(t, r); FREE(t);
#define tcatv(s1, s2, s3, r) t = Str_acatv(s1, s2, s3); test_assert_str(t, r); FREE(t);
#define trev(s, r) t = Str_areverse(s); test_assert_str(t, r); FREE(t);
#define tmap(s, from, to, r) t = Str_amap(s, from, to); test_assert_str(t, r); FREE(t);
#define tasp(r, fmt, ...) t = Str_asprintf(fmt, __VA_ARGS__); test_assert_str(t, r); FREE(t);

unsigned test_str() {
    char* t;

    tcat("ab", "cd", "abcd");
    tcat("ab", "", "ab");
    tcat("", "ab", "ab");
    tcat("", "", "");

    tcatv("ab", "cd", "efg", "abcdefg");
    tcatv("ab", "cd", "", "abcd");
    tcatv("", "ab", "cd", "abcd");
    tcatv("", "", "a", "a");
    tcatv("", "", "", "");

    tsub("01234", 0, 2, "01");
    tsub("01234", 0, 0, "");
    tsub("01234", 0, 1, "0");
    tsub("01234", 4, 5, "4");
    tsub("", 4, 5, "");

    trev("0123", "3210");
    trev("0", "0");
    trev("", "");

    tmap("0123456789", "258", "369", "0133466799");
    tmap("0123456789", "479", "368", "0123356688");

    tasp("blah is very good boy 10", "%s is very good boy %i", "blah", 10);

    return TEST_SUCCESS;
}

unsigned test_str_split() {

    char s[] = ",,afaf,,bafa,,";
    char** p;
    size_t size;

    p = Str_split(s, ",", TOKENIZER_NO_EMPTIES, &size);
    test_assert_str(p[0], "afaf");
    test_assert_str(p[1], "bafa");
    test_assert_int(size, 2);
    FREE(p);

    strcpy(s, "");
    p = Str_split(s, ",", TOKENIZER_NO_EMPTIES, &size);
    test_assert_int(size, 0);
    FREE(p);

    p = Str_split(s, ",", TOKENIZER_EMPTIES_OK, &size);
    test_assert_int(size, 1);
    FREE(p);

    strcpy(s, ",.afaf,f.d");
    p = Str_split(s, ",.", TOKENIZER_NO_EMPTIES, &size);

    test_assert_int(size, 3);
    FREE(p);

    return TEST_SUCCESS;
}
