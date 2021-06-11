#include "minunit.h"
#include <bit.h>
#include <dbg.h>

bit_t a = NULL;
bit_t b = NULL;

char *test_new()
{
    a = bit_new(256);
    mu_assert(a != NULL, "bit_new returns NULL.\n");
    mu_assert(bit_length(a) == 256, "bit_new returns wrong length.\n");
    mu_assert(bit_count(a) == 0, "bit_new returns wrong count.\n");

    b = bit_new(256);
    mu_assert(b != NULL, "bit_new returns NULL.\n");
    mu_assert(bit_length(b) == 256, "bit_new returns wrong length.\n");
    mu_assert(bit_count(b) == 0, "bit_new returns wrong count.\n");

    return NULL;
}

char *test_put_get()
{
    int x;
    mu_assert(bit_get(a, 0) == 0, "bit_get returns wrong result..\n");
    mu_assert(bit_get(a, 9) == 0, "bit_get returns wrong result..\n");
    mu_assert(bit_get(a, 127) == 0, "bit_get returns wrong result..\n");
    mu_assert(bit_get(a, 255) == 0, "bit_get returns wrong result..\n");

    x = bit_put(a, 0, 1);
    mu_assert(x == 0, "bit_put returns wrong result");
    mu_assert(bit_get(a, 0) == 1, "bit_put did not set values correctly.\n");

    x = bit_put(a, 9, 1);
    mu_assert(x == 0, "bit_put returns wrong result");
    mu_assert(bit_get(a, 9) == 1, "bit_put did not set values correctly.\n");

    x = bit_put(a, 127, 1);
    mu_assert(x == 0, "bit_put returns wrong result");
    mu_assert(bit_get(a, 127) == 1, "bit_put did not set values correctly.\n");

    x = bit_put(a, 255, 1);
    mu_assert(x == 0, "bit_put returns wrong result");
    mu_assert(bit_get(a, 255) == 1, "bit_put did not set values correctly.\n");

    return NULL;
}

char *test_set_clear_not()
{
    int i;
    bit_set(a, 1, 1);
    mu_assert(bit_get(a, 1)==1, "bit_set did not set correctly.\n");
    bit_set(a, 10, 80);
    for (i = 10; i <= 80; i++) {
        mu_assert(bit_get(a, i) == 1, "bit_set did not set correctly.\n");
    }

    bit_clear(a, 24, 50);
    for (i = 24; i <= 50; i++) {
        mu_assert(bit_get(a, i) == 0, "bit_clear did not set correctly.\n");
    }

    bit_not(a, 10, 80);
    for (i = 10; i < 24; i++) {
        mu_assert(bit_get(a, i) == 0, "bit_not did not set bits correctly.\n");
    }
    for (i = 24; i <= 50; i++) {
        mu_assert(bit_get(a, i) == 1, "bit_not did not set bits correctly.\n");
    }
    for (i = 51; i <= 80; i++) {
        mu_assert(bit_get(a, i) == 0, "bit_not did not set bits correctly.\n");
    }

    return NULL;
}

char *test_compare()
{
    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 5, 99);
    bit_set(b, 5, 99);
    mu_assert(bit_eq(a, b), "bit_eq is wrong.\n");
    mu_assert(bit_leq(a, b), "bit_leq is wrong.\n");
    mu_assert(bit_eq(b, a), "bit_eq is wrong.\n");
    mu_assert(bit_leq(b, a), "bit_leq is wrong.\n");

    bit_clear(a, 5, 5);
    mu_assert(bit_leq(a, b), "bit_leq is wrong.\n");
    mu_assert(bit_lt(a, b), "bit_lt is wrong.\n");
    mu_assert(!bit_leq(b, a), "bit_leq is wrong.\n");
    mu_assert(!bit_lt(b, a), "bit_lt is wrong.\n");

    return NULL;
}

