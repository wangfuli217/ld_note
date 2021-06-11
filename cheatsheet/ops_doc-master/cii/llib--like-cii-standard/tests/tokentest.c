#include <string.h>

#include "token.h"
#include "test.h"
#include "mem.h"
#include "str.h"

unsigned test_token() {
    char s[] = ",,afaf,,bafa,,";

    tokenizer_t tok = tokenizer( s, ",", TOKENIZER_NO_EMPTIES );
    const char* token;
    unsigned    n;
    char** splitbuf;
    size_t size;

    n = 0;
    while ((token = tokenize( &tok )) != NULL) {
        n += 1;
    }
    test_assert(n == 2);

    strcpy(s, ",,afaf,,bafa,,");
    tok = tokenizer( s, ",", TOKENIZER_EMPTIES_OK );
    n = 0;
    while ((token = tokenize( &tok )) != NULL) {
        n += 1;
    }
    test_assert(n == 7);

    tok = tokenizer("", ",", TOKENIZER_NO_EMPTIES );
    n = 0;
    while ((token = tokenize( &tok )) != NULL) {
        n += 1;
    }
    test_assert(n == 0);

    strcpy(s, ",,afaf,,bafa,,");
    splitbuf = Str_split(s, ",", TOKENIZER_EMPTIES_OK, &size);
    test_assert(splitbuf);

    FREE(splitbuf);
    test_assert(size == 7);
    return TEST_SUCCESS;
}
