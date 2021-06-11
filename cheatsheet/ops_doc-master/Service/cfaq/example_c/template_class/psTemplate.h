#ifndef __PS_TEMPLATE_H_
#define __PS_TEMPLATE_H_

template <class T, class U>
class CParial
{
public:
	CParial();
};

template<class T, class U>
CParial<T, U>::CParial()
{
	cout << "Is Primary Template." << endl;
}

template <class T>
class CParial<T*, T*>
{
public:
	CParial();
};

/* 偏特化 */
template<class T>
CParial<T*, T*>::CParial()
{
	cout << "Is T* Template." << endl;
}

template<class T>
class CParial<T, int>
{
public:
	CParial();
};

template<class T>
CParial<T, int>::CParial()
{
	cout << "Is int Template." << endl;
}


#if 0

template <class T>
class CPSExample
{
public:
	CPSExample() {}
	~CPSExample() {}
	
	void Show();
};

template <class T>
void
CPSExample<T>::Show()
{
	cout << "T: " << endl;
}


template <T>
class CPSExample<T*>
{
public:
	CPSExample() {}
	~CPSExample() {}
	
	void Show();
};

template<T*>
void
CPSExample::Show()
{
	cout << "TT: " << endl;
}

#endif

#if 0
template <class T, class P>
class CPSExample
{
public:
	CPSExample() {}
	~CPSExample() {}
	
	void Add(T t, P p);
};

template <class T, class P>
void
CPSExample<T, P>::Add(T t, P p)
{
	cout << "t + p: " << t + p << endl;
}


template <int i>
class CPSExample<i, 100>
{
public:
	CPSExample() {}
	~CPSExample() {}
	
	void Add(int a, int b);
};

template <int i>
CPSExample<i, 100>::Add(int a)
{
	cout << "Is 100" << endl;
	
	cout << "t + p: " << a + 100 << endl;
}
#endif

#endif