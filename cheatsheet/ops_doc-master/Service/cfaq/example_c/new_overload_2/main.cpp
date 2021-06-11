#include <stdlib.h>
#include <stdio.h>
#include <new>
#include <iostream>
#include <exception>



struct A {} ;
struct E {} ;

class T {
public:
    T() { throw E() ; }
} ;

void * operator new ( std::size_t, const A & )
    {std::cout << "Placement new called." << std::endl;}
void operator delete ( void *, const A & )
    {std::cout << "Placement delete called." << std::endl;}

int main ()
{
    A a ;
	T* p;
	
    try {
		p = new (a) T ;
    } catch (E& exp) { 
		std::cout << "Exception caught." << std::endl;
	}
	
	delete p;
	
	system("pause");
	
    return 0 ;
}