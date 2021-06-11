#include<iostream>
using namespace std;

class A
{
	public:
		virtual void foo(void)=0;
		A(void)
		{
			foo();
		}
		void bar(void)
		{
			foo();
		}
};
void A::foo(void)
{
	cout<<"A::foo"<<endl;
}
class B:public A
{
	public:
		void foo(void)
		{
			cout<<"B::foo"<<endl;
		}
};
int main(void)
{
	B b;
	b.bar();
	return 0;
}
