#pragma once

#include <string>
#include <vector>
#include <initializer_list>
#include <iostream>
#include "Common/CommonUtils.h"

typedef int intAry3[3];
using intAry3Using = int[3];

// struct和class的区别：可以用任意一个定义类。
// 区别在于，struct定义的类，在第一个访问说明符之前的成员是public的；
// class定义的类，在第一个访问说明符之前的成员是private的。
// 当希望所有成员都是public时，用struct，否则用class 

class CppPrimer
{
    //// 友元函数声明
    // 如果要把多个重载函数作为友元函数，必须对每一个重载函数进行友元声明，因为重载函数是不同的函数
    friend void friendFunc(CppPrimer cppPrimerIns);
    
    //// 友元类声明
    // 友元关系不存在传递性，CppPrimerFriend的友元不会自动成为CppPrimer的友元
    // 每个类负责控制自己的友元
    friend class CppPrimerFriend;

public:

    //// 类型成员
    typedef std::string CppPrimerStr;
    using CppPrimerStrUsing = std::string;

    //// 构造、析构
    // 显式声明默认构造函数
    // = default 要求编译器生成合成构造函数
    CppPrimer() = default;

    // 冒号后为构造函数初始值列表，列表忽略的成员用类内初始值初始化或者默认值初始化
    CppPrimer(bool boolInitVal) 
        : arithType_bool(boolInitVal)
    { std::cout << "Constructor(bool)" << std::endl; }

    CppPrimer(bool boolInitVal, char charInitVal, wchar_t wcharInitVal)
        : arithType_bool(boolInitVal), arithType_char(charInitVal), arithType_wchar(wcharInitVal) 
    { std::cout << "Constructor(bool, char, wchar_t)" << std::endl; }

    // 参数为string
    // 只有一个参数的构造函数可以作为隐式类型转换
    // 多个参数的构造函数如果只有一个参数没有默认值，也属于可以使用explicit的构造函数
    // explicit关键字阻止编译器为此构造函数的参数做隐式类类型转换，隐式类型转换语句非法：CppPrimer ins = 123;
    // 多个参数的构造函数如果有两个以上参数没有默认值，则不能作为隐式类类型转换，所以explicit只对单参数构造函数有效
    // explicit关键字只允许出现在类内部的构造函数声明处，类外部的定义不能加explicit
    explicit CppPrimer(CppPrimerStr initStr);
    
    // C++11引入委托构造函数，一个构造函数使用其所属类的其他构造函数执行部分或全部初始化工作。
    // 调用其他构造函数，传入一个参数，无其他操作
    CppPrimer(int iInitVal)
        : CppPrimer(true) 
    { }

    // 调用其他构造函数，传递自己的实参，无其他操作
    CppPrimer(int iInitVal, bool bInitVal) : CppPrimer(bInitVal) 
    { }

    // 先执行被委托的构造函数，在执行委托构造函数
    CppPrimer(char cInitVal)
        : CppPrimer(std::string("Delegated constructor")) 
    { std::cout << "Delegating constructor" << std::endl; }

    ~CppPrimer();

    //// 只打印消息的函数
    void showInfo(void)
    { std::cout << "/!\\showInfo()." << std::endl; } // 定义在类内部的函数是隐式的inline

    //// 显示私有成员中算数类型变量的值
    void displayArithTypes(void);

    //// 测试各种初始化的方式
    void varInitTest(void);

    //// 指针/引用/const相关
    void ptrRefTest(void);

    //// 字符串
    void stringTest(void);
  
    //// 向量
    void vectorTest(void);
  
    //// 迭代器
    void iteratorTest(void);

    //// 数组
    void arrayTest(void);
    
    //// 异常
    void exceptionTest(void);
    
    //// 函数相关
    void functionTest(void);
    
