#include <iostream>
#include <stdio.h>

using namespace std;

class F;

class A {
friend class F;
public:
    int a;
private:
    int aa;
};

class F {
public:
    void show_A(A& a) {
        printf("A: %d\n", a.aa);
    }
};


class B : public A {
public:
    int b;
private:
    int bb;
};

class FF : public F {
public:
    void show_AA(A& a) {
        //printf("A: %d\n", a.aa);
    }
};


int main()
{
    A a;
    F f;
    FF ff;



    f.show_A(a);
    ff.show_AA(a);

    return 0;
}
