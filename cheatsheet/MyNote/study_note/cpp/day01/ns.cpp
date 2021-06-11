#include<iostream>
using namespace std;
namespace ns1
{
	int a=123;
	void foo(void)
	{
		cout << "ns1::foo" << endl;
	}
}
namespace ns2
{
	int a=456;
}
namespace ns2
{
	/*void foo(void)
	{
		std::cout << "ns2::foo" <<std::endl;
	}*/
	void foo(void);  //声明
}
void ns2::foo(void)  //定义
{
	cout << "ns2::foo" <<endl;
}
int main(void)
{
	ns1::foo();
	ns2::foo();
	using namespace ns1;
	std::cout<<a<<std::endl;   //名字空间指令
	foo();
	//以下代码引发歧义错误
/*	using namespace ns2;
	std::cout<<a<<std::endl;
	foo();*/
	using  ns2::a;   //名字空间声明
	using  ns2::foo; 
	std::cout << a <<std::endl;
	foo();
	//以下代码会引发歧义错误
	/* using ns1::foo;
	   foo();*/
	return 0;
}
