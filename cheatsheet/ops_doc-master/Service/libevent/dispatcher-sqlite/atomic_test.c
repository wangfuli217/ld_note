#include <stdlib.h>
#include <stdio.h>
#include "atomic.h"
#include "debug.h"
#include "unit.h"

int cnt = 100;

#if defined(_WIN32)

#include <windows.h>
#include <process.h>
#include <time.h>

unsigned int WINAPI thread_proc (PVOID param) {
    int i;
    for (i = 0; i < 1000000; i++) {
        AT_FAA (cnt, 1);
        // cnt++;
    }

    ph_debug ("thread: cnt=%d", cnt);

    return 0;
}

char *run_mutil_thread_test () {
    int i;
    HANDLE h = (HANDLE) _beginthreadex (0, 0, thread_proc, NULL, 0, 0);
    for (i = 0; i < 1000000; i++) {
        AT_FAS (cnt, 1);
        // cnt--;
    }
    ph_debug ("main: cnt=%d", cnt);

    DWORD dw = WaitForSingleObject (h, 5000);
    switch (dw) {
    case WAIT_OBJECT_0:
        ph_debug ("end!!");
        break;
    default:
        break;
    }
    ph_debug ("last: cnt=%d", cnt);

    return NULL;
}

#else

char *run_mutil_thread_test () {
    return NULL;
}

#endif

char *atomic_test () {
    int a = 5;
    ph_debug ("a=5");
    AT_FAA (a, 1);
    ph_debug ("AT_FAA(a, 1): a=%d", a);
    AT_FAS (a, 1);
    ph_debug ("AT_FAS(a, 1): a=%d", a);
    AT_AAF (a, 1);
    ph_debug ("AT_AAF(a, 1): a=%d", a);
    AT_SAF (a, 1);
    ph_debug ("AT_SAF(a, 1): a=%d", a);
    AT_DEC (a);
    ph_debug ("AT_DEC(a): a=%d", a);
    AT_INC (a);
    ph_debug ("AT_INC(a): a=%d", a);
    ph_debug ("AT_LOAD(a): a=%d", AT_LOAD (a));

    return NULL;
}

char *run_atomic_tests () {
    ph_suite_start ();

    ph_run_test (atomic_test);
    ph_run_test (run_mutil_thread_test);
    return NULL;
}

PH_RUN_TESTS (run_atomic_tests);
