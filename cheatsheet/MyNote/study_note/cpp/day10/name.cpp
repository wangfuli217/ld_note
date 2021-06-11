#include<iostream>
using namespace std;
class A
{
	public:
		int m_x;
};
class B
{
	public:
		double m_x;
};
class C:public A,public B
{

};
int main(void)
{
	C c;
	c.A::m_x=100;
	return 0;
}
