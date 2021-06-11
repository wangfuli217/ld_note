#include <stdlib.h> /* for malloc */
#include <string.h> /* for strcpy */

#include "assert.h"
#include "test.h"
#include "timer.h"
#include "ring.h"
#include "mem.h"
#include "str.h"

struct test_data {
    char* library;
    char* feature;
    test_func func;
};

static Ring_T tests = NULL;

static
char* test_strdup (const char *s) {
    char *d = ALLOC (strlen (s) + 1);
    assert(d);

    strcpy (d,s);
    return d;
}

void test_addx(char* library, char* feature, test_func f) {
    struct test_data* p = NULL;

    assert(library);
    assert(feature);
    assert(f);

    if(!tests) tests = Ring_new();

    NEW(p);

    p->func     = f;
    p->library  = test_strdup(library);
    p->feature  = test_strdup(feature);
    tests = Ring_push_front(tests, p);
}

static
void apply(void **x, void *cl) {
    struct test_data* p = (struct test_data*)*x;
    unsigned* code = (unsigned*) cl;
    unsigned status;
    char* path;

    status = p->func();

    path = Str_asprintf("/%s/%s/", p->library, p->feature);
    printf("%-30s%s\n", path, status == TEST_SUCCESS ? "Ok" : "FAILED !!!");
    FREE(path);
    if(status == TEST_FAILURE) *code = 3;
}

static
void freetest(void **x, void *cl) {
    struct test_data* p = (struct test_data*)*x;
    (void)cl;

    FREE(p->library);
    FREE(p->feature);
    FREE(p);
}

unsigned test_run_all() {
    unsigned code = 0;

    /* Execute tests*/
    Timer_T t;
    long long elapsed;

    t = Timer_new_start();
    Ring_map(tests, apply, &code);
    elapsed = Timer_elapsed_micro_dispose(t);

    printf("\nExecuted in %I64d micro-sec\n", elapsed);

    /* Free tests */
    Ring_map(tests, freetest, NULL);
    Ring_free(&tests);
    return code;
}

#pragma warning (disable:4127)

long long test_perf(test_func f) {
    Timer_T t;
    long long time_res;
    unsigned test_res;
    assert(f);

    t           = Timer_new_start();
    test_res    = f ();
    time_res    = Timer_elapsed_micro_dispose(t);
    test_assert(test_res == TEST_SUCCESS);
    return time_res;
}

