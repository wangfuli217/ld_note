#ifndef __TEMPLATE_H_
#define __TEMPLATE_H_

#include <iostream>

using namespace std;


template <class T>
class CExample
{
public:
	CExample();
	~CExample();
	
	void Add(T a, T b);
};

template <class T>
CExample<T>::CExample() {}

template <class T>
CExample<T>::~CExample() {}

template <class T>
void
CExample<T>::Add(T a, T b)
{
	cout << "a + b: " << a + b << endl;
}

//specialization
template<>
class CExample<float>
{
public:
	CExample<float>() {}
	~CExample<float>() {}
	
	void Add(float a, float b);
};

void 
CExample<float>::Add(float a, float b)
{
	cout << "Is Float." << endl;
}



class CExample2
{
public:
	template<class T>
	void Add(T t);
};

template<class T>
void
CExample2::Add(T t)
{
	cout << "T:: " << t << endl;
}

// class method specialization
template<>
void
CExample2::Add(float f)
{
}


template<class T>
class CExample3
{
public:
	CExample3() {}
	~CExample3() {}
	
	template<class U>
	void Add(U u);
	
	friend class CExample<float>;
	
	template<class U> 
	friend void CExample2::Add(U t);
};

template<class T> template<class U>
void
CExample3<T>::Add(U u)
{
}

//template<class T> template <>
//void
//CExample3<T>::Add<int>(int i)
//{
//	
//}



#endif