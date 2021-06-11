/*
 *  This code is a "working" version of questions 6.16, 6.18,
 *  6.19, and 6.20 in the comp.lang.c frequently-asked questions
 *  (FAQ) list.
 *
 *  This code attempts to answer the question "How can I write a
 *  function which accepts multidimensional arrays of arbitrary
 *  size, both statically and dynamically allocated?".  As it
 *  happens, the C language does not provide a good answer to
 *  this question.
 *
 *  This code serves as two different kinds of "torture test."
 *
 *  First of all, it is a good test of your understanding of
 *  arrays and pointers in C.  The code declares five kinds of
 *  multidimensional arrays, and three or four functions which
 *  accept various forms of multidimensional arrays, but they
 *  are not all compatible with each other.  Why do the ones
 *  which are compatible work (and why are the calls written
 *  as they are), and why are some incompatible?
 *
 *  Secondly, this code is a good test for certain parts of a C
 *  compiler or lint implementation.  Several of the assignments
 *  and calls (those marked "should warn" or "to check for
 *  compiler warnings") are definitely, and deliberately,
 *  incorrect, and should elicit warning (or error) messages from
 *  a quality compiler or lint implementation.  (Unless I've
 *  overlooked something, the only serious messages elicited by
 *  this code should be 2 about bad pointer assignments, and 9
 *  about function argument type mismatches.  Other warnings might
 *  have to do with arguments not used, or constants in conditional
 *  contexts, or switches with no case labels, or the signal
 *  function(s), or other problems with your system's header files.)
 *
 *  It is instructive to compare the source code of the functions
 *  f() and f2(), and particularly f() and f3().
 *
 *  Several of the function calls in this program (those marked
 *  "shouldn't work", and particularly those to f3()) are almost
 *  certain to result in Segmentation Violations or Bus Errors.
 *  The code tries to catch these signals when they occur, printing
 *  a message and attempting to continue, but depending on where the
 *  processor leaves the PC after a trap, it can go into quite a
 *  loop.  Don't run this code in an environment where you won't
 *  be able to abort it right away with control-C or the like.
 *  (If necessary, you may want to comment out or otherwise
 *  disable the troublesome calls.  You can knock them out all at
 *  once by #defining NOBADCALLS, but that will also mask most of
 *  the warnings and errors that your compiler ought to report.)
 *
 *  The calls that work should all print lines of the form
 *
 *	x00	x01	x02	x03	x04
 *	x10	x11	x12	x13	x14
 *	x20	x21	x22	x23	x24
 *
 *  , where x is 0, 1, 2, 3, or 4, depending on which "array" is
 *  being printed.
 *
 *  This code is in the Public Domain (I wouldn't dream of
 *  copyrighting something like this!).
 *
 *  Steve Summit 5/7/93 (updated 12/2/2001)
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#define NROWS	 3
#define NCOLUMNS 5

#define Arrayval(array, ncolumns, i, j) array[i * ncolumns + j]

int main(int, char *[]);
void bombsaway(int);

void f(int array[][NCOLUMNS], int nrows, int ncolumns);
void f2(int *array, int nrows, int ncolumns);
void f3(int **array, int nrows, int ncolumns);
#ifdef C99
void f4(int nrows, int ncolumns, int array[nrows][ncolumns]);
#endif

int not /* = 0 */;

/* ARGSUSED */

