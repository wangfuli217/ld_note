#include "stdafx.h"
#include "SpecialTechTest.h"

using std::cout;
using std::endl;
using std::bad_cast;
using std::string;

void memOperTest(void)
{
    /*
        #### 控制内存分配 ####

        使用new表达式时，
        string *sp = new string("a value");
        string *arr = new string[10];
        执行了三步操作：
        1. new表达式调用operator new或operator new[]的标准库函数，
        分配一块足够大的、原始的、未命名的内存空间
        2. 调用相应的构造函数构造对象，传入初值
        3. 返回指向该对象的指针
        使用delete表达式时，
        delete sp;
        delete [] arr;
        执行了两步操作：
        1. 对sp指向的对象或arr指向的数组中的元素执行对应的析构函数
        2. 调用operator delete或operator delete[]的标准库函数释放内存空间

        重载时，可以在全局作用域重载，也可以将其定义为成员函数。
        编译器发现new或delete表达式时，先在程序中查找可调用的函数：
        如果new或delete的对象是类类型，则现在类及其基类作用域中查找，
        再到全局作用域查找，都没有找到自定义的版本，则调用标准库的版本。
        可以在代码中使用全局作用域运算符显式(::new)调用全局作用域的new和delete
    */
}

void rttiTest(void)
{
    /*
        #### 运行时类型识别RTTI (Run-time type identification) ####

        用两个运算符实现：
        - typeid：返回表达式的类型
        - dynamic_cast：将基类指针或引用安全转换成派生类的指针或引用

        dynamic_cast使用形式：
        dynamic_cast<type*>(e)          e必须是一个有效指针
        dynamic_cast<type&>(e)          e是左值
        dynamic_cast<type&&>(e)         e不能是左值

        type必须是类类型，通常情况下有虚函数
        e必须满足以下三个条件之一：
        - e的类型是type的公有派生类
        - e的类型是type的公有基类
        - e的类型是type的类型
        如符合，类型转换成功
        如不满足，且转换目标是指针类型，则结果为0
        如不满足，且转换类型为引用类型，则抛出bad_cast异常

        typeid表达式的形式：typeid(e)
        e是任意表达式或类型名
        返回类型为type_info（typeinfo头文件）或其公有派生类的常量对象引用，可以使用name()成员函数打印编译器定义的类型名
        当e不是类类型或是不包含虚函数的类时，返回运算对象的静态类型，意即即是是指向派生类的基类指针，也会返回基类指针类型
    */
    BaseClassForCast baseIns = BaseClassForCast();
    DerivedClassForCast dervIns = DerivedClassForCast();

    // 基类指针指向派生类
    BaseClassForCast *basePtr = &dervIns;
    // 从基类指针转换为派生类指针
    // 在if语句内判断是否转换成功，能保重紧随其后的代码分情况处理
    if (DerivedClassForCast *dervPtr = dynamic_cast<DerivedClassForCast*>(basePtr))
    {
        cout << "dynamic_cast(pointer) success!" << endl;
        // 成功，dervPtr指向派生类对象
    }
    else
    {
        cout << "/!\\dynamic_cast(pointer) fail!" << endl;
        // 失败，dervPtr指向基类对象
    }

    // 基类引用引用派生类对象
    BaseClassForCast &baseRef = dervIns;
    try
    {
        DerivedClassForCast &dervRef = dynamic_cast<DerivedClassForCast&>(baseRef);
        cout << "dynamic_cast(reference) success!" << endl;
    }
    catch (bad_cast)
    {
        cout << "/!\\dynamic_cast(reference) fail!" << endl;
    }

    // 之前if条件内的定义作用域已经结束，再次定义
    DerivedClassForCast *dervPtr = dynamic_cast<DerivedClassForCast*>(basePtr);
    // typeid()作用域对象，所以指针要解引用
    if (typeid(*basePtr) == typeid(*dervPtr))
    { cout << "basePtr and dervPtr are the same." << endl; }
    else
    { cout << "/!\\basePtr and dervPtr are NOT the same." << endl; }
    if (typeid(*basePtr) == typeid(DerivedClassForCast))
    { cout << "basePtr is DerivedClassForCast." << endl; }
    else
    { cout << "/!\\basePtr is NOT DerivedClassForCast." << endl; }

    // 打印各种类型名，type_info类的实现在各种编译器上有所不同
    cout << endl
        << "Different type_info names:" << endl
        << "123: " << typeid(123).name() << endl
        << "12.34: " << typeid(12.34).name() << endl
        << "'c': " << typeid('c').name() << endl
        << "\"string\"" << typeid("string").name() << endl
        << "string(\"string\")" << typeid(string("string")).name() << endl
        << endl;
}

void enumTest(void)
{
    cpuNamesScoped cpuScoped;
    cpuScoped = cpuNamesScoped::cpuPpc; // 必须使用枚举成员赋值，不能用常量赋值
    cpuNamesUnscoped cpuUnscoped = cpuPpc;
    int scopedPPC = cpuNamesUnscoped::cpuPpc; // 不限定作用域的枚举成员可以隐式转换为整型
    cout << "scoped enumeration: " << endl
        << "cpuIntel: " << static_cast<int>(cpuNamesScoped::cpuIntel) << endl
        << "cpuAmd: " << static_cast<int>(cpuNamesScoped::cpuAmd) << endl
        << "cpuArm: " << static_cast<int>(cpuNamesScoped::cpuArm) << endl
        << "cpuPpc: " << static_cast<int>(cpuNamesScoped::cpuPpc) << endl;
    cout << "unscoped enumeration: " << endl
        << "cpuIntel: " << cpuIntel << endl
        << "cpuAmd: " << cpuAmd << endl
        << "cpuArm: " << cpuArm << endl
        << "cpuPpc: " << cpuPpc << endl;
    cout << endl;
}

