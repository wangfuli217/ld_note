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
	private:
		int m_r;  //实部
		int m_i;  //虚部
};
int main(void)
{
	return 0;
}
