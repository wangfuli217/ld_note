#include <stdio.h>

class A {
public:
    A() {}
public:
    template <class T> T add(T a, T b) 
    {
        return a + b;
    }
};


template <typename T, typename X> 
T Add(X x, X y)
{
	return x + y;
}

int main(int argc, char **argv)
{
	A a;
    
    a.add<int>(1, 2);
    
    long result = Add<long, int>(1, 2);
	
	printf("Result: %u\n", result);
	return 0;
}
