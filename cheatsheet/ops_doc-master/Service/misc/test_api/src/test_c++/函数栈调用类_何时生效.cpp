#include<iostream>

using namespace std;

class A
{
public:
    A(){cout<< "A()" << endl;}
    ~A(){cout<< "~A()" << endl;}
};
int main() {

    cout << "main()" << endl;

    sleep(10);

    A a;//睡眠10s后才会调用 A的构造函数

    return 0;
}
