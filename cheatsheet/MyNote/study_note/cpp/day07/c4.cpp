#include<iostream>
using namespace std;

//复数
class Complex
{
	public:
		Complex(int r=0,int i=0):m_r(r),m_i(i){}
		void print(void) const
		{
			cout<<m_r<<'+'<<m_i<<'i'<<endl;
		}
		Complex &operator++(void)
		{
			++m_r;
			++m_i;
			return *this;
		}
		Complex const operator++(int)
		{
			Complex c=*this;
			++*this;
			return c;
		}
	private:
		int m_r;  //实部
		int m_i;  //虚部
		friend Complex & operator--(Complex &c)
		{
			--c.m_r;
			--c.m_i;
			return c;
		}
};
int main(void)
{
	int i=0;
	cout<<++i<<endl;
	cout<<i<<endl;
	cout<<i++<<endl;
	cout<<i<<endl;
	++i=10;
	cout<<i<<endl;
	cout<<++++i<<endl;
	Complex c1(1,2);
	Complex c2=++c1;
	c1.print();  //2+3i
	c2.print();  //2+3i
	++c1=c2;
	c1.print(); //2+3i
	c2=--c1;
	c1.print();  //1+2i
	c2.print();	 //1+2i
	c2=c1++;
	c1.print();   //2+3i
	c2.print();	  //1+2i
	return 0;
}
