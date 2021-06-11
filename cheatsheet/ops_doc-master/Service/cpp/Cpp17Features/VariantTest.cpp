#include "VariantTest.h"
#include <string>
#include <iostream>
#include <variant>

using std::cout;
using std::endl;
using std::variant;
using std::get;

void VariantTest(void)
{
    /*
        类型安全的union
        variant不能有以下类型的成员：引用、数组、void
        空variant用variant<monostate>替代
        同一种类型可以出现多次
    */
    variant<int, float> variantIns;

    variantIns = 123;
    size_t dataHolder = variantIns.index();
    cout << "Current valid index: " << dataHolder << endl;
    cout << "get<0>(variantIns): " << get<0>(variantIns) << endl
        << "get<int>(variantIns): " << get<int>(variantIns) << endl;
    cout << endl;

    try
    { std::get<float>(variantIns); } // 没有float枚举成员
    catch (std::bad_variant_access&)
    { cout << "bad_variant_access caught." << endl; }
    cout << endl;


    variantIns = 12.3f;
    dataHolder = variantIns.index();
    cout << "Current valid index: " << dataHolder << endl;
    cout << "get<1>(variantIns): " << get<1>(variantIns) << endl
        << "get<float>(variantIns): " << get<float>(variantIns) << endl;
    cout << endl;
}
