#include<iostream>
using namespace std;
template<typename T>
class A
{
	public:
		int m_var;
		void foo(void){}
	protected:
		class B{};
};
template<typename T>
class C:public A<T>
{
	public:
		void bar(void)
		{
			A<T>::m_var=10;
			A<T>::foo();
			typename A<T>::B b;
		}
};
int main(void)
{
	C<int> c;	
	return 0;
}
