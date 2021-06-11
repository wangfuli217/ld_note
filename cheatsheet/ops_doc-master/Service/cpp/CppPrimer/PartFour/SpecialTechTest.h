#pragma once

#include <iostream>
#include <string>

// 基类
class BaseClassForCast
{
public:
    BaseClassForCast() = default;
    ~BaseClassForCast() = default;

    virtual void dispClassVirtual(void) { std::cout << "Virtual: Base Class" << std::endl; }
    void dispClass(void) { std::cout << "Non-Virtual: Base Class" << std::endl; }
};

// 派生类
class DerivedClassForCast : public BaseClassForCast
{
public:
    DerivedClassForCast() = default;
    ~DerivedClassForCast() = default;

    virtual void dispClassVirtual(void) override { std::cout << "Virtual: Derived Class" << std::endl; }
    void dispClass(void) { std::cout << "Non-Virtual: Derived Class" << std::endl; }
};

// 前置声明枚举
enum class cpuNamesScoped; // 限定作用域枚举可以使用默认成员类型int
enum cpuNamesUnscoped : int; // 不限定作用域枚举必须指定成员类型

// C++11：限定作用域的枚举类型 scoped enumeration
// 枚举类型的作用域外不可访问枚举成员
// 枚举成员是const
// 枚举使用的类型可以指定，如unsigned long long，默认为int
enum class cpuNamesScoped : int
{ cpuIntel = 3, cpuAmd, cpuArm = 3, cpuPpc }; // 默认从0开始累加，值不唯一
// 不限定作用域的枚举类型 unscoped enumeration
// 省略class关键字，枚举名可以省略，作为未命名枚举
// 枚举成员的作用域和枚举自身的作用域相同
enum cpuNamesUnscoped { cpuIntel, cpuAmd = 15, cpuArm, cpuPpc };
//enum { cpuPpc }; // 同一作用域内的枚举成员重复定义

// 数据成员指针和成员函数指针
class MemPtrClass
{
public:
    MemPtrClass(int initInt) : intMem(initInt) {};
    ~MemPtrClass() = default;

    int intMem;
    void dispPar(std::string dispStr) { std::cout << dispStr << std::endl; }
};

// 嵌套类的定义
class OuterClass
{
public:
    class InnerClassDeclare; // 外层类外部定义嵌套类
    class InnerClassDefind // 外层类内部定义嵌套类
    {
    public:
        InnerClassDefind() { std::cout << "InnerClassDefind" << std::endl; }
    };

    OuterClass() { std::cout << "OuterClass" << std::endl; }
};

class OuterClass::InnerClassDeclare
{
public:
    InnerClassDeclare(); // 外层类外部定义构造函数
};

// Union定义
union Token
{
    char cVal;
    int iVal;
    double dVal;
};

// 匿名union anonymous union
// 在其定义的作用域内，成员都可以直接访问
// 不能包含受保护的成员或私有成员，也不能定义成员函数
static union
{
    int anonyInt;
    double anonyDouble;
};

// 位域
typedef unsigned int Bit;
class bitField
{
public:
    Bit mode : 2;       // mode占2位
    Bit modified : 1;
    Bit prot_owner : 3;
    Bit prot_group : 3;
    Bit prot_world : 3;
};


void specialTechTest(void);

