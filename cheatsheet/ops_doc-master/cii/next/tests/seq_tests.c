#include "minunit.h"
#include <seq.h>
#include <dbg.h>

seq_t seq_int;

char *test_new_free()
{
    seq_int = seq_new(3);
    mu_assert(seq_int != NULL, "seq_new error.\n");

    seq_free(&seq_int);
    mu_assert(seq_int == NULL, "seq_free error.\n");

    return NULL;
}

char *test_seq_get_put()
{
    seq_int = seq_seq((void *)1, (void *)2, (void *)3, (void *)4, NULL);
    mu_assert(seq_int != NULL, "seq_seq error.\n");
    mu_assert(seq_length(seq_int) == 4, "seq_seq initialized wrong size.\n");

    mu_assert((long)seq_get(seq_int, 0) == 1,
              "seq_seq did not initialize items correctly.\n");
    mu_assert((long)seq_get(seq_int, 1) == 2,
              "seq_seq did not initialize items correctly.\n");
    mu_assert((long)seq_get(seq_int, 2) == 3,
              "seq_seq did not initialize items correctly.\n");
    mu_assert((long)seq_get(seq_int, 3) == 4,
              "seq_seq did not initialize items correctly.\n");

    seq_put(seq_int, 0, (void *) 4);
    mu_assert((long)seq_get(seq_int, 0) == 4, "seq_put set the wrong value.\n");
    seq_put(seq_int, 1, (void *) 5);
    mu_assert((long)seq_get(seq_int, 1) == 5, "seq_put set the wrong value.\n");
    seq_put(seq_int, 2, (void *) 6);
    mu_assert((long)seq_get(seq_int, 2) == 6, "seq_put set the wrong value.\n");
    seq_put(seq_int, 3, (void *) 7);
    mu_assert((long)seq_get(seq_int, 3) == 7, "seq_put set the wrong value.\n");

    seq_free(&seq_int);
    mu_assert(seq_int == NULL, "seq_free error.\n");

    return NULL;
}

char *test_hi_lo()
{
    seq_int = seq_new(1);
    mu_assert(seq_length(seq_int) == 0, "seq_new set the wrong length.\n");

    /* after add , should be [1] */
    seq_addlo(seq_int, (void *) 1);
    mu_assert(seq_length(seq_int) == 1,
              "after seq_addlo, the length is wrong.\n");
    mu_assert((long)seq_get(seq_int, 0) == 1,
              "seq_addlo did not add element correctly.\n");

    /* after add , should be [2, 1] */
    seq_addlo(seq_int, (void *) 2);
    mu_assert(seq_length(seq_int) == 2,
              "after seq_addlo, the length is wrong.\n");
    mu_assert((long)seq_get(seq_int, 0) == 2,
              "seq_addlo did not add element correctly.\n");

    /* after add , should be [3, 2, 1] */
    seq_addlo(seq_int, (void *) 3);
    mu_assert(seq_length(seq_int) == 3,
              "after seq_addlo, the length is wrong.\n");
    mu_assert((long)seq_get(seq_int, 0) == 3,
              "seq_addlo did not add element correctly.\n");

    long x;
    /* after rem, should be (3) [2, 1] */
    x = (long)seq_remlo(seq_int);
    mu_assert(seq_length(seq_int) == 2,
              "after seq_remlo, the length is wrong.\n");
    mu_assert(x = 3, "seq_remlo did not return the right element.\n");

    /* after add, should be [3, 2, 1] */
    seq_addlo(seq_int, (void *) 3);
    mu_assert(seq_length(seq_int) == 3,
              "after seq_addlo, the length is wrong.\n");
    mu_assert((long)seq_get(seq_int, 0) == 3,
              "seq_addlo did not add element correctly.\n");

    /* after rem, should be (3) [2, 1] */
    x = (long)seq_remlo(seq_int);
    mu_assert(seq_length(seq_int) == 2,
              "after seq_remlo, the length is wrong.\n");
    mu_assert(x = 3, "seq_remlo did not return the right element.\n");

    /* after add, should be [3, 2, 1] */
    seq_addlo(seq_int, (void *) 3);
    mu_assert(seq_length(seq_int) == 3,
              "after seq_addlo, the length is wrong.\n");
    mu_assert((long)seq_get(seq_int, 0) == 3,
              "seq_addlo did not add element correctly.\n");

    mu_assert((long)seq_get(seq_int, 0) == 3,
              "seq_addlo and seq_remlo gets wrong result.\n");
    mu_assert((long)seq_get(seq_int, 1) == 2,
              "seq_addlo and seq_remlo gets wrong result.\n");
    mu_assert((long)seq_get(seq_int, 2) == 1,
              "seq_addlo and seq_remlo gets wrong result.\n");

    /* test high end related */
    /* after add, should be [3, 2, 1, 4] */
    seq_addhi(seq_int, (void *) 4);
    mu_assert(seq_length(seq_int) == 4,
              "after seq_addhi, the length is wrong.\n");
    mu_assert((long)seq_get(seq_int, 3) == 4,
              "seq_addlo did not add element correctly.\n");
    
    /* after rem, should be [3, 2, 1] (4) */
    x = (long)seq_remhi(seq_int);
    mu_assert(seq_length(seq_int) == 3,
              "after seq_remlo, the length is wrong.\n");
    mu_assert(x == 4, "seq_remhi did not return the right element");

    /* after rem, should be [3, 2] (1) */
    x = (long)seq_remhi(seq_int);
    mu_assert(seq_length(seq_int) == 2,
              "after seq_remlo, the length is wrong.\n");
    mu_assert(x == 1, "seq_remhi did not return the right element");

    /* after rem, should be [3] (2) */
    x = (long)seq_remhi(seq_int);
    mu_assert(seq_length(seq_int) == 1,
              "after seq_remlo, the length is wrong.\n");
    mu_assert(x == 2, "seq_remhi did not return the right element");

    /* after rem, should be [] (3) */
    x = (long)seq_remhi(seq_int);
    mu_assert(seq_length(seq_int) == 0,
              "after seq_remlo, the length is wrong.\n");
    mu_assert(x == 3, "seq_remhi did not return the right element");

    seq_free(&seq_int);
    mu_assert(seq_int == NULL, "seq_free error.\n");
    return NULL;
}

char *test_caseD()
{
    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_new_free);
    mu_run_test(test_seq_get_put);
    mu_run_test(test_hi_lo);

    return NULL;
}

RUN_TESTS(all_tests);
