#undef _NDEBUG
#ifndef __UNIT_H__
#define __UNIT_H__

#include <stdio.h>
#include <stdlib.h>
#include "debug.h"

#define ph_suite_start() char *message = NULL

#define ph_assert(test, message) if (!(test)) {\
  ph_log_err(message);\
  return message;\
}

#define ph_run_test(test) ph_debug("\n-----%s", " " #test); \
  message = test();\
  tests_run++;\
  if (message) {\
    return message;\
  }

#define PH_RUN_TESTS(name) \
int main(int argc, char *argv[]) {\
  argc = 1; \
  ph_debug("----- RUNNING: %s", argv[0]); \
  fprintf(stderr, "----\nRUNNING: %s\n", argv[0]); \
  char *result = name(); \
  if (result != 0) { \
    fprintf(stderr, "FAILED: %s\n", result); \
  } else { \
    fprintf(stderr, "ALL TEST PASSED\n"); \
  } \
  fprintf(stderr, "Tests run: %d\n", tests_run); \
  exit(result != 0);\
}

int tests_run;

#endif
