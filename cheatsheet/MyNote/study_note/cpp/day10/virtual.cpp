#include<iostream>
using namespace std;
class A
{
	public:
		int m_x;
};
class B:public A
{
	public:
		int m_y;
};
class C:virtual public A
{
	public:
		int m_z;
};
class D:virtual public A
{
	public:
		int m_a;
};
class E:public C,public D
{

};
int main(void)
{
	cout<<sizeof(B)<<endl;
	cout<<sizeof(C)<<endl;
	cout<<sizeof(D)<<endl;
	cout<<sizeof(E)<<endl;
	return 0;
}
