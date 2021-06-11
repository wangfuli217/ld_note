#include<iostream>
using namespace std;

class X{};
class Y:public X{};
class A
{
	public:
		//static virtual void foo(void){}
		void foo(void)
		{
			cout<<"A::foo"<<endl;
		}
		virtual void bar(void)
		{
			cout<<"A::bar"<<endl;
		}
		virtual int hum(int x) const
		{
			cout<<"A::hum"<<endl;
		}
};
class B:public A
{
	public:
		virtual void foo(void)
		{
			cout<<"B::foo"<<endl;
		}
		void bar(void) const
		{
			cout<<"B::bar"<<endl;
		}
		virtual int hum(int x) const
		{
			cout<<"B::hum"<<endl;
		}
};
int main(void)
{
	B b;
	A *p=&b;
	A &r=b;
	p->foo();
	r.foo();
	p->bar();
	r.bar();
	p->hum(3);
	r.hum(3);
	return 0;
}
