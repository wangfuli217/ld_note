#include<iostream>
#include<fstream>
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
		friend	ostream & operator<<(ostream &os,Complex const &c);
		friend  istream & operator<<(istream &is,Complex const &c);
		int m_r;  //实部
		int m_i;  //虚部
};
ostream & operator<<(ostream  &os,Complex const &c)
{
	os<<c.m_r<<' '<<c.m_i<<endl;
	return os;
}
istream & operator<<(istream &is,Complex const &c)
{
	return is>>c.m_r>>c.m_i;
}
int main(void)
{
	int i=123;
	double b=4.56;
	string s="Hello,World!";
	cout<<i<<' '<<b<<' '<<s<<endl;
	//cout.operator<<(i).operator<<(' ').operator<<(b).operator<<(' ')<<operator<<(s).operator<<(endl);
	Complex c1(1,2);
	Complex c2=c1;
	cout<<c1<<c2;
	//cout.operator<<(c1);
	//::operator<<(cout,c1);
	ofstream ofs("c2.txt");
	ofs<<c1<<' '<<c2<<endl;
	cin>>c1>>c2;
	cout<<c1<<c2;
	return 0;
}
