#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

// 这些函数声明不声明效果都是一样的，个人感觉extern就是告诉看代码的人这个函数在
// 别的文件中定义了，但是编译器傻傻的还是找不到.
extern const char* get_status_code_string(const unsigned int status_code);
extern unsigned int string_to_status_code(const char* const status_code_string);

static void get_status_code_string_test(void **state)
{
    (void) state; /* unused */

    assert_string_equal(get_status_code_string(0), "Address not found");
    assert_string_equal(get_status_code_string(2), "Connection timed out");
}

static void string_to_status_code_test(void **state) 
{
    (void) state; /* unused */

    assert_int_equal(string_to_status_code("Address not found"), 0);
    assert_int_equal(string_to_status_code("Connection timed out"), 2);
}

int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(get_status_code_string_test),
        cmocka_unit_test(string_to_status_code_test),
    };
    return cmocka_run_group_tests(tests, NULL, NULL);
}
