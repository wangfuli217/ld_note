#include "test1.h"
#include "assert.h"

static int flag = 0;

SUITE_SETUP {
    assert(flag == 0);
    flag = 1;
}

SUITE_TEARDOWN {
    assert(flag == 1);
    flag = 0;
}

SUITE_TEST(success) {
    test_assert(flag);
    return TEST_SUCCESS;
}

SUITE_TEST(failure) {
    test_assert(flag);
    return TEST_SUCCESS;
}

SUITE_START(Naked)
    SUITE_ADD(success, NULL);
    SUITE_ADD(failure, NULL);
    SUITE_ADD(success, "Slow");
    SUITE_ADD(failure, "Fast");
SUITE_END

unsigned nakedMain() {

    Naked();

    SUITE_RUN(NULL, TestSuite_All);

    return TEST_SUCCESS;
}