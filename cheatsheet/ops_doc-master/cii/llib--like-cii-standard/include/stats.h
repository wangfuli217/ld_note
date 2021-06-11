#ifndef STATS_INCLUDED
#define STATS_INCLUDED

#define T Stats_T
typedef struct T *T;

struct T {
    double SumSqr;
    int Count;
    double StdDev;
    double Average;
    double Max;
    double Min;
    double StdErr;
};

extern T        Stats_New         ();
extern void     Stats_Free        (T* stats);
extern void     Stats_Add         (T stats, double sample);
extern void     Stats_Zero        (T stats);

#undef T
#endif