    //// 重载
    // 同一作用域内的几个函数名字相同但形参列表不同（形参数量或类型）
    // 编译器根据实参类型判断调用的是哪个函数。编译期决定！
    // 不允许只有返回值不同的多个函数存在
    // main不能重载
    // 形参有顶层const和没有顶层const是一样的，重载时要注意；底层const能实现重载
    void overloadTest(int intArg);
    //void overloadTest(const int intArg); // 顶层const，重复声明
    void overloadTest(int *intPtrArg);
    //void overloadTest(int * const intPtrArg); // 顶层const，重复声明
    void overloadTest(const int* intPtrArg); // 底层const，const指针，重载
    void overloadTest(int &intRefArg); // 普通引用
    void overloadTest(const int &intRefArg); // 底层const，const引用，重载

    // const_cast用于重载
    const std::string &shorterString(const std::string &s1, const std::string &s2);
    std::string &shorterString(std::string &s1, std::string &s2);
    
    //// 默认实参
    void defaultParValTest(int intVal = 1, char charVal = '2', double doubleVal = 3.0);
    
    //// 内联函数
    inline void inlineTest(void);
    // 内联函数和constexpr函数可以多次定义，但定义必须完全一致，所以通常定义在头文件中。
    
    //// 断言
    void assertTest(void);
    
    //// const成员函数
    const CppPrimer &constMemFunction(int iVal) const; // 返回对象引用，以便级联调用
    CppPrimer &constMemFunction(int iVal); //非const成员函数重载const成员函数

    // 类不能包含类型为自己的成员，因为编译器需要知道类占多少存储空间。
    // 但类只要出现名称之后，就视为被声明，因此类允许包含指向自己类型的引用或指针
    void classRefPtrTest(CppPrimer &classRef, CppPrimer *classPtr);

    //// 函数作为CppPrimerFriend类的友元
    void toBeFriendOfCppPrimerFriend(CppPrimerFriend insCppPrimerFriend);

    //// 测试隐式类类型转换
    void convertingConstructorTest(CppPrimer insCppPrimer);

    //// 静态成员函数
    // 不能声明为const，也不能包含this指针
    static void staticFuncTest(std::string newStaticStrVar);

private:

    //// 静态成员
    // 静态成员与类本身直接相关，而不与对象保持关联
    // 所有对象共享静态成员对象
    // 可以是常量、引用、指针、类类型，可以是public或private
    // 静态成员不能在创建类对象时被定义，不是构造函数初始化的，不能在类内部初始化
    // 必须在类外部定义和初始化静态成员
    static std::string staticStrVar;
    // 静态成员可以但非静态成员不可以的操作
    static CppPrimer staticCppPrimerInt; // 类型可以是所属的类类型
    void staticParameterTest(std::string strVar = staticStrVar) {} // 静态成员作为默认实参


  //// 算数类型变量
  // 最小尺寸规范未定义
  bool arithType_bool = false;
  // 最小尺寸8-bit. 有三种类型：char/unsigned char/signed char，
  // char不一定是signed，由编译器决定
  char arithType_char = u8'A'; 
  // 最小尺寸16-bit
  wchar_t arithType_wchar = L'B'; // 用L开通表示wchar_t，字符串用L开头表示wstring。MFC和Win32程序中使用_T()和_TEXT()宏
  // 最小尺寸16-bit Unicode
  char16_t arithType_char16 = u'测';
  // 最小尺寸32-bit Unicode
  char32_t arithType_char32 = U'试';
  // 最小尺寸16-bit
  short arithType_short = 32767;
  // 最小尺寸16-bit, VS下32-bit
  unsigned int arithType_int = 65535u;
  // 最小尺寸32-bit
  long arithType_long = 2147483647L;
  // 最小尺寸64-bit
  long long arithType_longlong = 9223372036854775807LL;
  // 6位有效数字
  float arithType_float = 0.123456F;
  // 10位有效数字
  double arithType_double = 0.0123456789;
  // 10位有效数字
  long double arithType_longdouble = 0.0987654321L;
  // 指针
  short *arithType_ptr = nullptr;
    // 数组
    intAry3 intAry3Var{ 1, 2, 3 }; // 类内初始值必须使用=做初始化或使用{}直接初始化
    // 可变数据成员，即使在const成员函数里也可以改变mutable成员的值
    mutable int mutableVar = 0; // 类内初始值必须使用=做初始化或使用{}直接初始化

