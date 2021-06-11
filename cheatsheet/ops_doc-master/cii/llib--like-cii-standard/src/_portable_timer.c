#ifdef _WIN32
#include <windows.h>
#else
#include <sys/time.h>
#endif

#include "mem.h"
#include "assert.h"

#include "timer.h"

#ifdef _WIN32
static LARGE_INTEGER frequency;
#endif

#define T Timer_T

struct T {
#ifdef _WIN32
    LARGE_INTEGER startCount;
#else
    timeval startCount;
#endif
    double startTimeInMicroSec;
};

T Timer_new_start() {
    T t;
#ifdef _WIN32
    BOOL result;
#endif
    NEW(t);

#ifdef _WIN32
    if(!frequency.QuadPart) {
        result = QueryPerformanceFrequency(&frequency);
        assert(result);
    }
    result = QueryPerformanceCounter(&t->startCount);
    assert(result);
#else
    gettimeofday(&t->startCount, NULL);
#endif
    return t;
}

long long Timer_elapsed_micro(T t) {
#ifdef _WIN32
    BOOL result;
    LARGE_INTEGER elapsedMicrosecond;
    LARGE_INTEGER endCount;

    result = QueryPerformanceCounter(&endCount);
    assert(result);

    elapsedMicrosecond.QuadPart   = endCount.QuadPart - t->startCount.QuadPart;
    elapsedMicrosecond.QuadPart  *= 1000000;
    elapsedMicrosecond.QuadPart  /= frequency.QuadPart;

    return elapsedMicrosecond.QuadPart;
#else
    long long startTimeInMicroSec, endTimeInMicroSec;
    timeval endCount;

    gettimeofday(&endCount, NULL);
    startTimeInMicroSec = (t->startCount.tv_sec * 1000000) + t->startCount.tv_usec;
    endTimeInMicroSec = (endCount.tv_sec * 1000000) + endCount.tv_usec;
    return endTimeInMicroSec - startTimeInMicroSec;
#endif
}

long long Timer_elapsed_micro_dispose(T t) {
    long long elapsed;

    elapsed = Timer_elapsed_micro(t);
    FREE(t);
    return elapsed;
}
