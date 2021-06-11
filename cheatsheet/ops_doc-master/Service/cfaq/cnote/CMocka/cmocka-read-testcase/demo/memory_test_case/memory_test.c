#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

extern void leak_memory(void);
extern void buffer_overflow(void);
extern void buffer_underflow(void);

/* Test case that fails as leak_memory() leaks a dynamically allocated block. */
static void leak_memory_test(void **state)
{
    (void) state; /* unused */

    leak_memory();
}

/* Test case that fails as buffer_overflow() corrupts an allocated block. */
static void buffer_overflow_test(void **state) 
{
    (void) state; /* unused */

    buffer_overflow();
}

/* Test case that fails as buffer_underflow() corrupts an allocated block. */
static void buffer_underflow_test(void **state) 
{
    (void) state; /* unused */

    buffer_underflow();
}

int main(void) 
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(leak_memory_test),
        cmocka_unit_test(buffer_overflow_test),
        cmocka_unit_test(buffer_underflow_test),
    };
    return cmocka_run_group_tests(tests, NULL, NULL);
}
