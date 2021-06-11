#include<iostream>
using namespace std;

class A
{
	public:		int m_pub;
	protected:	int m_pro;
	private:	int m_pri;
};
class B:protected A
{
};
int main(void)
{
	B b;
	b.m_pub=0;
	b.m_pro=0;
	b.m_pri=0;
	return 0;
}