    //// 打印数组
    void CppPrimer::printIntAry(int intAry[], int size);
    
    //// 抛出异常用
    void exceptionThrower(void);
    void exceptionThrower(int intVal); // 重载成员函数
    
    //// 可变数量形参
    void initializerListTest(std::initializer_list<std::string> args, std::string extVal);
    
    //// 列表返回值
    std::vector<std::string> listReturnTest(void);
    
    //// 返回数组指针
    intAry3* funcReturnIntAry3(void);
    intAry3Using* funcReturnIntAry3Using(void);
    int(*funcReturnIntAry3Plain(void))[3];
    auto funcReturnIntAry3Tail(void) -> int(*)[3];
    decltype(intAry3Var) *funcReturnIntAry3Decltype(void);
};

//// 非成员接口函数
void outsideClassFunc(CppPrimer cppPrimerIns);
void outsideClassFunc(int iVal); // 非成员函数重载
void friendFunc(CppPrimer cppPrimerIns); // 友元函数

//// constexpr函数
constexpr int constexprFuncTest(int x) { return 123 * x; }

//// 可变参数包

// 用于结束模板函数的递归调用，必须在可变参数版本之前

template <typename T>
T printT(const T &t)
{
    std::cout << t << " ";
    return t;
}

template <typename T>
void variadicTemplate(const T &t)
{
    std::cout << endl << "variadicTemplate called without rest:" << endl
        << "\tt is: " << t << endl;
}

// 用...指出一个模板参数或函数参数是一个包。
// Args是模板参数包，表示零个或多个模板类型参数
// rest是函数参数包，表示零个或多个函数参数
// 下面的例子表示variadicTemplate是可变参数函数模板，
// 有名为T的类型参数，名为Args的模板参数包，可以表示零个或多个额外的类型参数。
// 函数参数列表里包含const &类型的参数，指向T的类型；包含名为rest的函数参数包，表示零个或多个函数参数
// 实际调用时，推导如下：
// int i=0; double d=3.14; string s="hello";
// variadicTemplate(i, s, 123, d); // 包中有3个参数，编译器实例化出 void variadicTemplate(const int&, const string&, const int&, const double&);
// variadicTemplate(s, 123, d);    // 包中有2个参数，编译器实例化出 void variadicTemplate(const string&, const int&, const double&);
// variadicTemplate(s, i);         // 包中有1个参数，编译器实例化出 void variadicTemplate(const string&, const int&);
// variadicTemplate("test");       // 空包，编译器实例化出 void variadicTemplate(const char[5]&);
template <typename T, typename... Args>
void variadicTemplate(const T &t, const Args&... rest) // 用...扩展Args
{
    // 用sizeof...获取模板参数包或函数参数包的实际数量
    size_t argsSize = sizeof...(Args);
    size_t restSize = sizeof...(rest);
    std::cout << endl << "variadicTemplate called with rest:" << endl
        << "\tArgs contains " << argsSize << " values." << endl
        << "\trest contains " << restSize << " values." << endl
        << "\tt is: " << t << endl
        << "\trest is: ";
    
    // 递归调用，但不传递t，而是把rest的第一个实参绑定到t，使每次递归减少rest的实参
    // 最终因为非可变参数的重载函数更特例化，调用其终止递归
    variadicTemplate(rest...); // 用...扩展rest，扩展成实参列表
    //variadicTemplate(printT(rest)...); // 用...扩展printT(rest)，相当于对每个实参调用printT()
}
