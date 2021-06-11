#include<iostream>
using namespace std;
class Comparator
{
	public:
		Comparator(int x,int y):m_x(x),m_y(y){}
		int max(void) const
		{
			return m_x<m_y?m_y:m_x;
		}
	private:
		int m_x,m_y;
};