void memberPointerTest(void)
{
    /*
        成员指针pointer to member是指向类的非静态成员的指针
    */
    // 数据成员指针
    int MemPtrClass::*intMemPtr; // 声明指向MemPtrClass对象的int成员
    intMemPtr = &MemPtrClass::intMem; // 指定指针指向的数据成员（并非指向类对象的成员）
    auto intMemPtr2 = &MemPtrClass::intMem; // 使用C++11的auto
    MemPtrClass memPtrClass = MemPtrClass(123); // 创建类对象
    MemPtrClass *memPtrClassP = &memPtrClass; // 创建类对象指针
    cout << "memPtrClass.*intMemPtr: " << memPtrClass.*intMemPtr << endl;
    cout << "memPtrClassP->*intMemPtr: " << memPtrClassP->*intMemPtr << endl;
    // 成员函数指针
    void (MemPtrClass::*funcMemPtr)(string dispStr); // 声明指向MemPtrClass对象的成员函数
    funcMemPtr = &MemPtrClass::dispPar; // 指定指针指向的成员函数，必须用取地址运算符
    auto funMemPtr2 = &MemPtrClass::dispPar;
    (memPtrClass.*funcMemPtr)("memPtrClass.*funcMemPtr");
    (memPtrClassP->*funcMemPtr)("memPtrClassP->*funcMemPtr");

    int i = 11;
    auto j = i;

    cout << endl;

}

OuterClass::InnerClassDeclare::InnerClassDeclare()
{
    std::cout << "InnerClassDeclare" << std::endl;
}

void nestedClassTest(void)
{
    /*
        一个类定义在另一个类的内部，前者称为嵌套类nested class或nested type
        嵌套类和外层类的成员没有包含的关系
        嵌套类的名字在外层作用域可见，在外层作用域之外不可见
    */
    OuterClass outerIns = OuterClass();
    OuterClass::InnerClassDeclare innerDeclare = OuterClass::InnerClassDeclare();
    OuterClass::InnerClassDefind innerDefine = OuterClass::InnerClassDefind();
}

void unionTest(void)
{
    /*
        union不能含有引用类型的成员，C++11允许含有构造函数或析构函数的类类型作为union成员
        默认union成员public
        可以为成员定义public/private/protected
        可以定义包括构造函数和析构函数的成员函数
        不能继承也不能作为基类，不能有虚函数

        当包含类类型的成员时，编译器按照成员的次序依次合成默认构造函数或拷贝控制成员
        如果类类型自定义类默认构造函数或拷贝控制成员，编译器将为union合成的版本声明为delete
        此时通常使用把union作为类的成员，由类来管理union成员内类类型成员的构造和销毁
    */
    Token charToken = { 'a' };  // 初始化cVal
    Token uninitToken;  // 未初始化
    Token *tokenP = &uninitToken; // Union指针

    // 为一个数据成员赋值会是其他数据成员变成未定义状态
    uninitToken.iVal = 123;
    tokenP->dVal = 12.34;

    // 匿名union的成员在相同作用域可以直接访问
    anonyDouble = 12.34;
}

void localClassTest(void)
{
    /*
        局部类local class：类定义在函数内部
        局部类的所有成员（包括函数）必须完整定义在类内部
        不允许静态数据成员
        不能使用函数作用域中的变量，
        只能访问外层作用域定义的类型名、静态变量、枚举成员

        局部类可以再嵌套，嵌套类的定义可以出现在局部类外，但必须在局部类相同的作用域中
    */
}

void nonportableTest(void)
{
    // 不可移植nonportable特性用于支持低层编程

    /*
        位域bit-field
        位域的类型是枚举类型
        取地址不能作用域位域，因此指针无法指向类的位域
    */
    bitField bfIns = bitField();
    // 超过位域范围的位被丢弃
    bfIns.mode = 5;
    cout << "Set 2bit field to 5, result: " << bfIns.mode << endl << endl;

    /*
        只有volatile的成员函数才能被volatile的对象调用
        合成拷贝对volatile无效
    */
    volatile int volInt = 123;
    // 只有volatile的指针才能指向volatile对象地址
    volatile int *volIntP = &volInt;
    //int *intP = &volInt;
}

// 把C++的函数extern给c代码
// 如果正在编译CPP程序，ifdef为真
#ifdef __cplusplus
extern "C"
{
#endif
#include <iostream>
    void cppCode(int i)
    { std::cout << "Hello, cpp in c." << endl; }
#ifdef __cplusplus
}
#endif

// 把c的函数extern给C++代码
// 链接指示中的字符串字面量值指出编写函数所用语言，可以是"Ada"， "FORTRAN"，等
// 单语句链接指示
extern "C" void cCode(int i);
// 复合语句链接指示
extern "C"
{
#include <stdio.h>

    void cCode(int i)
    {
        printf("Hello, c in cpp.\n");
        cppCode(123);
    }
}


void externCTest(void)
{
    /*
        C++使用链接指示linkage directive指出任意非C++函数所用的语言
        链接指示可以为单个或复合
        不能出现在类定义或函数定义内部，同样的链接指示必须在函数的每个声明中都出现
    */
    cCode(123);
}

void specialTechTest(void)
{
    memOperTest();
    rttiTest();
    enumTest();
    memberPointerTest();
    nestedClassTest();
    unionTest();
    localClassTest();
    nonportableTest();
    externCTest();
}
