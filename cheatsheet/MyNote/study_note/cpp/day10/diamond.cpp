#include<iostream>
using namespace std;

class A
{
	public:
		A(int data):m_data(data){}
		void set(int data)
		{
			m_data=data;
		}
		int get(void) const
		{
			return m_data;
		}
	private:
		int m_data;
};
class B:virtual public A
{
	public:
		B(int data):A(data){}
};
class C:virtual public A
{
	public:
		C(int data):A(data){}
};
class D:public B,public C
{
	public:
		D(int data):B(data),C(data),A(data){}
};
int main(void)
{
	D d(100);
	d.B::set(200);
	cout<<d.C::get()<<endl;
	return 0;
}
