
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

#include "assert_module.h"

/* This test case will fail but the assert is caught by run_tests() and the next test is executed. */
static void increment_value_fail(void **state) 
{
    (void) state;
    
	int value=3;
	increment_value(&value);   //success
	
    //increment_value(NULL);   //failed
}

/* This test case succeeds since increment_value() asserts on the NULL pointer. */
static void increment_value_assert(void **state)
{
    (void) state;

    expect_assert_failure(increment_value(NULL));
}

static void decrement_value_fail(void **state) 
{
    (void) state;

	//decrement_value_fail()函数中没有assert()，所以测试失败
    expect_assert_failure(decrement_value(NULL));
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(increment_value_fail),
        cmocka_unit_test(increment_value_assert),
        cmocka_unit_test(decrement_value_fail),
    };
    return cmocka_run_group_tests(tests, NULL, NULL);
}
