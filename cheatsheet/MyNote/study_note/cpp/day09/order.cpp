#include<iostream>
using namespace std;
class A
{
	public:
		A(void)
		{
			cout<<"A构造"<<this<<endl;
		}
		~A(void)
		{
			cout<<"A析构"<<this<<endl;
		}
};
class B
{
	public:
		B(void)
		{
			cout<<"B构造"<<this<<endl;
		}
		~B(void)
		{
			cout<<"B析构"<<this<<endl;
		}
};
class C
{
	public:
		C(void)
		{
			cout<<"C构造"<<this<<endl;
		}
		~C(void)
		{
			cout<<"C析构"<<this<<endl;
		}
};
class D
{
	public:
		D(void)
		{
			cout<<"D构造"<<this<<endl;
		}
		~D(void)
		{
			cout<<"D析构"<<this<<endl;
		}
};
class X:public A,public B
{
	public:
		X(void)
		{
			cout<<"X构造"<<this<<endl;
		}
		~X(void)
		{
			cout<<"X析构"<<this<<endl;
		}
		C m_c;
		D m_d;
};
int main(void)
{
	X x;
	return 0;
}

