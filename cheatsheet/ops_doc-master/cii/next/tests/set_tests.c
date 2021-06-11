#include "minunit.h"
#include <set.h>
#include <dbg.h>
#include <stdbool.h>

static int int_vals[] = {0,1,2,3,4,5,6,7,8,9};
static char *str_vals[] = {"0","1","2","3","4","5","6","7","8","9"};

set_t set_int = NULL;
set_t set_str = NULL;

unsigned str_hash(const void *str)
{
    char *p = (char *)str;
    unsigned hash_val = 0;
    while (*p) {
        hash_val = hash_val * 131 + *p;
        p++;
    }

    return hash_val;
}

int str_cmp(const void *a, const void *b)
{
    return strcmp((const char *)a, (const char *)b);
}

char *test_new()
{
    set_int = set_new(30, NULL, NULL); /* use default cmp & hash */
    mu_assert(set_int != NULL, "set_new returned NULL.\n");
    mu_assert(set_length(set_int) == 0, "the length of new table is not 0.\n");

    set_str = set_new(30, str_cmp, str_hash); /* use default cmp & hash */
    mu_assert(set_str != NULL, "set_new returned NULL.\n");
    mu_assert(set_length(set_str) == 0, "the length of new table is not 0.\n");
    return NULL;
}

bool set_equal(set_t a, set_t b)
{
    set_t tmp = set_minus(a, b);
    bool ret = (set_length(tmp) == 0);

    set_free(&tmp, NULL);
    return ret;
}

char *test_member_put_remove()
{
    void *tmp = NULL;
    /* run this after test_new(), set_int & set_str should be empty */
    mu_assert(!set_member(set_int, &int_vals[0]),
              "empty set should have no member, but set_member returns true.\n");
    set_put(set_int, &int_vals[0]);
    set_put(set_int, &int_vals[1]);
    set_put(set_int, &int_vals[2]);
    set_put(set_int, &int_vals[3]);
    mu_assert(set_member(set_int, &int_vals[0]),
              "set_put did not add items correctly.\n");
    mu_assert(set_member(set_int, &int_vals[1]),
              "set_put did not add items correctly.\n");
    mu_assert(set_member(set_int, &int_vals[2]),
              "set_put did not add items correctly.\n");
    mu_assert(set_member(set_int, &int_vals[3]),
              "set_put did not add items correctly.\n");
    mu_assert(set_length(set_int) == 4,
              "set_put did not add items correctly.\n")
    tmp = set_remove(set_int, &int_vals[2]);
    mu_assert(!set_member(set_int, &int_vals[2]),
              "set_remove did not remove item correctly.\n");
    mu_assert(tmp == &int_vals[2],
              "set_remove did not remove item correctly.\n");
    tmp = set_remove(set_int, &int_vals[2]);
    mu_assert(tmp == NULL, "set_remove did not remove item correctly.\n");
    mu_assert(set_length(set_int) == 3,
              "set_put did not add items correctly.\n");

    set_put(set_str, str_vals[0]);
    set_put(set_str, str_vals[1]);
    set_put(set_str, str_vals[2]);
    set_put(set_str, str_vals[3]);
    mu_assert(set_member(set_str, str_vals[0]),
              "set_put did not add items correctly.\n");
    mu_assert(set_member(set_str, str_vals[1]),
              "set_put did not add items correctly.\n");
    mu_assert(set_member(set_str, str_vals[2]),
              "set_put did not add items correctly.\n");
    mu_assert(set_member(set_str, str_vals[3]),
              "set_put did not add items correctly.\n");
    mu_assert(set_length(set_str) == 4,
              "set_put did not add items correctly.\n")
    tmp = set_remove(set_str, str_vals[2]);
    mu_assert(!set_member(set_int, str_vals[2]),
              "set_remove did not remove item correctly.\n");
    mu_assert(tmp == str_vals[2],
              "set_remove did not remove item correctly.\n")
    tmp = set_remove(set_str, str_vals[2]);
    mu_assert(tmp == NULL, "set_remove did not remove item correctly.\n")
    mu_assert(set_length(set_int) == 3,
              "set_put did not add items correctly.\n")

    return NULL;
}

void add(const void *data, void *cl)
{
    (void)cl;   /* cl not used, supress warning */
    int *p = (int *)data;
    *p *= 2;
}

char *test_map()
{
    set_map(set_int, add, NULL);
    mu_assert(int_vals[0] == 0, "set_map did not handle correctly.\n");
    mu_assert(int_vals[1] == 2, "set_map did not handle correctly.\n");
    mu_assert(int_vals[2] == 2, "set_map did not handle correctly.\n");
    mu_assert(int_vals[3] == 6, "set_map did not handle correctly.\n");
    mu_assert(int_vals[4] == 4, "set_map did not handle correctly.\n");
    return NULL;
}

char *test_to_array()
{
    void ** array = set_to_array(set_str, NULL);
    int j = 0;
    mu_assert(array[j++] == str_vals[0], "set_to_array is wrong.\n");
    mu_assert(array[j++] == str_vals[1], "set_to_array is wrong.\n");
    mu_assert(array[j++] == str_vals[3], "set_to_array is wrong.\n");
    return NULL;
}

void print_int(const void *data, void *cl)
{
    (void)cl;   /* cl not used, supress warning */
    log_info("%s \n", (char *)data);
}

