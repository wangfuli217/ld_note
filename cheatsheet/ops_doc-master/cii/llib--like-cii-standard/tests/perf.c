#include <string.h>

#include <test.h>
#include <mem.h>
#include <timer.h>
#include <log.h>
#include <slist.h>

typedef struct Person {
    char* name;
    char* region;
    long age;
} Person;

Person* new_person(int base, int nameL, int regionL) {
    Person* p;

    NEW(p);
    p->name     = ALLOC(base + nameL);
    p->region   = ALLOC(base + regionL);

    p->age = 35;
    return p;
}

void free_person(Person* p) {
    FREE(p->name);
    FREE(p->region);
    FREE(p);
}

void test_mem_perf_loop() {
#define loop 100
    int i, base;
    Person* array[loop];

    for(base = 0; base < loop; base++) {
        for(i = 0; i < loop; i++) {
            array[i] = new_person(base, i+1, (i+1) * 2);
        }

        for(i = 0; i < loop; i++) {
            free_person(array[i]);
        }
    }

}

void free_person_wrap(void** p, void* cl) {
    (void)cl;
    free_person((Person*)*p);
}

unsigned test_list() {
#define loop 100
    int i, base;

    for(base = 0; base < loop; base++) {

        SList_T l = NULL;
        for(i = 0; i < loop; i++) {
            l = SList_push_front(l, new_person(base, i+1, (i+1) * 2));
        }

        SList_map(l, free_person_wrap, NULL);
        SList_free(&l);
    }
    return TEST_SUCCESS;
}

unsigned test_list_perf() {
    long long res = test_perf(test_list);
    Arena_T arena;

    log("List : %I64d", res);

    arena = Arena_new();
    /* Arena_config(10, 10 * 1024); */
    Mem_set_arena(arena);
    res = test_perf(test_list);
    Arena_dispose(&arena);
    Mem_set_default();

    log("ListA: %I64d", res);


    return TEST_SUCCESS;
}

unsigned test_mem_perf() {
    Timer_T t;
    long long memTime, arenaTime, alignTime;
    Arena_T arena;

    // Use in Release mode to print out perf stats, arena is one order of mag faster
    //log_set(stderr, LOG_INFO);

    /* standard */
    t = Timer_new_start();

    test_mem_perf_loop();

    memTime = Timer_elapsed_micro_dispose(t);

    /* arena */
    t = Timer_new_start();

    arena = Arena_new();
    /* Arena_config(10, 10 * 1024); */
    Mem_set_arena(arena);

    test_mem_perf_loop();

    Arena_dispose(&arena);
    Mem_set_default();
    arenaTime = Timer_elapsed_micro_dispose(t);

    /* aligned */
    t = Timer_new_start();

    Mem_set_align();

    test_mem_perf_loop();

    Mem_set_default();
    alignTime = Timer_elapsed_micro_dispose(t);

    log("Mem  : %I64d", memTime);
    log("Arena: %I64d", arenaTime);
    log("Align: %I64d", alignTime);

    return TEST_SUCCESS;
}
