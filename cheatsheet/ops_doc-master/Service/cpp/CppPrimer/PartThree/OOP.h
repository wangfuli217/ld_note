#pragma once
#include <iostream>

// 基类
// 派生类处在基类内部，当调用派生类上的成员时，先从派生类的作用域查找成员，进而依次扩展的基类的作用域
// 因此，派生类的成员将隐藏基类的同名成员
// 因此，派生类的函数会隐藏基类的同名函数，即使形参列表不同
// 如果基类中的默认构造函数、拷贝构造函数、拷贝复制运算符、析构函数是delete或不可访问，派生类中对于的成员也是被删除的。
class OperatingSystem
{
    // 基类把希望派生类各自实现的函数声明为虚函数virtual function
    // 构造函数之外的非静态函数可以为虚函数
    // virtual只能出现在类内部
    // 基类中的虚函数，在派生类中隐式地是虚函数
    // final和override出现在形参列表（包括const或引用修饰符）以及尾置返回类型之后
    // 含有纯虚函数的类是抽象基类abstract base class，定义接口，由派生类实现接口。
    // 不能创建抽象基类的对象
    // 类之间的友元关系不能传递也不能继承

public: // 派生类可以访问，类用户可以访问
    OperatingSystem() = default;
    OperatingSystem(std::string name, int ver, bool open) : osName(name), osVer(ver), osIsOpen(open) {};
    // 为了动态分配继承体系中的对象，继承关系中的根节点类一般定义虚析构函数
    // delete基类指针时，由于动态绑定，指针可能指向派生类，所以基类析构函数一般定义虚函数，在此情况下可以调用到派生类的析构函数
    virtual ~OperatingSystem() = default;

    // 虚函数
    virtual void dispOsName(void) const;
    virtual void dispOsVer(void) const;
    virtual void dispOsOpenSource(void) const final;
    // 纯虚函数 pure virtual
    // 无需定义，由派生类实现
    // 可以在类外部为纯虚函数提供定义
    virtual void dispOsMotto(void) = 0; // =0表示纯虚函数

    static void osRootInfo(void);

private: // 派生类不可访问，类用户不可访问

protected: // 派生类成员及友元可以访问，类用户不可访问
    std::string osName;
    int osVer;
    bool osIsOpen;
};

// 派生类
// 通过类派生列表class derivation list指明从哪些基类继承而来。
// 每个基类前面可以有访问说明符：public/protected/private
// 访问说明符表示类用户对继承来的成员的访问权限，即
// 派生类对基类的访问权限取决于基类的public/protected/private声明
// 派生类用户对派生类继承来的基类成员访问权限取决于派生类的访问说明符
// 基类public的成员在派生类内部可以直接访问，但如果派生类访问说明符为private，则不能通过派生类实例直接访问基类的public成员
// 派生类在其他文件中的类声明不需要包含派生列表
// struct的派生类是公有继承，class的派生类是私有继承
class OSWindows final : public OperatingSystem // c++11：final的类不能被继承
{
public:
    OSWindows() = default;
    // 派生类不能直接初始化继承来的成员，要调用基类的构造函数
    // 不显式初始化的话，基类的成员会默认初始化
    OSWindows(std::string name, int ver, bool open, bool embedded) : OperatingSystem(name, ver, open), isEmbedded(embedded) {};
    ~OSWindows() = default;

    // 派生类必须对所有重新定义的虚函数进行声明，virtual关键字可选，因为一旦被声明为虚函数，在所有派生类中都是虚函数
    // 如果派生类中虚函数同名的函数有不同的形参列表，则此函数不覆盖虚函数
    // c++11: override关键字表示派生类显式注明用此成员函数改写基类的虚函数，编译器会检查形参列表
    // 覆盖虚函数时，形参类型和返回类型必须与被覆盖的虚函数一致，除非返回类型是类本身的指针或引用
    virtual void dispOsName(void) const override; // 覆盖虚函数
    //virtual void dispOsVer(void) const override; // 不覆盖的虚函数继承基类
    //virtual void dispOsOpenSource(void) const override; // 不能覆盖final的虚函数
    virtual void dispOsMotto(void) override; // 覆盖纯虚函数，如不覆盖，派生类也为抽象类

private:
    static const std::string companyName; // 静态成员
    bool isEmbedded;
};

class OSLinux : private OperatingSystem // 私有继承
{
public:
    OSLinux() = default;
    OSLinux(std::string name, int ver, bool open) : OperatingSystem(name, ver, open) {};
    ~OSLinux() = default;

    // 改变继承自基类的成员的可访问性
    using OperatingSystem::dispOsVer;
    using OperatingSystem::dispOsOpenSource;
    // 如果using基类的构造函数，编译器会在派生类里生成对应的派生类构造函数

    virtual void dispOsName(void) const override;
    virtual void dispOsMotto(void) override;

private:
};

void testOOP(void);
