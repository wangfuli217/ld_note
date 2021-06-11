#include<iostream>
using namespace std;
class A
{
	public:
		A(void)
		{
			cout<<"A缺省构造"<<endl;
		}
		A(A const& that)
		{
			cout<<"A拷贝构造"<<endl;
		}
};
class B
{
	public:
		B(void)
		{
			cout<<"B缺省构造"<<endl;
		}
		B (B const &that):m_a(that.m_a)
		{
			cout<<"B拷贝构造"<<endl;
		}
	private:
		A m_a;   //成员子对象
};
int main(void)
{
	B b1;
	B b2=b1;
	return 0;
}
