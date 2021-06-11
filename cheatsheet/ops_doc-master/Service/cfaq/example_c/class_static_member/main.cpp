#include <stdio.h>
#include <iostream>
#include <stdlib.h>

using namespace std;

class A {
public:
    void show() { cout << "Name: " << "A" << endl;}
private:
    static void version() { cout << "version: " << 1.00 << endl; }
};


class B {
public:
    void show() { cout << "Name: " << "B" << endl;}
public:
    static void version() { cout << "version: " << 2.00 << endl; } //基类 和 子类共用静态方法和成员
};

class BB : public B {
public:
	void show() { cout << "Name: " << "BB" << endl; }
public:
    static void version() { cout << "version: " << 2.10 << endl; } //只是多态，但是不是动态绑定
};

struct C {
    int ii;
};

int main(int argc, char **argv)
{
    A a;
    B b;
	B *pb = new BB;
	BB bb;
    
    a.show();

	//A::version(); // private 不能 调用
    
    b.show();
  
	b.version(); //通过对象也可以调用静态方法
	bb.version();
	pb->version();//只是多态，但是上是动态绑定 ，静态绑定，调用的是Class B 的version
	BB::version();
	BB::B::version();
	return 0;
}
