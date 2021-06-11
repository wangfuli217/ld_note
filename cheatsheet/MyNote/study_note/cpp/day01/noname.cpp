#include<iostream>
using namespace std;
namespace ns1
{
	int x=123;
	void foo(void)
	{
		cout<<"ns1:foo"<<endl;
	}
}
namespace ns2
{
	int x=789;
	void foo(void)
	{
		cout<<"ns2::foo"<<endl;
	}
	void bar(void)
	{
		cout<<x<<endl;
		foo();
		using ns1::x;
		using ns1::foo;
		cout <<x<<endl;
		foo();
	}
}
//实际按如下代码编译
/*namesapce   匿名名字空间
{
	int x=456;
	void foo(void)
	{
		cout<<"::foo"<<endl;
	}
} */
int x=456;
void foo(void)
{
	cout<<"::foo"<<endl;
}
int main(void)
{
	using namespace ns1;
	cout<<::x<<endl;
	::foo();
	using ns1::x;
	using ns1::foo;
	cout<<x<<endl;
	foo();
	ns2::bar();
	return 0;
}
