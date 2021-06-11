#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <string.h>
#include <cmocka.h>

typedef struct KeyValue 
{
    unsigned int key;
    const char* value;
} KeyValue;

extern void set_key_values(KeyValue * const new_key_values,
                    const unsigned int new_number_of_key_values);
extern KeyValue* find_item_by_value(const char * const value);
extern void sort_items_by_key(void);

static KeyValue key_values[] = {
    { 10, "this" },
    { 52, "test" },
    { 20, "a" },
    { 13, "is" },
};

static int create_key_values(void **state) 
{
    KeyValue * const items = (KeyValue*)test_malloc(sizeof(key_values));
    memcpy(items, key_values, sizeof(key_values));
    *state = (void*)items;
    set_key_values(items, sizeof(key_values) / sizeof(key_values[0]));

    return 0;
}

static int destroy_key_values(void **state) 
{
    test_free(*state);
    set_key_values(NULL, 0);

    return 0;
}

static void test_find_item_by_value(void **state)
{
    unsigned int i;

    (void) state; /* unused */

    for (i = 0; i < sizeof(key_values) / sizeof(key_values[0]); i++) 
	{
        KeyValue * const found  = find_item_by_value(key_values[i].value);
        assert_true(found != NULL);
        assert_int_equal(found->key, key_values[i].key);
        assert_string_equal(found->value, key_values[i].value);
    }
}

static void test_sort_items_by_key(void **state) 
{
    unsigned int i;
    KeyValue * const kv = *state;
    sort_items_by_key();
    for (i = 1; i < sizeof(key_values) / sizeof(key_values[0]); i++) 
	{
        assert_true(kv[i - 1].key < kv[i].key);
    }
}

int main(void) 
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test_setup_teardown(test_find_item_by_value,
                                        create_key_values, destroy_key_values),
        cmocka_unit_test_setup_teardown(test_sort_items_by_key,
                                        create_key_values, destroy_key_values),
    };
    return cmocka_run_group_tests(tests, NULL, NULL);
}
