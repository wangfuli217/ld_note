#include <stdio.h>
#include <stdlib.h>

class A
{
public:
	void Set(int i_) { i = i_; }
	int Get() const { return i; }
	A& operator = (const A& a);
private:
	int i;
};


A&
A::operator =(const A& a)
{
//	if (*this == a)
//		return *this;
	
	this->i = a.i;
	
	return *this;
}


int main(int argc, char **argv)
{
	A a, b;
	
	a.Set(10);
	b.Set(20);
	
	a = b;
	
	printf("i: %d\n", a.Get());
	
	system("pause");
	
	return 0;
}
