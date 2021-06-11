#include <except.h>
#include <log.h>
#include <test.h>

const Except_T test_e = { "Test"};

unsigned f1(const char* data) {
    TRY {
        if(!strcmp(data, "no")) return 2;
        else RAISE_DATA(test_e, data);
        return 1;
    } ELSE {
        RERAISE;
        return 0;
    } END_TRY;
}

unsigned f(const char* data) {
    TRY {
        return f1(data);
    } ELSE {
        RERAISE;
        return 0;
    } END_TRY;

}

unsigned test_except_all() {
    TRY {
        unsigned k = f("test1");
        (void)k; // remove warning of variable not referenced
        return TEST_FAILURE;
    } EXCEPT(test_e) {
        test_assert_str((const char*)EX_DATA, "test1");
        return TEST_SUCCESS;
    } END_TRY;

    TRY {
        unsigned k = f("no");
        unsigned k1 = f("no");
        unsigned r = k + k1;
        (void)r; // remove warning of variable not referenced
        return TEST_SUCCESS;
    } EXCEPT(test_e) {
        return TEST_FAILURE;
    } END_TRY;

    TRY {
        RAISE_DATA(test_e, "blah");
        return TEST_FAILURE;
    } FINALLY {
        test_assert_str((const char*)EX_DATA, "blah");
        return TEST_SUCCESS;
    } END_TRY;

    return TEST_SUCCESS;
}

unsigned test_native_exceptions() {

#ifdef NATIVE_EXCEPTIONS

    Except_hook_signal();
    TRY {
        int a = 42;
        volatile int b = 0;
        log("%i", a / b);
        return TEST_FAILURE;
    } EXCEPT(Native_Exception) {
        log("%s", Except_frame.exception->reason);
        test_assert(1);
    } END_TRY;

    TRY {
        int* a = 0;
        *a = 43;
        log("%i", *a);
        return TEST_FAILURE;
    } EXCEPT(Native_Exception) {
        log("%s", Except_frame.exception->reason);
        test_assert(1);
    } END_TRY;
#endif /*NATIVE_EXCEPTIONS*/

    return TEST_SUCCESS;
}

