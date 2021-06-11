#include <iostream>

using namespace std;

extern int func();
extern int out_func();
int main()
{
    func();
    out_func();
    return 0;
}