int
main(int argc, char *argv[])
{
int nrows = NROWS;
int ncolumns = NCOLUMNS;
int array[NROWS][NCOLUMNS];
int **array1;
int **array2;
int *array3;
int (*array4)[NCOLUMNS];
int i, j;
int *ip;

#ifdef SIGBUS
signal(SIGBUS, bombsaway);
#endif
#ifdef SIGSEGV
signal(SIGSEGV, bombsaway);
#endif

array1 = (int **)malloc(nrows * sizeof(int *));
for(i = 0; i < nrows; i++)
	array1[i] = (int *)malloc(ncolumns * sizeof(int));

array2 = (int **)malloc(nrows * sizeof(int *));
array2[0] = (int *)malloc(nrows * ncolumns * sizeof(int));
for(i = 1; i < nrows; i++)
	array2[i] = array2[0] + i * ncolumns;

array3 = (int *)malloc(nrows * ncolumns * sizeof(int));

array4 = (int (*)[NCOLUMNS])malloc(nrows * sizeof(*array4));

for(i = 0; i < nrows; i++)
	{
	for(j = 0; j < ncolumns; j++)
		{
		array[i][j] = 10 * i + j;
		array1[i][j] = 100 + 10 * i + j;
		array2[i][j] = 200 + 10 * i + j;
		Arrayval(array3, ncolumns, i, j) = 300 + 10 * i + j;
		array4[i][j] = 400 + 10 * i + j;
		}
	}

printf("as arrays:\n\n");

printf("array:\n");
f(array, NROWS, NCOLUMNS);

#ifndef NOBADCALLS

printf("\narray1 (shouldn't work):\n");
f((int (*)[NCOLUMNS])array1, nrows, ncolumns);	/* outright wrong cast */
if(not) f(array1, nrows, ncolumns);	/* to check for compiler warnings */

#endif

printf("\narray2:\n");
f((int (*)[NCOLUMNS])(*array2), nrows, ncolumns);	/* questionable cast */
if(not) f(*array2, nrows, ncolumns);	/* to check for compiler warnings */

printf("\narray3:\n");
f((int (*)[NCOLUMNS])array3, nrows, ncolumns);	/* questionable cast */
if(not) f(array3, nrows, ncolumns);	/* to check for compiler warnings */

printf("\narray4:\n");
f(array4, nrows, ncolumns);

printf("\n\nas \"simulated\" arrays:\n\n");

printf("array:\n");
f2(&array[0][0], NROWS, NCOLUMNS);

#ifndef NOBADCALLS

printf("\narray1 (shouldn't work):\n");
f2((int *)array1, nrows, ncolumns);	/* outright wrong cast */
if(not) f2(array1, nrows, ncolumns);	/* to check for compiler warnings */
printf("\narray1 another way (also shouldn't work):\n");
f2(*array1, nrows, ncolumns);

#endif

printf("\narray2:\n");
f2(*array2, nrows, ncolumns);

printf("\narray3:\n");
f2(array3, nrows, ncolumns);

printf("\narray4:\n");
f2(*array4, nrows, ncolumns);
printf("\narray4 another way (should also work):\n");
f2((int *)array4, nrows, ncolumns);	/* questionable cast */
if(not) f2(array4, nrows, ncolumns);	/* to check for compiler warnings */

printf("\n\nas pointers:\n\n");

#ifndef NOBADCALLS

printf("array (shouldn't work):\n");
f3((int **)array, NROWS, NCOLUMNS);	/* outright wrong cast */
if(not) f3(array, NROWS, NCOLUMNS);	/* to check for compiler warnings */
printf("\narray another way (also shouldn't work):\n");
ip = &array[0][0];
f3(&ip, NROWS, NCOLUMNS);

#endif

printf("\narray1:\n");
f3(array1, nrows, ncolumns);

printf("\narray2:\n");
f3(array2, nrows, ncolumns);

#ifndef NOBADCALLS

printf("\narray3 (shouldn't work):\n");
f3((int **)array3, nrows, ncolumns);	/* outright wrong cast */
if(not) f3(array3, nrows, ncolumns);	/* to check for compiler warnings */
printf("\narray3 another way (also shouldn't work):\n");
f3(&array3, nrows, ncolumns);

printf("\narray4 (shouldn't work):\n");
f3((int **)array4, nrows, ncolumns);	/* outright wrong cast */
if(not) f3(array4, nrows, ncolumns);	/* to check for compiler warnings */
printf("\narray4 another way (also shouldn't work):\n");
f3((int **)&array4, nrows, ncolumns);	/* outright wrong cast */
if(not) f3(&array4, nrows, ncolumns);	/* to check for compiler warnings */
printf("\narray4 yet another way (also shouldn't work):\n");
ip = array4;				/* should warn */
ip = (int *)array4;			/* outright wrong cast */
f3(&ip, nrows, ncolumns);
printf("\narray4 one last way (certainly shouldn't work):\n");
ip = &array4;				/* should warn */
ip = (int *)&array4;			/* outright wrong cast */
f3(&ip, nrows, ncolumns);

#endif

#ifdef C99

printf("\n\nas variable-length arrays:\n\n");

printf("array:\n");
f4(NROWS, NCOLUMNS, array);

#ifndef NOBADCALLS

printf("\narray1 (shouldn't work):\n");
f4(nrows, ncolumns, (int (*)[NCOLUMNS])array1);	/* outright wrong cast */
if(not) f4(nrows, ncolumns, array1);	/* to check for compiler warnings */

#endif

printf("\narray2:\n");
f4(nrows, ncolumns, (int (*)[NCOLUMNS])(*array2));	/* questionable cast */
if(not) f4(nrows, ncolumns, *array2);	/* to check for compiler warnings */

printf("\narray3:\n");
f4(nrows, ncolumns, (int (*)[NCOLUMNS])array3);	/* questionable cast */
if(not) f4(nrows, ncolumns, array3);	/* to check for compiler warnings */

printf("\narray4:\n");
f4(nrows, ncolumns, array4);

#endif

return 0;
}

void
f(int array[][NCOLUMNS], int nrows, int ncolumns)
{
int i, j;

for(i = 0; i < nrows; i++)
	{
	for(j = 0; j < ncolumns; j++)
		{
		if(j != 0)
			printf("\t");
		printf("%03d", array[i][j]);
		}

	printf("\n");
	}
}

void
f2(int *array, int nrows, int ncolumns)
{
int i, j;

for(i = 0; i < nrows; i++)
	{
	for(j = 0; j < ncolumns; j++)
		{
		if(j != 0)
			printf("\t");
		printf("%03d", Arrayval(array, ncolumns, i, j));
		}

	printf("\n");
	}
}

void
f3(int **array, int nrows, int ncolumns)
{
int i, j;

for(i = 0; i < nrows; i++)
	{
	for(j = 0; j < ncolumns; j++)
		{
		if(j != 0)
			printf("\t");
		printf("%03d", array[i][j]);
		}

	printf("\n");
	}
}

#ifdef C99

void
f4(int nrows, int ncolumns, int array[nrows][ncolumns])
{
int i, j;

for(i = 0; i < nrows; i++)
	{
	for(j = 0; j < ncolumns; j++)
		{
		if(j != 0)
			printf("\t");
		printf("%03d", array[i][j]);
		}

	printf("\n");
	}
}

#endif

/* ARGSUSED */

void
bombsaway(int sig)
{
switch(sig)
	{
#ifdef SIGBUS
	case SIGBUS:
		printf("Bus Error\n");
		break;
#endif
#ifdef SIGSEGV
	case SIGSEGV:
		printf("Segmentation Violation\n");
		break;
#endif
	default:
		printf("Signal %d\n", sig);
		break;
	}

signal(sig, bombsaway);
}