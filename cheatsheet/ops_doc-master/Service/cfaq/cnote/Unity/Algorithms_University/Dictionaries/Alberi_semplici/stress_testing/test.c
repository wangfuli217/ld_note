#include <stdio.h>
#include <time.h>
#include <math.h>

#include "test.h"

static clock_t start_time;
static unsigned int num_tests;

void start_tests(const char* msg) {
  start_time = clock();
  num_tests = 0;
  printf("Starting tests on:%s\n", msg);
}

// Ends a testing session
void end_tests() {
  double elapsed_time = (clock() - start_time)/(double)CLOCKS_PER_SEC;
  printf("\n%d tests passed in %4.5f seconds\n", num_tests, elapsed_time);
}

// Calls a testing function. The given test function should
// exit the program with an error if the test does not succeed.
void test(void (*test_fun)()) {
  num_tests += 1;
  printf(".");
  test_fun();
}

void test_par(void (*test_fun)(void*), void* param) {
  num_tests += 1;
  printf(".");
  test_fun(param);
}
