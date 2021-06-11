#include<iostream>
using namespace std;

void foo(int const* pi)
{
}
class A
{
	public:
		A(int data):m_data(data){}
		void bar(void) const {
			m_x=3;//const_cast<A*> (this)->m_x=123
		}     //常函数
		void hum(void)
		{
			cout<<1<<endl;
		}
		void hum(void) const
		{
			cout<<2<<endl;
		}
	private:
		int m_data;
		int mutable m_x;		
};
int main(void)
{
	int const i=100;
	foo(&i);
	A const a(3);
	A b(4);
	a.bar();
	a.hum();
	b.hum();
	return 0;
}
