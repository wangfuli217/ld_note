#include<iostream>
using namespace std;

class X
{
	public:
		X(void)
		{
			cout<<"X构造"<<endl;
		}
		~X(void)
		{
			cout<<"X析构"<<endl;
		}
};
class Y
{
	public:
		Y(void)
		{
			cout<<"Y构造"<<endl;
		}
		~Y(void)
		{
			cout<<"Y析构"<<endl;
		}
};
class Z
{
	public:
		Z(void)
		{
			cout<<"Z构造"<<endl;
		}
		~Z(void)
		{
			cout<<"Z析构"<<endl;
		}
};
class A
{
	public:
		A(void)
		{
			cout<<"A构造"<<endl;
		}
		~A(void)
		{
			cout<<"A析构"<<endl;
		}
	private:
		X m_x;
		Y m_y;
		Z m_z;
};
int main(void)
{
	A a;
	cout<<"main函数就要返回了!"<<endl;
	return 0;
}