char *test_bit_operation()
{
    bit_t tmp;
    int i;

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 5, 99);
    bit_set(b, 100, 222);

    tmp = bit_union(a, b);
    for (i=5; i<=222; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_union is wrong.\n");
    }
    mu_assert(bit_lt(a, tmp), "bit_union is wrong.\n");
    mu_assert(bit_lt(b, tmp), "bit_union is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 7, 99);
    bit_set(b, 7, 98);

    tmp = bit_union(a, b);
    for (i=7; i<=99; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_union is wrong.\n");
    }
    mu_assert(bit_eq(a, tmp), "bit_union is wrong.\n");
    mu_assert(bit_lt(b, tmp), "bit_union is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 7, 88);
    bit_set(b, 50, 98);

    tmp = bit_union(a, b);
    for (i=7; i<=98; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_union is wrong.\n");
    }
    mu_assert(bit_lt(a, tmp), "bit_union is wrong.\n");
    mu_assert(bit_lt(b, tmp), "bit_union is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    /* test bit_inter */
    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 7, 88);
    bit_set(b, 50, 98);

    tmp = bit_inter(a, b);
    for (i=50; i<=88; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_inter is wrong.\n");
    }
    mu_assert(bit_lt(tmp, a), "bit_inter is wrong.\n");
    mu_assert(bit_lt(tmp, b), "bit_inter is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 18, 200);
    bit_set(b, 18, 200);

    tmp = bit_inter(a, b);
    mu_assert(bit_eq(tmp, a), "bit_inter is wrong.\n");
    mu_assert(bit_eq(tmp, b), "bit_inter is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 18, 100);
    bit_set(b, 111, 200);

    tmp = bit_inter(a, b);
    bit_clear(a, 0, 255);
    mu_assert(bit_eq(tmp, a), "bit_inter is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    /* test of bit_minus */
    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 20, 201);
    bit_set(b, 111, 200);

    tmp = bit_minus(a, b);
    for (i=20; i<=110; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_minus is wrong.\n");
    }
    for (i=111; i<=200; i++) {
        mu_assert(bit_get(tmp, i) == 0, "bit_minus is wrong.\n");
    }
    mu_assert(bit_get(tmp, 201) == 1, "bit_minus is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    tmp = bit_minus(b, a);
    bit_clear(a, 0, 255);
    mu_assert(bit_eq(tmp, a), "bit_minus is wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 20, 110);
    bit_set(b, 111, 200);
    tmp = bit_minus(a, b);
    mu_assert(bit_eq(tmp, a), "bit_minus is wrong.\n");
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 20, 120);
    bit_set(b, 111, 200);
    tmp = bit_minus(a, b);
    for (i=20; i<=110; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_minus is wrong.\n");
    }
    for (i=111; i<=200; i++) {
        mu_assert(bit_get(tmp, i) == 0, "bit_minus is wrong.\n");
    }
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");


    /* test bit_diff */
    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 20, 222);
    bit_set(b, 111, 200);
    tmp = bit_diff(a, b);
    for (i=20; i<=110; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_diff is wrong.\n");
    }
    for (i=111; i<=200; i++) {
        mu_assert(bit_get(tmp, i) == 0, "bit_diff is wrong.\n");
    }
    for (i=201; i<=222; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_diff is wrong.\n");
    }
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    tmp = bit_diff(b, a);
    for (i=20; i<=110; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_diff is wrong.\n");
    }
    for (i=111; i<=200; i++) {
        mu_assert(bit_get(tmp, i) == 0, "bit_diff is wrong.\n");
    }
    for (i=201; i<=222; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_diff is wrong.\n");
    }
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 20, 110);
    bit_set(b, 111, 200);
    tmp = bit_diff(a, b);
    for (i = 20; i <= 200; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_diff is wrong.\n");
    }
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    bit_clear(a, 0, 255);
    bit_clear(b, 0, 255);
    bit_set(a, 20, 158);
    bit_set(b, 111, 200);
    tmp = bit_diff(a, b);
    for (i = 20; i <= 110; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_diff is wrong.\n");
    }
    for (i = 111; i <= 158; i++) {
        mu_assert(bit_get(tmp, i) == 0, "bit_diff is wrong.\n");
    }
    for (i = 159; i <= 200; i++) {
        mu_assert(bit_get(tmp, i) == 1, "bit_diff is wrong.\n");
    }
    bit_free(&tmp);
    mu_assert(tmp == NULL, "bit_free gets wrong.\n");

    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_new);
    mu_run_test(test_put_get);
    mu_run_test(test_set_clear_not);
    mu_run_test(test_compare);
    mu_run_test(test_bit_operation);

    return NULL;
}

RUN_TESTS(all_tests);
