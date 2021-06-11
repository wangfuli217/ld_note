#include <math.h>
#include <float.h>
#include <string.h>

#include "assert.h"
#include "mem.h"
#include "stats.h"

#define T Stats_T

T Stats_New () {

    T s;
    NEW0(s);
    s->Min = DBL_MAX;
    s->Max = DBL_MIN;

    return s;
}

void Stats_Free(T* stats) {
    assert(stats && *stats);

    FREE(*stats);
}

void Stats_Add(T stats, double sample) {
    double delta;
    assert(stats);

    // http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Incremental_algorithm
    stats->Count += 1;
    delta = sample - stats->Average;
    stats->Average += delta / stats->Count;
    stats->SumSqr += delta * (sample - stats->Average);
    stats->StdDev = sqrt(stats->SumSqr / (stats->Count - 1));

    stats->Max = sample > stats->Max ? sample : stats->Max;
    stats->Min = sample < stats->Min ? sample : stats->Min;
    stats->StdErr = stats->StdDev / sqrt((float)stats->Count);
}

void Stats_Zero(T s) {

    memset(s, 0, sizeof(*s));
    s->Min = DBL_MAX;
    s->Max = DBL_MIN;
}