char *test_union()
{
    /* [0 1 2] && [1 2 3 4] == [0 1 2 3 4] */
    set_t a = set_new(5, NULL, NULL);
    set_put(a, str_vals[0]);
    set_put(a, str_vals[1]);
    set_put(a, str_vals[2]);

    set_t b = set_new(5, NULL, NULL);
    set_put(b, str_vals[1]);
    set_put(b, str_vals[2]);
    set_put(b, str_vals[3]);
    set_put(b, str_vals[4]);

    set_t c = set_union(a, b);
    mu_assert(set_length(c) == 5, "set_union gets wrong.\n");

    set_t d = set_new(5, NULL, NULL);
    set_put(d, str_vals[0]);
    set_put(d, str_vals[1]);
    set_put(d, str_vals[2]);
    set_put(d, str_vals[3]);
    set_put(d, str_vals[4]);

    mu_assert(set_equal(c, d), "set_union gets wrong.\n");

    set_free(&a, NULL);
    mu_assert(a == NULL, "set_free is wrong.\n");
    set_free(&b, NULL);
    mu_assert(b == NULL, "set_free is wrong.\n");
    set_free(&c, NULL);
    mu_assert(c == NULL, "set_free is wrong.\n");
    set_free(&d, NULL);
    mu_assert(d == NULL, "set_free is wrong.\n");

    return NULL;
}
char *test_inter()
{
    /* [0 1 2] && [1 2 3 4] == [1, 2] */
    set_t a = set_new(5, NULL, NULL);
    set_put(a, str_vals[0]);
    set_put(a, str_vals[1]);
    set_put(a, str_vals[2]);

    set_t b = set_new(5, NULL, NULL);
    set_put(b, str_vals[1]);
    set_put(b, str_vals[2]);
    set_put(b, str_vals[3]);
    set_put(b, str_vals[4]);

    set_t c = set_inter(a, b);
    mu_assert(set_length(c) == 2, "set_inter gets wrong.\n");

    set_t d = set_new(5, NULL, NULL);
    set_put(d, str_vals[1]);
    set_put(d, str_vals[2]);

    mu_assert(set_equal(c, d), "set_inter gets wrong.\n");

    set_free(&a, NULL);
    mu_assert(a == NULL, "set_free is wrong.\n");
    set_free(&b, NULL);
    mu_assert(b == NULL, "set_free is wrong.\n");
    set_free(&c, NULL);
    mu_assert(c == NULL, "set_free is wrong.\n");
    set_free(&d, NULL);
    mu_assert(d == NULL, "set_free is wrong.\n");

    return NULL;
}

char *test_minus()
{
    /* [0 1 2] && [1 2 3 4] == [0] */
    set_t a = set_new(5, NULL, NULL);
    set_put(a, str_vals[0]);
    set_put(a, str_vals[1]);
    set_put(a, str_vals[2]);

    set_t b = set_new(5, NULL, NULL);
    set_put(b, str_vals[1]);
    set_put(b, str_vals[2]);
    set_put(b, str_vals[3]);
    set_put(b, str_vals[4]);

    set_t c = set_minus(a, b);
    mu_assert(set_length(c) == 1, "set_minus gets wrong.\n");

    set_t d = set_new(5, NULL, NULL);
    set_put(d, str_vals[0]);

    mu_assert(set_equal(c, d), "set_minus gets wrong.\n");

    set_free(&a, NULL);
    mu_assert(a == NULL, "set_free is wrong.\n");
    set_free(&b, NULL);
    mu_assert(b == NULL, "set_free is wrong.\n");
    set_free(&c, NULL);
    mu_assert(c == NULL, "set_free is wrong.\n");
    set_free(&d, NULL);
    mu_assert(d == NULL, "set_free is wrong.\n");

    return NULL;
}

char *test_diff()
{
    /* [0 1 2] && [1 2 3 4] == [0 3 4] */
    set_t a = set_new(5, NULL, NULL);
    set_put(a, str_vals[0]);
    set_put(a, str_vals[1]);
    set_put(a, str_vals[2]);

    set_t b = set_new(5, NULL, NULL);
    set_put(b, str_vals[1]);
    set_put(b, str_vals[2]);
    set_put(b, str_vals[3]);
    set_put(b, str_vals[4]);

    set_t c = set_diff(a, b);
    mu_assert(set_length(c) == 3, "set_diff gets wrong.\n");

    set_t d = set_new(5, NULL, NULL);
    set_put(d, str_vals[0]);
    set_put(d, str_vals[3]);
    set_put(d, str_vals[4]);

    mu_assert(set_equal(c, d), "set_diff gets wrong.\n");

    set_free(&a, NULL);
    mu_assert(a == NULL, "set_free is wrong.\n");
    set_free(&b, NULL);
    mu_assert(b == NULL, "set_free is wrong.\n");
    set_free(&c, NULL);
    mu_assert(c == NULL, "set_free is wrong.\n");
    set_free(&d, NULL);
    mu_assert(d == NULL, "set_free is wrong.\n");

    return NULL;
}

char *test_free()
{
    set_free(&set_int, NULL);
    mu_assert(set_int == NULL, "error when freeing set_int");
    set_free(&set_str, NULL);
    mu_assert(set_str == NULL, "error when freeing set_str");
    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_new);
    mu_run_test(test_member_put_remove);
    mu_run_test(test_map);
    mu_run_test(test_to_array);
    mu_run_test(test_union);
    mu_run_test(test_inter);
    mu_run_test(test_minus);
    mu_run_test(test_diff);
    mu_run_test(test_free);

    return NULL;
}

RUN_TESTS(all_tests);
