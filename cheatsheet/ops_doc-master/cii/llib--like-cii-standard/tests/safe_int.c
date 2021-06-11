#include "safeint.h"
#include "test.h"

#ifdef SAFE_NO_INT
#define test_assert_exi(...) (void) __VA_ARGS__
#else
#define test_assert_exi test_assert_ex
#endif

unsigned test_safe_int() {

    unsigned u = 1;

    safe_cast_us(0);
    safe_cast_us(3u);
    safe_cast_us(INT_MAX);
    test_assert_exi(cast_error, safe_cast_us(INT_MAX + 1u));
    test_assert((signed)(INT_MAX + 1u) < 0);

    safe_cast_su(0);
    safe_cast_su(INT_MAX);
    test_assert_exi(cast_error, safe_cast_su(-1));
    test_assert((unsigned) (signed)(-1) > 0);

    test_assert_exi(cast_error, safe_cast_su(INT_MIN));
    test_assert((unsigned) (signed)(INT_MIN) > 0);

    safe_size(200);
    safe_size(SAFE_SIZE);
    test_assert_exi(overflow_error, safe_size(SAFE_SIZE + 1));

    safe_sum_uu(UINT_MAX - 1, 1);
    safe_sum_uu(UINT_MAX, 0);
    safe_sum_uu(0, 0);
    test_assert_exi(overflow_error, safe_sum_uu(UINT_MAX, 1));
    test_assert_exi(overflow_error, safe_sum_uu(UINT_MAX, UINT_MAX));
    test_assert(UINT_MAX + u < 10);
    test_assert(UINT_MAX + (UINT_MAX - u) < UINT_MAX);

    safe_sub_uu(UINT_MAX, UINT_MAX);
    safe_sub_uu(0, 0);
    test_assert_exi(overflow_error, safe_sub_uu(0, 1));
    test_assert_exi(overflow_error, safe_sub_uu(UINT_MAX -1 , UINT_MAX));
    test_assert(0u - 1u > 10u);
    test_assert((UINT_MAX - 1) - 1u > 10u);

    safe_mul_uu(0, 0);
    safe_mul_uu(UINT_MAX / 10, 10);
    test_assert_exi(overflow_error, safe_mul_uu(UINT_MAX, UINT_MAX));
    test_assert_exi(overflow_error, safe_mul_uu(UINT_MAX, 2));
    test_assert(UINT_MAX * (UINT_MAX*u) < UINT_MAX);
    test_assert((UINT_MAX*u) * 2 < UINT_MAX);

    safe_div_uu(0, 1);
    safe_div_uu(UINT_MAX, UINT_MAX -1);
    test_assert_exi(divide_by_zero, safe_div_uu(UINT_MAX, 0));

    return TEST_SUCCESS;
}