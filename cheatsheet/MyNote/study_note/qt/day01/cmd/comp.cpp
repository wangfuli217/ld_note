#include "comp.h"

Comparator::Comparator(int x,int y):m_x(x),m_y(y){}
int Comparator::min(void) const
{
	return m_x<m_y?m_x:m_y;
}
int Comparator::max(void) const
{
	return m_x<m_y?m_y:m_x;
}
