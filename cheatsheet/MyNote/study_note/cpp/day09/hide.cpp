#include<iostream>
using namespace std;
class A
{
	public:
		void foo(void) const
		{
			cout<<"A::foo"<<endl;
		}
};
class B : public A
{
	public:
		//int foo;
		//typedef int foo;
		void foo(int a) const
		{
			cout<<"B::foo"<<endl;
		}
};
int main(void)
{
	B b;
	b.foo();
	return 0;
}
