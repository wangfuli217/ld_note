#include "stdafx.h"
#include "TemplateGeneric.h"
#include <string>

using std::cout;
using std::endl;
using std::vector;
using std::string;

// 显式实例化explicit instantiation
// 为了避免不同文件使用同样的类型实例化模板，导致相同的模板实例在每个文件中都有一份，导致的额外开销。
// 显式实例化的两种形式：
// - 实例化声明，必须出现在任何使用此实例化版本的代码之前
//extern template class ClassTemplateWithFuncTemplate<int>;
// - 实例化定义，会实例化所以成员，即使有没被代码使用到的成员模板
template class ClassTemplateWithFuncTemplate<int>;
// extern模板声明表示承诺在程序其他位置有该实例化的一个非extern声明的定义
// 编译器遇到extern模板声明时，不会在本文件中生成实例化代码
// extern声明可以多次，但必须只有一个定义

void testTemplateGeneric(void)
{
    /*
        模板是泛型编程的基础。
        模板：创建类或函数的公式，如泛型类型vector，泛型函数find
        编译器利用调用函数模板时的实参来确定模板实参的过程称为模板实参推断template argument deduction
    */
    cout << "Function template test." << endl;
    // 编译器推断模板实参为int，之后实例化instantiate一个特定版本的函数实例instantiation
    cout << "ftCompare(1,2): " << ftCompare(1, 2) << endl;
    // 编译器推断模板实参为double，实例化另一个特定版本的函数dsfa
    cout << "ftCompare(321.123, 123.321): " << ftCompare(321.123, 123.321) << endl;
    // 编译器推断模板为compare(const char(&pCharAry1)[6], const char(&pCharAry2)[7]) 数组含'\0'
    cout << "ftCompare(\"Hello\", \"World!\"): " << ftCompare("Hello", "World!") << endl;
    // inline和constexpr的模板函数
    cout << "ftInlineConstexprDouble(123): " << ftInlineConstexprDouble(123) << endl;
    cout << endl;

    cout << "Class template test." << endl;
    // 用显式模板实参explicit template argument来绑定模板参数，用于编译器实例化
    ClassTemplate<int> ctIntIns = { 1,2,3,4,5 };
    ++ctIntIns;
    --ctIntIns;
    for (size_t i = 0; i != ctIntIns.size(); i++)
    { cout << "ctIntIns[" << i << "]: " << ctIntIns[i] << endl; }
    cout << endl;

    // 使用类模板别名
    templateClassAlias<string> ctStrIns = { "ONE", "TWO" };
    for (size_t i = 0; i != ctStrIns.size(); i++)
    { cout << "ctStrIns[" << i << "]: " << ctStrIns[i] << endl; }
    cout << endl;

    // 类模板的静态成员
    cout << "Before Changing ctIntIns.staticStr" << endl
        << "ctIntIns.staticStr: [" << ctIntIns.staticStr
        << "] ctStrIns.staticStr: [" << ctStrIns.staticStr << "]" << endl;
    ctIntIns.staticStr = string("MODIFY");
    cout << "After Changing ctIntIns.staticStr" << endl
        << "ctIntIns.staticStr: [" << ctIntIns.staticStr
        << "] ctStrIns.staticStr: [" << ctStrIns.staticStr << "]" << endl;
    cout << endl;

    // 函数和类模板的默认模板实参
    cout << "Default template argument" << endl;
    ftDefaultArg(12345);
    ftDefaultArg(54321, CTPrintAnother<>()); // 空模板实参列表表示使用默认值
    cout << endl;

    // 成员模板：函数模板作为类的成员
    ClassNormalWithFuncTemplate cnIns = ClassNormalWithFuncTemplate();
    cnIns.funcTemplate(123);
    cnIns.funcTemplate(123.456);
    cnIns.funcTemplate(std::string("Hello, world."));
    ClassTemplateWithFuncTemplate<int> ctIns = ClassTemplateWithFuncTemplate<int>();
    ctIns.funcTemplate(123.456, 789);
    cout << endl;

    // 显式模板实参，指定返回值的类型为double
    cout << "Returns " << ftExplicitTempArg<double>(12.34, 2) << endl;
    cout << endl;

    // 函数模板特例化
    ftGeneral(1, 0);
    ftGeneral('1', '0');
    ftGeneral(1.2, 2.1);
    cout << endl;

    // 类模板特例化
    ctGeneral<int> ctGeneralIns = ctGeneral<int>();
    ctGeneral<double> ctSpecialIns = ctGeneral<double>();
    int i = 123;
    int &ilRef = i;
    int &&irRef = 123;
    ctGeneral<decltype(123)> ctGeneralInsLitType = ctGeneral<decltype(123)>();
    ctGeneral<decltype(ilRef)> ctGeneralInsIntType = ctGeneral<decltype(ilRef)>();
    ctGeneral<decltype(irRef)> ctGeneralInsMoveIntType = ctGeneral<decltype(irRef)>();
    ctGeneral<string> ctGeneralStrIns = ctGeneral<string>();
    ctGeneralStrIns.disp();
    ctGeneralIns.disp();
    cout << endl;
}
