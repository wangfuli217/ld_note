#include <iostream>
using namespace std;

class A
{
public:
    A()
    {
        cout<< "A()" << endl;
        p = new int[1024];
    }
    ~A()
    {
        cout<< "~A()" << endl;
        delete p;
    }

private:
    int * p;
};

int main()
{
    cout << "test 1" << endl;
    A * pa = new A;
    delete pa;

    cout << "test 2" << endl;
    const void * paa = new A;
    delete paa;

    cout << "test 3" << endl;
    const void * paa3 = new A;
//    delete (A*)paa3; //´íÎó
//Ð´·¨1
//    void * paaa3 = const_cast<void*>(paa3);
//    delete (A*)(paaa3);
//Ð´·¨2
    delete (A*)(const_cast<void*>(paa3));

    return 0;
}
