#include<iostream>
using namespace std;

class A
{
	public:
		A(int x=100):m_x(x){}
		int m_x;
};
class B:public A
{
	public:
		B(int y):m_y(y){}
		int m_y;
};
class C:public A
{
	public:
		C(int x,int z):A(x),m_z(z){}
		int m_z;
};
int main(void)
{
	B b(200);
	cout<<b.m_x<<' '<<b.m_y<<endl;
	C c(300,400);
	cout<<c.m_x<<' '<<c.m_z<<endl;
	return 0;
}
