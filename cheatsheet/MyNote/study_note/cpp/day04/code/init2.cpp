#include<iostream>
using namespace std;
class Circle
{
	public:
		Circle(int pi,int &r):m_pi(pi),m_r(r)
		{
			/*m_pi=pi;
			m_r=r;*/
		}
	private:
		int const m_pi;
		int &m_r;
};
int main(void)
{
	int r=10;
	Circle(3,r);
	return 0;
}
