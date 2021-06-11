/*
This is a rng that produces random numbers amiable to be used in parallel computations as each one
cuts the sequence differently (so they are not correlated, but it is 5 times slower as Rand.

Adapted from: http://www.iro.umontreal.ca/~lecuyer/myftp/streams00/c/
To use the code for commercial purpose contact P. L'Ecuyer at: lecuyer@iro.UMontreal.ca
*/
#ifndef RNGSTREAM_H
#define RNGSTREAM_H
 
#define T RandStream_T
typedef struct T *T;

extern T       RandStream_new ();
extern void    RandStream_free (T* g);
extern double  RandStream_randU01 (T g);
extern int     RandStream_randInt (T g, int i, int j);
extern double  RandStream_gauss(T g, double variance);

#undef T
#endif
 
