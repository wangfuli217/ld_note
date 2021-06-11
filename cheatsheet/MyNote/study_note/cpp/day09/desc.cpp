#include<iostream>
using namespace std;

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
};
class B:public A
{
	public:
		B(void)
		{
			cout<<"B构造"<<endl;
		}
		~B(void)
		{
			cout<<"B析构"<<endl;
		}
};
int main(void)
{
	A* p=new B;
	delete p;
	//指向子类对象的基类指针
	return 0;
}

