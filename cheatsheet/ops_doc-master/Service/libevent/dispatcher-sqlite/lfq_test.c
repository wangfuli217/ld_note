#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include "unit.h"
#include "debug.h"
#include "lfq.h"

#include  <windows.h>

#define THREAD_NUM 8
#define TOTAL 50000
#define TRY_TIMES 100

lfq_t myq;

unsigned int __stdcall thread_proc (PVOID param) {
    int i = 0, *int_data;
    while (i < TOTAL) {
        int_data = (int *) malloc (sizeof (int));
        assert (int_data != NULL);
        *int_data = i++;

        while (lfq_enq (&myq, int_data)) {
            ph_debug ("Full?");
        }

        while ((int_data = lfq_deq (&myq)) == NULL) {
            ph_debug ("Empty?");
        }
        free (int_data);
    }

    return 0;
}

char *lfq_test () {
    int i, n;
    clock_t c1, c2;
    lfq_init (&myq);

    for (n = 0; n < TRY_TIMES; n++) {
        ph_debug ("current running at %d, Total threads=%d", n, THREAD_NUM);
        HANDLE h[THREAD_NUM];

        c1 = clock ();

        for (i = 0; i < THREAD_NUM; i++) {
            unsigned upd_thread_id;
            h[i] = (HANDLE) _beginthreadex (NULL, 0, thread_proc, NULL, 0, &upd_thread_id);
        }
        for (i = 0; i < THREAD_NUM; i++) {
            DWORD dw;
            dw = WaitForSingleObject (h[i], INFINITE);
            switch (dw) {
            case WAIT_OBJECT_0:
                break;
            default:
                break;
            }
        }

        c2 = clock ();
        ph_debug ("Spend time=%f seconds\n", (float) (c2 - c1) / CLOCKS_PER_SEC);
        assert (0 == myq.size && "Error, consumed but not");
    }
    lfq_deinit (&myq);

    return NULL;
}

char *lfq_single_test () {
    lfq_init (&myq);

    void *data;
    lfq_deq (&myq);
    lfq_deq (&myq);
    lfq_deq (&myq);
    lfq_deq (&myq);
    lfq_deq (&myq);
    ph_debug ("%d", myq.size);

    int i, *int_data;
    for (i = 0; i < 100; i++) {
        int_data = (int *) malloc (sizeof (int));
        assert (int_data != NULL);
        *int_data = i;
        lfq_enq (&myq, int_data);
    }
    ph_debug ("%d", myq.size);

    for (i = 0; i < 10000; i++) {
        data = lfq_deq (&myq);
        if (data != NULL) {
            ph_debug ("out: %d", *((int *) (data)));
        }
    }
    ph_debug ("%d", myq.size);

    return NULL;
}

char *run_lfq_tests () {
    ph_suite_start ();

    // ph_run_test(lfq_single_test);
    ph_run_test (lfq_test);
    return NULL;
}

PH_RUN_TESTS (run_lfq_tests);
