#include <iostream>
#include <stdlib.h>

using namespace std;

class A {
public:
    virtual ~A() { cout << "A over" << endl; }

    void func() { _func(); _func_2(); }
private:
    virtual void _func() { cout << "is A" << endl; }
    void _func_2() { cout << "A's _func_2 " << endl; } /* 这个就不是动态绑定，静态绑定在编译期就已经选择好调用的函数 */
};

class B : public A {
public:
    virtual ~B() { cout << "B over" << endl; }
private:
    virtual void _func() { cout << "is B" << endl; }
    void _func_2() { cout << "B's _func_2 " << endl; }
};

#define newline cout << endl


int
main(int argc, char** argv)
{
    A *pa = new B;
    pa->func();
    delete pa;

    newline;

    A *pb = new A;
    pb->func();
    delete pb;

    newline;

    {
        A a;
        a.func();
    }

    newline;

    {
        B b;
        b.func();
    }


    system("pause");

    return 0;
}
