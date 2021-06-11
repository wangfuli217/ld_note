#include<iostream>
#include<cmath>
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
		Complex const operator-(void) const 
		{
			return Complex(-m_r,-m_i);
		}
	private:
		int m_r;  //实部
		int m_i;  //虚部
		friend int operator!(Complex const &c);
};
int operator!(Complex const &c)
{
	return sqrt(c.m_r*c.m_r+c.m_i*c.m_i);
}
int main(void)
{
	Complex c1(1,2);
	Complex c2=-c1;
	c2.print();
	cout<<!c1<<endl;
	return 0;
}
