#include <iostream>

using namespace std;

#define NEWLINE cout << endl;

class Base
{
public:
	Base() { cout << "Base Ctor" << endl; }
	~Base(){ cout << "Base Dtor" << endl; }
};

class Derived : public Base
{
public:
	Derived() { cout << "Derived Ctor" << endl;  }
	// 析构函数上加virtual的情况，会影响采用基本指针指向子类实例的时候，delete 基本指针的时候情况下上能正确调用子类的析构函数
	// 不影响普通实例的情况
	virtual ~Derived(){ cout << "Derived Dtor" << endl; } 
};

class Derived2 : public Derived
{
public:
	Derived2() { cout << "Derived2 Ctor" << endl; }
	~Derived2(){ cout << "Derived2 Dtor" << endl; }
};

int 
main(int argc, char** argv)
{
	
	NEWLINE
	Base* pb = new Derived2();
	delete pb;
	
	NEWLINE
	Derived* pd = new Derived2();
	delete pd;
	
	// 基类的析构函数，是否添加virtual都能正确释放
	NEWLINE
	{
		Derived dev;
	}
	
	NEWLINE
	{
		Derived2 dev2;
	}
}
