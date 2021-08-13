#ifndef __TEST_H__KJAHC38DJ__
#define __TEST_H__KJAHC38DJ__

// Starts a testing sesssion
void start_tests(const char* msg);

// Ends a testing session
void end_tests();

// Calls a testing function. The given test function should
// exit the program with an error if the test does not succeed.
void test(void (*test_fun)());

void test_par(void (*test_fun)(), void* param);

#endif
