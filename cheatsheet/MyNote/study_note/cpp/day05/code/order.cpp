#include<iostream>
using namespace std;
class A
{
	public:
		A(string const& s):m_s(s),m_i(m_s.length()){}
		string m_s;
		int m_i;
};
int main(void)
{
	A a("1234");
	cout<<a.m_s<<' '<<a.m_i<<endl;
	return 0;
}
