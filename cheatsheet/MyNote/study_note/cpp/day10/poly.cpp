#include<iostream>
using namespace std;

class A
{
	public:
		A(void)
		{
			foo();
		}
		virtual void foo(void)
		{
			cout<<"A::foo"<<endl;
		}
		void bar(void)
		{
			this->foo();
			//A* 指向b
			//指向子类对象的基类指针
		}
};
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
	/*B b;
	A &a=b;
	a.foo();
	b.bar();*/
	B* p=new B;
	p->bar();
	delete p;
	return 0;
}
