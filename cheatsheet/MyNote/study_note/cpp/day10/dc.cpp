#include<iostream>
using namespace std;
class A
{
	virtual void foo(void){}
};
class B:public A
{
};
class C:public B
{
};
int main(void)
{
	B b;
	A *pa=&b;
	B *pb=static_cast<B*>(pa);
	C *pc=static_cast<C*>(pa);
	pb=dynamic_cast<B*>(pa);
	cout<<pb<<endl;
	pc=dynamic_cast<C*>(pa);
	cout<<pc<<endl;
	return 0;
}
