#pragma once
#include <iostream>

// 虚继承virtual inheritance：某个类声明愿意共享其基类
// 被共享的基类子对象称为虚基类virtual base class
// 无论虚基类在继承体系中出现多少次，在派生类中包含唯一一个共享的虚基类子对象
class BaseClassVirtual
{
public:
    BaseClassVirtual()
    { std::cout << "BaseClassVirtual constructor" << std::endl; };
    virtual ~BaseClassVirtual()
    { std::cout << "BaseClassVirtual destructor" << std::endl; };

private:

};

// 派生列表的virtual表示虚继承
class BaseClassA : public virtual BaseClassVirtual
{
public:
    BaseClassA(const std::string str) : classNameA(str)
    { std::cout << "BaseClassA constructor" << std::endl; };
    virtual ~BaseClassA()
    { std::cout << "BaseClassA destructor" << std::endl; };
    std::string classNameA;
};

class BaseClassB : public virtual BaseClassVirtual
{
public:
    BaseClassB(const std::string str) : classNameB(str) 
    { std::cout << "BaseClassB constructor" << std::endl; };
    virtual ~BaseClassB()
    { std::cout << "BaseClassB destructor" << std::endl; };
    std::string classNameB;
};

// 多重继承multiple inheritance
// 派生列表中同一个基类只能出现一次（直接继承只能有一次）
// 间接继承可以多次，但派生类中会包含该类的多个子对象
class InheritedClass : public BaseClassA, public BaseClassB
{
public:
    // C++11标准允许派生类从一个或多个基类中继承构造函数，但如果继承了相同的构造函数，
    // 这个类比西为该构造函数定义自己的版本
    using BaseClassA::BaseClassA;
    using BaseClassB::BaseClassB;
    InheritedClass(const std::string str) : BaseClassA(str), BaseClassB(str) 
    { std::cout << "InheritedClass constructor" << std::endl; };;
    virtual ~InheritedClass() override
    { std::cout << "InheritedClass destructor" << std::endl; };

    // 如果虚基类BaseClassVirtual里有成员x，其他类都没有，在InheritedClass里调用x为BaseClassVirtual的x
    // 如果虚基类BaseClassVirtual里有成员x，BaseClassA或BaseClassB也有成员x，在InheritedClass里调用x为BaseClassA或BaseClassB的x
    // 如果BaseClassA和BaseClassB都有成员x，在InheritedClass里调用x有二义性

private:

};


void inheritanceTest(void);
