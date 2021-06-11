#include <stdio.h>

class A {
public:
	A() {}
	~A() {}
	
typedef int myint_t; // 这是公共的类型
private:
	class B {
	public:
		void prt();
	};
	typedef int mynum_t; //这里只能类成员才能使用的类型
};

void 
A::B::prt() //类中定义的类型，需要添加类名的限定符，作用就想是namespace
{
	
}

A::myint_t i;
//A::mynum_t x;

int main(int argc, char **argv)
{
	printf("hello world\n");
	return 0;
}
