#include "minunit.h"
#include <ring.h>
#include <dbg.h>

ring_t r;

char *test_new()
{
    r = ring_new();
    mu_assert(r != NULL, "ring_new returns NULL.\n");
    mu_assert(ring_length(r) == 0,
              "ring_new: the ring returned contains elements.\n");

    ring_free(&r);
    mu_assert(r == NULL, "ring_free did error.\n");
    return NULL;
}

char *test_ring()
{
    r = ring_ring((void *)1, (void *)2, (void *)3, (void *)4, NULL);
    mu_assert(r != NULL, "ring_ring returns NULL.\n");
    mu_assert(ring_length(r) == 4,
              "ring_ring: the ring returned contains elements.\n");

    long x;
    x = (long)ring_get(r, 0);
    mu_assert(x == 1, "ring_get did not return the right value.\n");
    x = (long)ring_get(r, 1);
    mu_assert(x == 2, "ring_get did not return the right value.\n");
    x = (long)ring_get(r, 2);
    mu_assert(x == 3, "ring_get did not return the right value.\n");
    x = (long)ring_get(r, 3);
    mu_assert(x == 4, "ring_get did not return the right value.\n");
    x = (long)ring_get(r, -4);
    mu_assert(x == 1, "ring_get did not return the right value.\n");
    x = (long)ring_get(r, -3);
    mu_assert(x == 2, "ring_get did not return the right value.\n");
    x = (long)ring_get(r, -2);
    mu_assert(x == 3, "ring_get did not return the right value.\n");
    x = (long)ring_get(r, -1);
    mu_assert(x == 4, "ring_get did not return the right value.\n");

    return NULL;
}

char *test_set_get()
{
    /* now the ring should be [1 2 3 4] */
    long x;
    x = (long)ring_set(r, 0, (void *)0);
    mu_assert(x == 1, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 0, "ring_set did not set the correct value.\n");

    x = (long)ring_set(r, 1, (void *)1);
    mu_assert(x == 2, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, 1);
    mu_assert(x == 1, "ring_set did not set the correct value.\n");

    x = (long)ring_set(r, 2, (void *)2);
    mu_assert(x == 3, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, 2);
    mu_assert(x == 2, "ring_set did not set the correct value.\n");

    x = (long)ring_set(r, 3, (void *)3);
    mu_assert(x == 4, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, 3);
    mu_assert(x == 3, "ring_set did not set the correct value.\n");

    /* now the ring should be [0 1 2 3] */
    x = (long)ring_set(r, -1, (void *)0);
    mu_assert(x == 3, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, -1);
    mu_assert(x == 0, "ring_set did not set the correct value.\n");

    x = (long)ring_set(r, -2, (void *)1);
    mu_assert(x == 2, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, -2);
    mu_assert(x == 1, "ring_set did not set the correct value.\n");

    x = (long)ring_set(r, -3, (void *)2);
    mu_assert(x == 1, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, -3);
    mu_assert(x == 2, "ring_set did not set the correct value.\n");

    x = (long)ring_set(r, -4, (void *)3);
    mu_assert(x == 0, "ring_set did not return the correct old value.\n");
    x = (long)ring_get(r, -4);
    mu_assert(x == 3, "ring_set did not set the correct value.\n");

    /* now the ring should be [3 2 1 0] */
    return NULL;
}

