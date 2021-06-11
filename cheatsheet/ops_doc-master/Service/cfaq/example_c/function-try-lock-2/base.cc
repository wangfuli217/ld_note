#include "base.h"
#include <stdio.h>

A::A(int x)
	:_x(x)
{
	if (x <= 0) {
		throw 1;
	}
}


B::B(int x) 
try : A(x) {
	
} catch (...) {
	printf("create A failed.\n");
}



C::C(int x)
	:_x(x)
{
	if (x <= 0) {
		throw 2;
	}
}