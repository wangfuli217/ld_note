#include <stdio.h>

#define abs(x)		(((x)>=0)?(x):-(x))
#define max(a,b)	((a)>(b)?(a):(b))
#define toupper(c)	((c)>='a'&&(c)<='z'?(c)+'A'-'a':(c))
#define toslower(c)	((c)>='A'&&(c)<='Z'?(c)+'a'-'A':(c))

void printneg (long n, void(*p)())
{
	long q;
	int r;

	q = n / 10;
	r = n % 10;
	if (r > 0) {
		r -= 10;
		q++;
	}
	if (n <= -10)
		printneg(q, p);
	(*p)("0123456789"[-r]);
}

void printnum (long n, void(*p)()) 
{
	if (n < 0) {
		(*p)('-');
		printneg(n, p);
	}
	else
		printneg(-n, p);
}


int main ()
{
	int a = 5, b = 7, c = -2, d = 4;
	int mid, low = 4, high = 56;
	char f = 'f', S = 'S';

	printf("abs 4: %d\n", abs(d));
	printf("abs -2: %d\n", abs(c));

	printf("max 5 8: %d\n", max(a, b));
	printf("max: %d\n", max(max(a, b), max(c, d)));

	mid = (low + high) / 2;									//slower
	mid = (low + high) >> 1;								//faster but most be positive
	printf("mid: %d\n", mid);

	printf("f: %c\tS: %c\n", toupper(f), toslower(S));

}
