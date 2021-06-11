#include<iostream>
#include<typeinfo>
using namespace std;

class A
{
	public:
		template<typename T>
		void foo(void)
		{
			T t;
			cout<<typeid(t).name()<<endl;
		}
};
template<typename T>
void bar(void)
{
	T a;
	a.template foo<int>();
}
int main(void)
{
	A a;
	a.foo<int>();
	bar<A>();
	return 0;
}
