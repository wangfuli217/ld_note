#ifndef __TEMPLATE_H_
#define __TEMPLATE_H_

#include <iostream>

using namespace std;

template <class T>
void
Add(T a, T b)
{
	cout << "a + b: " << a + b << endl; 
}


//specialization
template <>
void
Add<float>(float a, float b)
{
	cout << "Is Float." << endl;
}

// function template overload
template <class T>
void
Add(T* a, T* b)
{
	cout << "is overload." << endl;
	cout << "a + b: " << *a + *b << endl;
}

#endif