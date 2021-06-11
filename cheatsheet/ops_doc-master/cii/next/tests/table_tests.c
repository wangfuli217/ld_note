#include "minunit.h"
#include <table.h>

static int keys[]={0,1,2,3,4,5,6,7,8,9};
static char *str_vals[]={"0","1","2","3","4","5","6","7","8","9"};
#define NELEM(x) (sizeof(x)/sizeof(x[0]))

struct table_t *num_tbl = NULL;
struct table_t *str_tbl = NULL;

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
    num_tbl = table_new(30, NULL, NULL); /* use default cmp & hash */
    mu_assert(num_tbl != NULL, "table_new returned NULL.\n");
    mu_assert(table_length(num_tbl) == 0, "the length of new table is not 0.\n");

    str_tbl = table_new(30, str_cmp, str_hash); /* use default cmp & hash */
    mu_assert(str_tbl != NULL, "table_new returned NULL.\n");
    mu_assert(table_length(str_tbl) == 0, "the length of new table is not 0.\n");

    return NULL;
}

char *test_put_get_remove()
{
    /* test for defautl cmp & hash */
    void *tmp = NULL;
    tmp = table_put(num_tbl, &keys[0], &keys[0]);
    mu_assert(tmp == NULL, "table_put returns value even when the key is never inserted.\n");

    tmp = table_put(num_tbl, &keys[0], &keys[0]);
    mu_assert(tmp == &keys[0], "table_put returns wrong prev value.\n");

    table_put(num_tbl, &keys[1], &keys[1]);
    table_put(num_tbl, &keys[2], &keys[2]);
    table_put(num_tbl, &keys[3], &keys[3]);

    mu_assert(table_length(num_tbl) == 4, "after table_put, the length of the table is wrong.\n");

    tmp = table_get(num_tbl, &keys[1]);
    mu_assert(tmp == &keys[1], "table_get get wrong value.\n");
    tmp = table_get(num_tbl, &keys[2]);
    mu_assert(tmp == &keys[2], "table_get get wrong value.\n");
    tmp = table_get(num_tbl, &keys[3]);
    mu_assert(tmp == &keys[3], "table_get get wrong value.\n");

    mu_assert(table_length(num_tbl) == 4, "after table_get, the length of the table is wrong.\n");

    tmp = table_remove(num_tbl, &keys[2]);
    mu_assert(tmp == &keys[2], "table_get get wrong value.\n");
    mu_assert(table_length(num_tbl) == 3, "after table_remove, the length of the table is wrong.\n");

    tmp = table_get(num_tbl, &keys[2]);
    mu_assert(tmp == NULL, "value is not correctly removed from table.\n");


    /* test on str_tbl */
    tmp = NULL;
    tmp = table_put(str_tbl, str_vals[0], &keys[0]);
    mu_assert(tmp == NULL, "table_put returns value even when the key is never inserted.\n");

    tmp = table_put(str_tbl, str_vals[0], &keys[0]);
    mu_assert(tmp == &keys[0], "table_put returns wrong prev value.\n");

    table_put(str_tbl, str_vals[1], &keys[1]);
    table_put(str_tbl, str_vals[2], &keys[2]);
    table_put(str_tbl, str_vals[3], &keys[3]);

    mu_assert(table_length(str_tbl) == 4, "after table_put, the length of the table is wrong.\n");

    tmp = table_get(str_tbl, str_vals[1]);
    mu_assert(tmp == &keys[1], "table_get get wrong value.\n");
    tmp = table_get(str_tbl, str_vals[2]);
    mu_assert(tmp == &keys[2], "table_get get wrong value.\n");
    tmp = table_get(str_tbl, str_vals[3]);
    mu_assert(tmp == &keys[3], "table_get get wrong value.\n");

    mu_assert(table_length(str_tbl) == 4, "after table_get, the length of the table is wrong.\n");

    tmp = table_remove(str_tbl, str_vals[2]);
    mu_assert(tmp == &keys[2], "table_get get wrong value.\n");
    mu_assert(table_length(str_tbl) == 3, "after table_remove, the length of the table is wrong.\n");

    tmp = table_get(str_tbl, str_vals[2]);
    mu_assert(tmp == NULL, "value is not correctly removed from table.\n");
    return NULL;
}

void add(const void *key, void **value, void *cl)
{
    (void)cl;   /* cl not used, supress warning */
    int *p = (int *) *value;

    *p = *p + *(int *)key; 
}

char *test_map()
{
    table_map(num_tbl, add, NULL);

    int *tmp;
    tmp = table_get(num_tbl, &keys[0]);
    mu_assert(*tmp == 0, "table_map did not handle right.\n");
    tmp = table_get(num_tbl, &keys[1]);
    mu_assert(*tmp == 2, "table_map did not handle right.\n");
    tmp = table_get(num_tbl, &keys[2]);
    mu_assert(tmp == NULL, "table_map did not handle right.\n");
    tmp = table_get(num_tbl, &keys[3]);
    mu_assert(*tmp == 6, "table_map did not handle right.\n");

    return NULL;
}

char *test_to_array()
{
    void **array= table_to_array(str_tbl, NULL);
    int j = 0;

    mu_assert(array[j++] == str_vals[0], "table_to_array is wrong.\n");
    mu_assert(array[j++] == &keys[0], "table_to_array is wrong.\n");
    mu_assert(array[j++] == str_vals[1], "table_to_array is wrong.\n");
    mu_assert(array[j++] == &keys[1], "table_to_array is wrong.\n");
    mu_assert(array[j++] == str_vals[3], "table_to_array is wrong.\n");
    mu_assert(array[j++] == &keys[3], "table_to_array is wrong.\n");
    return NULL;
}

char *test_free()
{
    table_free(&num_tbl, NULL);
    mu_assert(num_tbl == NULL, "error when freeing table");
    table_free(&str_tbl, NULL);
    mu_assert(str_tbl == NULL, "error when freeing table");
    return NULL;
}

char *all_tests()
{
    mu_suite_start();

    mu_run_test(test_new);
    mu_run_test(test_put_get_remove);
    mu_run_test(test_to_array);
    mu_run_test(test_free);

    return NULL;
}

RUN_TESTS(all_tests);
