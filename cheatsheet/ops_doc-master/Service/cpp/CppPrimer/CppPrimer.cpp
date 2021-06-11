// 基于C++ Primer第五版的笔记

#include "stdafx.h"
#include "PartOne/CppPrimerBasic.h"
#include "PartOne/CppPrimerFriend.h"
#include "PartOne/CppPrimerAggregate.h"
#include "PartOne/CppPrimerLiteral.h"
#include "PartTwo/StdLibIO.h"
#include "PartTwo/StdLibContainer.h"
#include "PartTwo/DynamicMem.h"
#include "PartThree/ClassFeatures.h"
#include "PartThree/OverloadCast.h"
#include "PartThree/OOP.h"
#include "PartThree/TemplateGeneric.h"
#include "PartFour/StdLibTest.h"
#include "PartFour/NamespaceTest.h"
#include "PartFour/InheritanceTest.h"
#include "PartFour/ExceptionTest.h"
#include "PartFour/SpecialTechTest.h"
#include <iostream>
#include <string>
using std::cout;
using std::endl;
using std::cin;
using std::string;

// Part one: C++基础
void partOne(void)
{
    // 常量表达式
    const int constIntVar1 = 20; // constIntVar1是常量表达式
    const int constIntVar2 = constIntVar1 + 1; // constIntVar2是常量表达式
    int nonConstIntVar = 27; // nonConstIntVar不是常量表达式，虽然初始值为常量，但类型为普通int
                             //const int constIntVar3 = get_size(); // constIntVar3不是常量表达式，因为其值到运算时才得到

    class CppPrimer cppPrimerIns = CppPrimer(); // 声明类对象时，类名前可不加class或struct关键字
    //outsideClassFunc(cppPrimerIns);
    //outsideClassFunc(123);
    //cppPrimerIns.displayArithTypes();
    //cppPrimerIns.varInitTest();
    //cppPrimerIns.ptrRefTest();
    //cppPrimerIns.stringTest();
    //cppPrimerIns.vectorTest();
    //cppPrimerIns.iteratorTest();
    //cppPrimerIns.arrayTest();
    //cppPrimerIns.exceptionTest();
    //cppPrimerIns.exceptionTest();
    cppPrimerIns.functionTest();
    //cppPrimerIns.assertTest();
    //cppPrimerIns.constMemFunction(1).constMemFunction(2); // 非常量对象调用非常量版本
    const CppPrimer cppPrimerConstIns = CppPrimer();
    //cppPrimerConstIns.constMemFunction(3).constMemFunction(4); // 常量对象调用常量版本
    CppPrimer cppPrimerStrIns = CppPrimer(CppPrimer::CppPrimerStrUsing("Hello, constructor!"));
    //friendFunc(cppPrimerStrIns);
    CppPrimer cppPrimerCharIns = CppPrimer('F');
    // 隐式类类型转换，bool参数被隐式转换为调用CppPrimer(bool boolInitVal)构造的对象
    //cppPrimerCharIns.convertingConstructorTest(false);
    // 去掉CppPrimer(CppPrimerStr initStr)构造的explicit关键字，才能用如下语句做隐式类类型转换
    //cppPrimerCharIns.convertingConstructorTest(string("test"));
    CppPrimer cppPrimerDefaultIns = CppPrimer();
    CppPrimer &cppPrimerRef = cppPrimerDefaultIns;
    CppPrimer *cppPrimerPtr = &cppPrimerDefaultIns;
    cppPrimerDefaultIns.staticFuncTest(string("Zero")); // 类对象访问静态成员函数
    cppPrimerRef.staticFuncTest(string("First")); // 类对象引用访问静态成员函数
    cppPrimerPtr->staticFuncTest(string("Second")); // 类对象指针访问静态成员函数
                                                    // 作用域运算符直接访问静态成员函数
    CppPrimer::staticFuncTest(string("Thrid"));

    CppPrimerFriend cppPrimerFriendIns = CppPrimerFriend();
    //cppPrimerFriendIns.useCppPrimerPrivate(cppPrimerIns);
    //cppPrimerIns.toBeFriendOfCppPrimerFriend(cppPrimerFriendIns);

    // 创建聚合类的实例
    CppPrimerAggregate cppPrimerAggregateIns = CppPrimerAggregate();
    // 用声明顺序的实参列表初始化聚合类
    CppPrimerAggregate cppPrimerAggregateInsInit = { string("Hello"), 123 };

    // 创建字面值常量类实例
    CppPrimerLiteral cppPrimerLiteralIns = CppPrimerLiteral(false);
}

// Part two: C++标准库
void partTwo(void)
{
    // iostream处理控制台IO
    // fstream处理文件IO
    // stringstream处理内存string的IO

    StdLibIO stdLibIOIns = StdLibIO();
    //stdLibIOIns.conditionState();
    //stdLibIOIns.outputBuffer();
    //stdLibIOIns.fileStream();
    //stdLibIOIns.stringStream();

    StdLibContainer stdLibContainer = StdLibContainer();
    //stdLibContainer.testContainer();
    //stdLibContainer.testGeneric();
    //stdLibContainer.testIterator();

    DynamicMem dynamicMem = DynamicMem();
    dynamicMem.DynamicMemTest();
}

// Part three: 类设计者的工具
void partThree(void)
{
    testClassFeatures();
    //testOverloadCast();
    //testOOP();
    //testTemplateGeneric();
}

// Part four: 高级主题
void partFour(void)
{
    //stdLibTest();
    //exceptionTest();
    //namespaceTest();
    //inheritanceTest();
    specialTechTest();
}

int main(int argc, char *argv[])
{
    // main命令行参数
    // argv[0]是程序自身的名字
    // 打印整条命令
    for (int i = 0; i != argc; i++)
    { cout << argv[i] << " "; }
    cout << endl;
    // 打印参数
    for (auto argvP = argv + 1; argvP != argv + argc; ++argvP)
    //for (char **argvP = argv + 1; argvP != argv + argc; ++argvP)
    { cout << *argvP << " "; }
    cout << endl << endl;

    //partOne();
    //partTwo();
    partThree();
    //partFour();

  // 系统调用 "Press any key to continue..."
  //system("pause");
  //system("pwd");

    // 允许main没有return语句直接结束，编译器插入返回0的return语句表示执行成功
    return EXIT_SUCCESS;
}

