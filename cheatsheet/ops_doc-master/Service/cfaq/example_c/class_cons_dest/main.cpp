#include <iostream>
#include <cstdlib>

using namespace std;

class MyClass
{
public:
	MyClass()
	{
		cout <<"Constructors"<< endl;
	}

	~MyClass()
	{
		cout <<"Destructors"<< endl;
	}

};


class A 
{
public:
	A(int _i) : i(_i) {}
	~A() {}
private:
	int i;
};

class B : public A
{
public:
	B(int _i) : A(_i), i(_i)  {} /* 初始化列表中直接调用基类的构造函数 */
	~B() {}
private:
	int i;
};

class AA {
public:
	explicit AA(string name) { __name = name; }
	virtual ~AA() {}
	
	void self() { printf("I am AA\n"); }
	virtual void other() { printf("I am AA\n"); }
private:
	string __name;
};

class AAA : public AA {
public:
	AAA():AA("aa"), __aa("aaa") {}
	void self() { printf("I am AAA\n");}
	virtual void other() { printf("I am AAA\n"); }
private:
	AA __aa;
};

int
main(int argc, char* argv[])
{
	//MyClass* pMyClass =new MyClass;
	
	void* temp = (MyClass*)malloc(sizeof(MyClass));
	
	MyClass* pMyClass = new (temp)MyClass();
//	pMyClass->MyClass::MyClass();
	
	pMyClass->~MyClass();
	delete pMyClass;
	
	
	AAA aaa;
	AA aa("aa");
	
	aaa.self();
	aa.self();
	
	AA *paaa = new AAA();
	AA *paa = new AA("aa");

	// self 不是动态绑定，采用静态绑定方式, 按照调用者的类型编译器决定调用那个方法
	paaa->self();
	paa->self();
	dynamic_cast<AAA*>(paaa)->self();
	
	// dynamic binding
	paaa->other();
	paa->other();
}