char *test_lo_hi()
{
    long x;

    /* now the ring should be [3 2 1 0] */
    x = (long)ring_addlo(r, (void *)4);
    mu_assert(x == 4, "ring_addlo did not return correct value.\n");

    /* now it is [4 3 2 1 0] */
    mu_assert(ring_length(r) == 5,
              "ring_addlo did not set to the correct length.\n");
    x = (long)ring_get(r, 3);
    mu_assert(x == 1, "after ring_addlo, element index is wrong.\n");
    x = (long)ring_get(r, -5);
    mu_assert(x == 4, "after ring_addlo, element index is wrong.\n");

    x = (long)ring_remhi(r);
    mu_assert(x == 0, "ring_remhi did not return correct value.\n");
    /* now the ring is [4 3 2 1] */
    mu_assert(ring_length(r) == 4,
              "ring_addlo did not set to the correct length.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 4, "after ring_remhi, element index is wrong.\n");
    x = (long)ring_get(r, -1);
    mu_assert(x == 1, "after ring_remhi, element index is wrong.\n");
    
    x = (long)ring_addhi(r, (void *) 10);
    mu_assert(x == 10, "ring_addhi did not return correct value.\n");
    /* now it is [4 3 2 1 10] */
    mu_assert(ring_length(r) == 5,
              "ring_addhi did not set to the correct length.\n");
    x = (long)ring_get(r, 3);
    mu_assert(x == 1, "after ring_addhi, element index is wrong.\n");
    x = (long)ring_get(r, -1);
    mu_assert(x == 10, "after ring_addhi, element index is wrong.\n");

    /* now it is [4 3 2 1 10] */
    x = (long)ring_remlo(r);
    mu_assert(x == 4, "ring_remhi did not return correct value.\n");
    /* now the ring is [3 2 1 10] */
    mu_assert(ring_length(r) == 4,
              "ring_addlo did not set to the correct length.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 3, "after ring_remhi, element index is wrong.\n");
    x = (long)ring_get(r, -1);
    mu_assert(x == 10, "after ring_remhi, element index is wrong.\n");

    return NULL;
}

char *test_before_after()
{
    long x;
    /* now the ring is [3 2 1 10] */
    x = (long)ring_add_after(r, 1, (void *)7);
    mu_assert(x == 7, "ring_add_after did not return the right value.\n");
    /* now the ring is [3 2 7 1 10] */
    mu_assert(ring_length(r) == 5, "after ring_add_after, the length is wrong.\n");
    x = (long)ring_get(r, 2);
    mu_assert(x == 7, "after ring_add_after, the index is wrong.\n");
    x = (long)ring_get(r, -3);
    mu_assert(x == 7, "after ring_add_after, the index is wrong.\n");

    x = (long)ring_add_before(r, 1, (void *)5);
    mu_assert(x == 5, "ring_add_before did not return the right value.\n");
    mu_assert(ring_length(r) == 6, "after ring_add_after, the length is wrong.\n");
    /* now the ring is [3 5 2 7 1 10] */
    x = (long)ring_get(r, 2);
    mu_assert(x == 2, "after ring_add_before, the index is wrong.\n");
    x = (long)ring_get(r, -3);
    mu_assert(x == 7, "after ring_add_before, the index is wrong.\n");
    
    /* now the ring is [3 5 2 7 1 10] */
    x = (long)ring_add_after(r, -1, (void *)80);
    mu_assert(x == 80, "ring_add_after did not return the right value.\n");
    /* now the ring is [3 5 2 7 1 10 80] */
    mu_assert(ring_length(r) == 7, "after ring_add_after, the length is wrong.\n");
    x = (long)ring_get(r, 6);
    mu_assert(x == 80, "after ring_add_after, the index is wrong.\n");
    x = (long)ring_get(r, -2);
    mu_assert(x == 10, "after ring_add_after, the index is wrong.\n");

    x = (long)ring_add_before(r, 0, (void *)90);
    mu_assert(x == 90, "ring_add_before did not return the right value.\n");
    /* now the ring is [90 3 5 2 7 1 10 80] */
    mu_assert(ring_length(r) == 8, "after ring_add_after, the length is wrong.\n");
    x = (long)ring_get(r, -8);
    mu_assert(x == 90, "after ring_add_before, the index is wrong.\n");
    x = (long)ring_get(r, 3);
    mu_assert(x == 2, "after ring_add_before, the index is wrong.\n");

    return NULL;
}

char *test_remove()
{
    long x;
    /* now the ring is [90 3 5 2 7 1 10 80] */
    x = (long)ring_remove(r, 2);
    /* now the ring is [90 3 2 7 1 10 80] */
    mu_assert(x == 5, "ring_remove did not return the right value.\n");
    mu_assert(ring_length(r) == 7, "after ring_remove, the length is wrong.\n");

    /* now the ring is [90 3 2 7 1 10 80] */
    x = (long)ring_remove(r, -7);
    /* now the ring is [3 2 7 1 10 80] */
    mu_assert(x == 90, "ring_remove did not return the right value.\n");
    mu_assert(ring_length(r) == 6, "after ring_remove, the length is wrong.\n");
    x = (long)ring_get(r, 3);
    mu_assert(x == 1, "after ring_remove, the length is wrong.\n");

    /* now the ring is [3 2 7 1 10 80] */
    x = (long)ring_remove(r, 5);
    /* now the ring is [3 2 7 1 10] */
    mu_assert(x == 80, "ring_remove did not return the right value.\n");
    mu_assert(ring_length(r) == 5, "after ring_remove, the length is wrong.\n");
    x = (long)ring_get(r, -3);
    mu_assert(x == 7, "after ring_remove, the length is wrong.\n");

    /* now the ring is [3 2 7 1 10] */
    x = (long)ring_remhi(r);
    /* now the ring is [3 2 7 1] */
    mu_assert(x == 10, "ring_remove did not return the right value.\n");
    mu_assert(ring_length(r) == 4, "after ring_remove, the length is wrong.\n");
    x = (long)ring_get(r, -3);
    mu_assert(x == 2, "after ring_remove, the length is wrong.\n");

    return NULL;
}

char *test_rotate()
{
    long x;

    /* now the ring is [3 2 7 1] */
    ring_rotate(r, 0);
    /* now the ring is [3 2 7 1] */
    mu_assert(ring_length(r) == 4, "after ring_rotate, the length is wrong.\n");
    x = (long)ring_get(r, -3);
    mu_assert(x == 2, "after ring_rotate, the length is wrong.\n");

    ring_rotate(r, 2);
    /* now the ring is [7 1 3 2] */
    mu_assert(ring_length(r) == 4, "after ring_rotate, the length is wrong.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 7, "after ring_rotate, the length is wrong.\n");

    ring_rotate(r, -1);
    /* now the ring is [1 3 2 7] */
    mu_assert(ring_length(r) == 4, "after ring_rotate, the length is wrong.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 1, "after ring_rotate, the length is wrong.\n");

    ring_rotate(r, 4);
    /* now the ring is [1 3 2 7] */
    mu_assert(ring_length(r) == 4, "after ring_rotate, the length is wrong.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 1, "after ring_rotate, the length is wrong.\n");

    ring_rotate(r, 7);
    /* now the ring is [3 2 7 1] */
    mu_assert(ring_length(r) == 4, "after ring_rotate, the length is wrong.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 3, "after ring_rotate, the length is wrong.\n");

    ring_rotate(r, -5);
    /* now the ring is [2 7 1 3] */
    mu_assert(ring_length(r) == 4, "after ring_rotate, the length is wrong.\n");
    x = (long)ring_get(r, 0);
    mu_assert(x == 2, "after ring_rotate, the length is wrong.\n");

    ring_free(&r);
    mu_assert(r == NULL, "ring_free gets wrong.\n");
    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_new);
    mu_run_test(test_ring);
    mu_run_test(test_set_get);
    mu_run_test(test_lo_hi);
    mu_run_test(test_before_after);
    mu_run_test(test_remove);
    mu_run_test(test_rotate);

    return NULL;
}

RUN_TESTS(all_tests);
