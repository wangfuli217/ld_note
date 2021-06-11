#include <stdio.h>
#include <stdlib.h>

extern double square(double); // declare square() as external
inline double square(double); // declare square() as inline

double square(double x) { return x * x; }

int 
main()
{
	double q = square(1.3) + square(1.5);
	
	
	system("pause");
	
	return 0;
}