#include<iostream>
#include<cstring>
using namespace std;
class A{
	public:
		A(char const* str)
		{
			strcpy(m_str,str);
		}
		A(A const &a)
		{
			cout<<"A拷贝构造"<<endl;
			strcpy(m_str,a.m_str);
		}
		char m_str[256];
};
void foo(A a)
{
	cout<<a.m_str<<endl;
}
A bar(void)
{
	A a("hello,world");
	cout<<&a<<endl;	
	return a;
}
int main(void)
{
	A a1("hello,world");
	A a2(a1);   //拷贝构造函数
	A a3=a2;	//拷贝构造函数
	cout<<a1.m_str<<endl;
	cout<<a2.m_str<<endl;
	cout<<a3.m_str<<endl;
	foo(a3);
	cout<<bar().m_str<<endl;
	A const& ra=bar();
	cout<<&ra<<endl;
	return 0;
}
