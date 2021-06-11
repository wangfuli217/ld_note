#include <stdio.h>

class A {
public:
	template<class T> void show(T t);
};

template<class T>
void
A::show(T t)
{
	printf("Show\n");
}

template <>
void
A::show<int>(int i)
{
	
}

int 
main(int argc, char **argv)
{
	A a;
	
	a.show<A>(a);
	
	return 0;
}
