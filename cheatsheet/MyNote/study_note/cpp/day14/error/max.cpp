#include "max.h"
template<typename T>
T max(T x,T y)
{
	return x<y?y:x;
}
template<typename T>
Comparator<T>::Comparator(T x,T y):m_x(x),m_y(y){}
template<typename T>
T Comparator<T>::max(void) const
{
	return m_x<m_y?m_y:m_x;
}
