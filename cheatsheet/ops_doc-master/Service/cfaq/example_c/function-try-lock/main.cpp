#include <stdio.h>

int inc(int n) 
try {
	n++;
	throw n;
} catch (int i) {
	printf("n: %d\n", i);
	return i;
}


int main(int argc, char **argv)
{
	printf("result: %d\n", inc(3));
	return 0;
}
