#include <test.h>
#include <except.h>
#include <log.h>

#include <_arena.h>
#include <mem.h>

static char* testsuite_name = "arena";

static void testsuite_setup() {
    printf("%s", "In setup");
}

static void testsuite_teardown() {
    printf("%s", "In teardown");
}

static unsigned test_arena_resize() {
    
    Arena_T arena   = Arena_new();
    char * aChar;

    
    Mem_set_arena(arena);
    
    aChar           = ALLOC(sizeof(char));
    *aChar          = 'a';
    test_assert(*aChar == 'a');

    REALLOC(aChar, 100);
    strcpy(aChar + 1, "bcdefghilmnopqrstuvz");
    test_assert_str(aChar, "abcdefghilmnopqrstuvz");

    REALLOC(aChar, 10);
    aChar[9]        = '\0';
    test_assert_str(aChar, "abcdefghi");

    REALLOC(aChar, 100000);
    test_assert_str(aChar, "abcdefghi");

    REALLOC(aChar, 1);
    aChar[1] = '\0';
    test_assert_str(aChar, "a");

    REALLOC(aChar, 100);
    strcpy(aChar, "abcd");
    REALLOC(aChar, 2);
    aChar[2] = '\0';
    test_assert_str(aChar, "ab");

    Mem_set_default();

    Arena_dispose(&arena);
    Arena_remove_free_blocks();
    

    return TEST_SUCCESS;
}

void testsuite_arena() {

    testsuite_add("resize", test_arena_resize);
}
