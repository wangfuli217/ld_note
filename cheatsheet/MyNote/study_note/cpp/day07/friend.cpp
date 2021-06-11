#include<iostream>
using namespace std;

class B;
class A
{
	public:
		void print(void) const
		{
			m_b.print();
		}
		void operator<<(B const &b)
		{
			m_b.m_i=b.m_i;
		}
	private:
		B* m_b;
};
class B
{
	public:
		B(int i=0):m_i(i){}
		void print(void) const
		{
			cout<<m_i<<endl;
		}
	private:
		int m_i;
		friend void A::operator<<(B const &);
};
int main(void)
{
	B b(123);
	A a;
	a<<b;     //b->a.m_b
	a.print();
	return 0;
}
