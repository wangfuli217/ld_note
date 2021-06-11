#ifndef RAND_INCLUDED
#define RAND_INCLUDED

#include <math.h> // for M_PI

#include "portable.h" /* for thread_local */
#include "utils.h"

BEGIN_DECLS

extern thread_local int rseed;

inline void Rand_init(int x){	
    rseed = x;
}

// Uses Microsoft algorithm for Linear Congruential generator http://en.wikipedia.org/wiki/Linear_congruential_generator
// Be careful, it is certainly not good for crypto work and perhaps not good enough to MC work either (but it's very simple)
// Works the same as C library rand() except that it is thread safe.
#define RAND_BITS   ((1U << 31) - 1)
#define RAND_MAXO   ((1U << 15) - 1) 
#define RAND_A      214013
#define RAND_B      2531011

inline double Rand_next(){	
    return ((double)((rseed = (rseed * RAND_A + RAND_B) & RAND_BITS) >> 16)) / RAND_MAXO;
}

#define M_PI 3.14159265358979323846

inline void Rand_gauss(double* r1, double* r2) {
    double u1 = Rand_next(), u2 = Rand_next();

    *r1 = sqrt(-2 * log(u1)) * cos(2 * M_PI * u2);
    *r2 = sqrt(-2 * log(u1)) * sin(2 * M_PI * u2);
}

#undef M_PI

END_DECLS

#endif
