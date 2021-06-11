#include<iostream>
using namespace std;

typedef void(*VFUN) (void*);
typedef VFUN*	VPTR;
class A
{
	public:
		virtual void foo(void)
		{
			cout<<"A::foo "<<m_data<<endl;
		}
		virtual void bar(void)
		{
			cout<<"A::bar "<<m_data<<endl;
		}
		A(int data=0):m_data(data){}
	protected:
		int m_data;
};
class B:public A
{
	public:
		B(int data):A(data){}
		void foo(void)
		{
			cout<<"B::foo "<<m_data<<endl;
		}
};
int main(void)
{
	A a(100);
	VPTR vptr=*(VPTR*)&a;
	cout<<"main() : "<<vptr<<"->["<<(void*)vptr[0]<<','<<(void*)vptr[1]<<']'<<endl;
	return 0;
}
