#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "mem.h"
#include "randstream.h"

#define T RandStream_T

struct T {
   double Cg[6], Bg[6], Ig[6];
   int hasSpare;
   double rand1, rand2;
};

#define norm  2.328306549295727688e-10
#define m1    4294967087.0
#define m2    4294944443.0
#define a12     1403580.0
#define a13n     810728.0
#define a21      527612.0
#define a23n    1370589.0

#define two17   131072.0
#define two53   9007199254740992.0
#define fact  5.9604644775390625e-8    /* 1 / 2^24 */

/* Default initial seed of the package. Will be updated to become
   the seed of the next created stream. */
static double nextSeed[6] = { 12345, 12345, 12345, 12345, 12345, 12345 };

/* The following are the transition matrices of the two MRG components */
/* (in matrix form), raised to the powers -1, 1, 2^76, and 2^127, resp.*/
static double A1p127[3][3] = {
		  {    2427906178.0, 3580155704.0,  949770784.0 },
		  {     226153695.0, 1230515664.0, 3580155704.0 },
		  {    1988835001.0,  986791581.0, 1230515664.0 }
		  };

static double A2p127[3][3] = {
		  {    1464411153.0,  277697599.0, 1610723613.0 },
		  {      32183930.0, 1464411153.0, 1022607788.0 },
		  {    2824425944.0,   32183930.0, 2093834863.0 }
		  };

static double MultModM (double a, double s, double c, double m)
   /* Compute (a*s + c) % m. m must be < 2^35.  Works also for s, c < 0 */
{
   double v;
   long a1;
   v = a * s + c;
   if ((v >= two53) || (v <= -two53)) {
	  a1 = (long) (a / two17);
	  a -= a1 * two17;
	  v = a1 * s;
	  a1 = (long) (v / m);
	  v -= a1 * m;
	  v = v * two17 + a * s + c;
   }
   a1 = (long) (v / m);
   if ((v -= a1 * m) < 0.0)
	  return v += m;
   else
	  return v;
}

static void MatVecModM (double A[3][3], double s[3], double v[3], double m)
   /* Returns v = A*s % m.  Assumes that -m < s[i] < m. */
   /* Works even if v = s. */
{
   int i;
   double x[3];
   for (i = 0; i < 3; ++i) {
	  x[i] = MultModM (A[i][0], s[0], 0.0, m);
	  x[i] = MultModM (A[i][1], s[1], x[i], m);
	  x[i] = MultModM (A[i][2], s[2], x[i], m);
   }
   for (i = 0; i < 3; ++i)
	  v[i] = x[i];
}

static double U01 (T g)
{
   long k;
   double p1, p2, u;

   /* Component 1 */
   p1 = a12 * g->Cg[1] - a13n * g->Cg[0];
   k = (long) (p1 / m1);
   p1 -= k * m1;
   if (p1 < 0.0)
	  p1 += m1;
   g->Cg[0] = g->Cg[1];
   g->Cg[1] = g->Cg[2];
   g->Cg[2] = p1;

   /* Component 2 */
   p2 = a21 * g->Cg[5] - a23n * g->Cg[3];
   k = (long)(p2 / m2);
   p2 -= k * m2;
   if (p2 < 0.0)
	  p2 += m2;
   g->Cg[3] = g->Cg[4];
   g->Cg[4] = g->Cg[5];
   g->Cg[5] = p2;

   /* Combination */
   u = ((p1 > p2) ? (p1 - p2) * norm : (p1 - p2 + m1) * norm);
   return u;
}

T RandStream_new ()
{
   int i;
   T g;

   NEW0(g);
   g->hasSpare = 0;

   for (i = 0; i < 6; ++i) {
	  g->Bg[i] = g->Cg[i] = g->Ig[i] = nextSeed[i];
   }
   MatVecModM (A1p127, nextSeed, nextSeed, m1);
   MatVecModM (A2p127, &nextSeed[3], &nextSeed[3], m2);
   return g;
}

void RandStream_free (T* p)
{
   FREE(*p);
}

double RandStream_randU01 (T g)
{
  return U01 (g);
}

int RandStream_randInt (T g, int i, int j)
{
   return i + (int) ((j - i + 1.0) * RandStream_randU01 (g));
}

#define TWO_PI 6.2831853071795864769252866
#define SMALL_E 1e-100

double RandStream_gauss(T g, double variance)
{
	if(g->hasSpare)
	{
		g->hasSpare = 0;
		return sqrt(variance * g->rand1) * sin(g->rand2);
	}

	g->hasSpare = 1;

	g->rand1 = RandStream_randU01(g);
	if(g->rand1 < SMALL_E) g->rand1 = SMALL_E;

	g->rand1 = -2 * log(g->rand1);
	g->rand2 = RandStream_randU01(g) * TWO_PI;

	return sqrt(variance * g->rand1) * cos(g->rand2);
}
