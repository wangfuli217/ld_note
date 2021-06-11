#include "Bool.hpp"

#include "unity.h"

void test_true() {
	TEST_ASSERT_EQUAL_STRING("true", T->toString().c_str());
}

void test_false() {
	TEST_ASSERT_EQUAL_STRING("false", F->toString().c_str());
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_true);
    RUN_TEST(test_false);
    return UNITY_END();
}
