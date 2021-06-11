#include<iostream>
using namespace std;
class A
{
	public:
		void foo(void)
		{
			cout<<"A::foo"<<endl;
			throw -1;
		}
		~A(void)
		{
			cout<<"A::~A"<<endl;
			throw -2;
		}
};
int main(void)
{
	try
	{
		A a;
		a.foo();
	}
	catch(int& ex)
	{
		cout<<ex<<endl;
	}
	cout<<"main函数正常返回"<<endl;
	return 0;
}
