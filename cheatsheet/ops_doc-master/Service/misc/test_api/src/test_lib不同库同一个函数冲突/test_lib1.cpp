#include <iostream>

using namespace std;

int func()
{
    cout << "I'm lib1 func()" << endl;
    return 0;
}

int out_func()
{
    cout << "I'm lib1 out_func()" << endl;
    func();
}
