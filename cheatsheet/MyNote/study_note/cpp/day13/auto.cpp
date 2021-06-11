#include<iostream>
using namespace std;

template<typename T>
class AutoPtr
{
	public:
		explicit AutoPtr(T *p=NULL):m_p(p){}
		~AutoPtr(void)
		{
			if(m_p)
			{
				delete m_p;
				m_p=NULL;
			}
		}
	private:
		T *m_p;
};
class A
{
	public:
		A(int data=0):m_data(data)
		{
			cout<<"A构造"<<endl;
		}
		~A(void)
		{
			cout<<"A析构"<<endl;
		}
		void inc(void)
		{
			++m_data;
		}
		int m_data;
};
void foo(void)
{
	AutoPtr<A> p1(new A(100));
	p1->inc();
	cout<<(*p1).m_data<<endl;
}
int main(void)
{
	foo();
	return 0;
}
