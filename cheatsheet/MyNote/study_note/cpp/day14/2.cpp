#include<iostream>
#include<typeinfo>
using namespace std;

template<typename X>
class A
{
	public:
		template<typename Y>
		class B
		{
			public:
				template<typename Z>
				class C;
				Y m_y;
		};
		X m_x;
};
template<typename X>
	template<typename Y>
		template<typename Z>
class A<X>::B<Y>::C
{
	public:
		Z m_z;
};
int main(void)
{
	A<char> a;
	A<char>::B<short> b;
	A<char>::B<short>::C<long> c;
	cout<<typeid(a.m_x).name()<<endl;
	cout<<typeid(b.m_y).name()<<endl;
	cout<<typeid(c.m_z).name()<<endl;
	return 0;
}
