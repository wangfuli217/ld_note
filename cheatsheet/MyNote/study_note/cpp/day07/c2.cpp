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
		//Complex add(Complex const &rhs)
		Complex const operator+(Complex const &rhs) const
		//第一个const:返回常对象,模拟一个右值
		//第二个const:支持常右操作数
		//第三个const:支持常左操作数
		{
			Complex sum(m_r+rhs.m_r,m_i+rhs.m_i);
			return sum;
		}
		Complex const operator-(Complex const &rhs) const
		{
			Complex sub(m_r-rhs.m_r,m_i-rhs.m_i);
			return sub;
		}
	private:
		int m_r;  //实部
		int m_i;  //虚部
		friend Complex operator-(Complex,Complex);   //友元                                                                                                                                                               函数
};
Complex operator-(Complex lhs,Complex)
{
	return Complex(lhs.m_r-rhs.m_r,rhs.m_i-rhs.m_i);
}
int main(void)
{
	Complex c1(1,2),c2(3,4);
//	Complex c3=c1.add(c2);
	Complex c3=c1+c2;
//	Complex c3=c1.operator+(c2);
	c3.print();
//	Complex c4=c1.add(c2.add(c3));
	Complex c4=c1+c2+c3;
//	Complex c4=c1.operator+(c2).operator+(c3);
	c4.print();
	Complex const c5(5,6);
	c3=c1+c5;
	c3.print();
	c3=c5+c1;
	c3.print();	
//	(c1+c2)=c3;
	c3=c5-c1;
	c3.print();
	return 0;
}
