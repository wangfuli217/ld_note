#include <stdio.h>

class A {
public:
	int i;
	
};

int main(int argc, char **argv)
{
	
	int *p = NULL;
	
	p = new(int);
	
	A *a = new(A);
	
	return 0;
}
