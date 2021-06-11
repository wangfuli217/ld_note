#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <time.h>
#include "thread_win.h"
#include "debug.h"
#include "unit.h"

#define NUM_THREAD 1
#define TOTAL 10

void task_fn (void *data) {
    ph_debug ("%d\n", *(int *) data);
}

char *thread_pool_test () {
    int i, *in_data = NULL;
    thread_pool *pool = NULL;
    thread_pool_envinit ();

    pool = thread_pool_new (NUM_THREAD);
    if (pool == NULL) {
        ph_debug ("something wrong!!!");
        exit (-1);
    }
    pool->task = task_fn;

    thread_pool_start (pool);
    ph_debug ("pool start");
    // Sleep(1000);
    ph_debug ("pool dispatch");
    for (i = 0; i < TOTAL; i++) {
        in_data = (int *) malloc (sizeof (int));
        assert (in_data != NULL);
        *in_data = i;
        ph_debug ("main %d", i);
        thread_pool_dispatch (pool, in_data);
    }
    // Sleep(5000);
    ph_debug ("over");
    thread_pool_end (pool);

    return NULL;
}

char *run_all_test () {
    ph_suite_start ();

    ph_run_test (thread_pool_test);
    return NULL;
}

PH_RUN_TESTS (run_all_test);
