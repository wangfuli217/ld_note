#include "minunit.h"
#include <array.h>

array_t ary_a; 
array_t ary_b;
static int int_vals[] = {0,1,2,3,4,5,6,7};

char *test_new()
{
    ary_a = array_new(10, sizeof(int));
    mu_assert(ary_a != NULL, "array_new error.\n");
    mu_assert(array_length(ary_a) == 10, "array_new error.\n");
    mu_assert(array_size(ary_a) == sizeof(int), "array_new error.\n");
    return NULL;
}

char *test_put_get()
{
    int * x;
    x = (int *)array_put(ary_a, 0, &int_vals[0]);
    mu_assert(x == &int_vals[0], "array_put error.\n");
    x = (int *)array_put(ary_a, 1, &int_vals[1]);
    mu_assert(x == &int_vals[1], "array_put error.\n");
    x = (int *)array_put(ary_a, 2, &int_vals[2]);
    mu_assert(x == &int_vals[2], "array_put error.\n");
    x = (int *)array_put(ary_a, 3, &int_vals[3]);
    mu_assert(x == &int_vals[3], "array_put error.\n");
    x = (int *)array_put(ary_a, 4, &int_vals[4]);
    mu_assert(x == &int_vals[4], "array_put error.\n");
    x = (int *)array_put(ary_a, 5, &int_vals[5]);
    mu_assert(x == &int_vals[5], "array_put error.\n");
    x = (int *)array_put(ary_a, 6, &int_vals[6]);
    mu_assert(x == &int_vals[6], "array_put error.\n");

    x = (int *)array_get(ary_a, 0);
    mu_assert(*x == 0, "array_get error.\n")
    x = (int *)array_get(ary_a, 1);
    mu_assert(*x == 1, "array_get error.\n")
    x = (int *)array_get(ary_a, 2);
    mu_assert(*x == 2, "array_get error.\n")
    x = (int *)array_get(ary_a, 3);
    mu_assert(*x == 3, "array_get error.\n")
    x = (int *)array_get(ary_a, 4);
    mu_assert(*x == 4, "array_get error.\n")
    x = (int *)array_get(ary_a, 5);
    mu_assert(*x == 5, "array_get error.\n")
    x = (int *)array_get(ary_a, 6);
    mu_assert(*x == 6, "array_get error.\n")

    return NULL;
}

char *test_resize()
{
    array_resize(ary_a, 5);
    mu_assert(array_size(ary_a)==sizeof(int), "array_resize error.\n");
    mu_assert(array_length(ary_a)==5, "array_resize error.\n");

    int *x;
    x = (int *)array_get(ary_a, 0);
    mu_assert(*x == 0, "array_resize error")
    x = (int *)array_get(ary_a, 1);
    mu_assert(*x == 1, "array_resize error")
    x = (int *)array_get(ary_a, 2);
    mu_assert(*x == 2, "array_resize error")
    x = (int *)array_get(ary_a, 3);
    mu_assert(*x == 3, "array_resize error")
    x = (int *)array_get(ary_a, 4);
    mu_assert(*x == 4, "array_resize error")
    return NULL;
}

char *test_copy()
{
    ary_b = array_copy(ary_a, 3);
    mu_assert(array_size(ary_b)==sizeof(int), "array_copy error.\n");
    mu_assert(array_length(ary_b)==3, "array_copy error.\n");

    int *x;
    x = (int *)array_get(ary_a, 0);
    mu_assert(*x == 0, "array_copy error")
    x = (int *)array_get(ary_a, 1);
    mu_assert(*x == 1, "array_copy error")
    x = (int *)array_get(ary_a, 2);
    mu_assert(*x == 2, "array_copy error")
    return NULL;
}

char *test_free()
{
    array_free(&ary_a);
    mu_assert(ary_a == NULL, "array_free error.\n");
    array_free(&ary_b);
    mu_assert(ary_b == NULL, "array_free error.\n");

    return NULL;
}
char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_new);
    mu_run_test(test_put_get);
    mu_run_test(test_resize);
    mu_run_test(test_copy);
    mu_run_test(test_free);

    return NULL;
}

RUN_TESTS(all_tests);
