#undef NDEBUG
#ifndef MINUNIT_H
#define MINUNIT_H

#include <stdio.h>
#include <stdlib.h>

#include <dbg.h>


#define mu_suite_start() char *message = NULL

#define mu_assert(test, message) if (!(test)) \
    { log_err(message); return message; }

#define mu_run_test(test) debug_print("\n------->%s\n", " " #test); \
    message = (test)(); tests_run++; if (message) return message;

#define RUN_TESTS(name) \
    int main(int argc, const char *argv[]) \
    { \
        (void)argc; /* not used, supress warning */ \
        debug_print("\n===== RUNNING: %s\n", argv[0]); \
        printf("====\nRUNNING: %s\n", argv[0]); \
        char *result = name(); \
        if (result != 0) { \
            printf("FAILED: %s\n", result); \
        } else { \
            printf("ALL TESTS PASSED\n"); \
        } \
        printf("Tests run: %d\n", tests_run); \
        exit(result != 0); \
    }

int tests_run;

#endif /* end of include guard: MINUNIT_H */
