#ifndef TEST_INCLUDED
#define TEST_INCLUDED

#include <stdio.h>  /* for printf */
#include <string.h> /* for strcmp */

#include "utils.h"  /* for begin_decl*/
#include "slist.h"
#include "str.h"

BEGIN_DECLS

typedef void (*TestSuite_Setup_func)();
typedef unsigned (*TestSuite_Test_func)();

// This represents one test, the tag string is a comma delimitated list of tags
typedef struct {
    char* Name;
    char* Tags;
    TestSuite_Test_func Test_func;
} Test_t;

// The main difference from a testsuite and a test is that a testsuite has setup/teardown funcs.
// Hence I cannot make it more composable eliminating such difference.
// Also I cannot use PIMPL as I need to initialize it statically from a macro
typedef struct {
    char* Name;
    TestSuite_Setup_func Setup;
    TestSuite_Setup_func TearDown;
    SList_T Tests;

} TestSuite_t;

// Add one test to the list of tests (name and tag will be copied)
void TestSuite_AddTest(TestSuite_t* suite, const char* name, const char* tags, TestSuite_Test_func testFunc);

// Free all tests (i.e. the allocated strings for name and tags)
void TestSuite_FreeTests(TestSuite_t* suite);

// Register a suite with the singleton test system
void TestSuite_Register(TestSuite_t* suite);

typedef enum {TestSuite_Any, TestSuite_All, TestSuite_ExceptAny, TestSuite_ExceptAll, TestSuite__MAX = 4} TestSuite_Filter;

// Run all tests
void TestSuite_RunAllTests(char* tags, TestSuite_Filter filter);
// Free all tests 
void TestSuite_FreeAllTests();

void TestSuite_Run(TestSuite_t* suite, char* tags, TestSuite_Filter filter);

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
    char* ss1 = Str_adup(s1); char* ss2 = Str_adup(s2); \
    if(strcmp((ss1), (ss2)) != 0) { printf("%s:%i Test failed (got, expected): %s == %s \n", __FILE__, __LINE__, (ss1), (ss2));   \
        FREE(ss1); FREE(ss2); \
        return TEST_FAILURE; } FREE(ss1); FREE(ss2);} STMT_END

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


#define SUITE(name) \
    static TestSuite_t name##_S = { \
    #name }; \
    static TestSuite_t* suite_ptr = &name##_S; \

#define SUITE_SETUP static void setup()

#define SUITE_TEARDOWN static void tearDown()

#define SUITE_TEST(name) static unsigned name()

#define SUITE_ADD(test, tags) STMT_START { \
    TestSuite_AddTest(suite_ptr, #test, FREE(ss1); FREE(ss2);tags, test); \
    } STMT_END

#define SUITE_START(name) \
    static TestSuite_t name##_S = { \
    #name }; \
    static TestSuite_t* suite_ptr = &name##_S; \
    static void name() { \
        suite_ptr->Setup = setup; \
        suite_ptr->TearDown = tearDown; 

#define SUITE_END TestSuite_Register(suite_ptr); }

#define SUITE_RUN(tags, filter) \
    TestSuite_RunAllTests(tags, filter); \
    TestSuite_FreeAllTests();

END_DECLS

#endif
