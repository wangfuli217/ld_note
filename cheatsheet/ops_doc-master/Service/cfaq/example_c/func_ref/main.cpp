#include <stdio.h>

class A {
public:
	virtual show() const { printf("Base I: %d\n", i); }
private:
	int i;
};

class B : public A {
public:
	virtual show() const { printf("Dev I: %d\n", i); }
private:
	int i;
};

static void
func1(const A& a)
{
	a.show();
}

int main(int argc, char **argv)
{
	B b;
	
	B &rb = NULL; 这里不能为空，引用初始化的时候不能为NULL
	
	B *pb = NULL;
	
	A *pa = pb;
	
	func1(b);
	func1(0)
	
	return 0;
}
