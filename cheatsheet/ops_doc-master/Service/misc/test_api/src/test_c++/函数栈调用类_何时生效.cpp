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

    A a;//˯��10s��Ż���� A�Ĺ��캯��

    return 0;
}
