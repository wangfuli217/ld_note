#ifndef _COMP_H
#define _COMP_H
class Comparator
{
public:
	Comparator(int x,int y);
	int max(void) const;
	int min(void) const;
private:
	int m_x;
	int m_y;
};
#endif
