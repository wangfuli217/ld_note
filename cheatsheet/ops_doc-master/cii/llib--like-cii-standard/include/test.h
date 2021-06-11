#ifndef TEST_INCLUDED
#define TEST_INCLUDED

#include <stdio.h>  /* for printf */
#include <string.h> /* for strcmp */

#include "utils.h"  /* for begin_decl*/

BEGIN_DECLS

#pragma warning (disable:4127) // Conditional expression is constant
#pragma warning (disable:4210) // Function given file scope in test_add

#define TEST_SUCCESS 1
#define TEST_FAILURE 0

#define test_assert(e) STMT_START {                                                                 \
    if((e) == 0) { printf("%s:%i Test failed: " #e "\n", __FILE__, __LINE__);                                                     \
             return TEST_FAILURE; }} STMT_END

#define test_assert_float(exp, prec, got) STMT_START {                                                                 \
    double goti = got, expi = exp; \
    if((goti) < (expi) - (prec) || (goti) > (expi) + (prec)) { printf("%s:%i Test failed(exp, prec, got): (%f, %f, %f)\n", __FILE__, __LINE__, (double)expi, (double)prec, (double)goti);              \
             return TEST_FAILURE; }} STMT_END

#define test_assert_str(s1, s2) STMT_START {                                                        \
    if(strcmp((s1), (s2)) != 0) { printf("%s:%i Test failed (got, expected): %s == %s \n", __FILE__, __LINE__, (s1), (s2));   \
        return TEST_FAILURE; } } STMT_END

#define test_assert_int(i1, i2) STMT_START {                                                        \
    int ii1 = i1, ii2 = i2; \
    if(ii1 != ii2) { printf("%s:%i Test failed (got, expected): %i == %i \n", __FILE__, __LINE__, (ii1), (ii2));   \
        return TEST_FAILURE; } } STMT_END

#define test_assert_ex(which, ...) \
    TRY { \
        __VA_ARGS__; \
        test_assert(((void)#__VA_ARGS__, 0)); \
    } EXCEPT(which) { \
    } END_TRY;

typedef unsigned(*test_func) ();

#define test_add(kind, feature, f) STMT_START { \
    extern unsigned f(); \
    test_addx(kind, feature, f); } STMT_END

#define testsuite_add(name, func) STMT_START { \
    testsuite_setup(); \
    test_add(testsuite_name, name, func); \
    testsuite_teardown(); } STMT_END 

#define testsuite_run(func) STMT_START { \
    extern unsigned func(); \
    func(); } STMT_END

extern void test_addx(char* kind, char* feature, test_func f);
extern unsigned test_run_all();
extern long long test_perf(test_func f);


END_DECLS

#endif

