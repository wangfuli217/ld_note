#include <stdio.h>
#include <stdlib.h>

class A
{
public:
	void show() { printf("Is A.\n"); }
	
	int x;
};


int main(int argc, char **argv)
{
	typedef void (A::*pFunc)();
	void (A::*ptr)();
	
	int A::*pi = &A::x;
	
	pFunc pf;
	
	pf = &A::show;
	
	A a;
	
	A* pc = &a;
	
	(a.*pf)();
	
	(pc->*pf)();
	
	pc = NULL;
	
	(pc->*pf)();
	
	return 0;
}
