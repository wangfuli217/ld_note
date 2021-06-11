#include "AnyTest.h"
#include <any>
#include <vector>

using std::any;
using std::any_cast;
using std::cout;
using std::endl;
using std::string;
using std::vector;

void AnyTest(void)
{
    /*
        一个任意类型值的类型安全容器
    */

    cout << "##Single any test:" << endl;
    any anySingle{ 123 };
    cout << "anySingle{ 123 }: " << any_cast<int>(anySingle) << endl;
    anySingle = string("Hello");
    cout << "anySingle{ string\"Hello\" }: " << any_cast<string>(anySingle) << endl;
    anySingle.emplace<AnyBase>(AnyBase("BaseClassInstance"));
    cout << "anySingle{ AnyBase() }: ";
    any_cast<AnyBase>(anySingle).dispMemStr();
    cout << endl;

    vector<any> anyVector;
    anyVector.push_back(123);
    anyVector.push_back(12.34);
    anyVector.push_back(string("World"));
    anyVector.push_back(AnyBase("AnyBase"));
    anyVector.push_back(AnyDerived("AnyDerived"));

    cout << "##Vector any test:" << endl;
    for (auto &elmt : anyVector)
    {
        if (elmt.type() == typeid(int))
        { cout << "int: " << any_cast<int>(elmt) << endl; }
        else if (elmt.type() == typeid(double))
        { cout << "double: " << any_cast<double>(elmt) << endl; }
        else if (elmt.type() == typeid(string))
        { cout << "string: " << any_cast<string>(elmt) << endl; }
        else if (elmt.type() == typeid(AnyBase))
        {
            cout << "AnyBase: ";
            any_cast<AnyBase>(elmt).dispMemStr();
        }
        else if (elmt.type() == typeid(AnyDerived))
        {
            cout << "AnyDerived: ";
            any_cast<AnyDerived>(elmt).dispMemStr();
        }
    }
    cout << endl;
}
