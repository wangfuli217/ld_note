#include <test.h>
#include <mem.h>
#include <except.h>

unsigned test_mem_free() {

    int result = TEST_SUCCESS;

#define TEST_ASSERT(...) \
    TRY { \
        __VA_ARGS__; \
        result = TEST_FAILURE; \
    } EXCEPT(Assert_Failed) { \
    } END_TRY;

#ifndef NDEBUG /* If the non-checking version of the mem library is used, then the code below
                  accesses wrong pointers, hence it crashes as expected*/
    int k, *i = NULL, *j = &k;
    char *str, *mid;

    TEST_ASSERT(
        NEW(i);
        FREE(j);
        );
    FREE(i);

    TEST_ASSERT(
        str = ALLOC(100);
        mid = str + 50;
        FREE(mid);
        );
    FREE(str);

    TEST_ASSERT(
        str = ALLOC(100);
        REALLOC(mid, 200);
        );
    FREE(str);

#endif /*NDEBUG*/
    return result;
}
