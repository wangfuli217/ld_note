
#pragma implementation "B.h"
#include "B.h"

#include <iostream>
using namespace std;


template<class T>
B<T>::B()
{

}

template<class T>
B<T>::~B()
{

}

template<class T>
void
B<T>::Say()
{
	cout << "Is a B." << endl;
}