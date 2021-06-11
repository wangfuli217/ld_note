#include "stdafx.h"
#include "OOP.h"
#include <string>

using std::cout;
using std::endl;
using std::string;


void OperatingSystem::osRootInfo(void)
{
    cout << "OS ROOT INFO" << endl;
}

void OperatingSystem::dispOsName(void) const
{
    cout << "OS name: " << osName << endl;
}

void OperatingSystem::dispOsVer(void) const
{
    cout << "OS ver: " << osVer << endl;
}

void OperatingSystem::dispOsOpenSource(void) const
{
    cout << "OS open source: " << osIsOpen << endl;
}

const std::string OSWindows::companyName = string("Microsoft");
void OSWindows::dispOsName(void) const
{
    cout << OSWindows::companyName << " Product: " << osName << ". Embedded: " << isEmbedded << endl;
}

void OSWindows::dispOsMotto(void)
{
    cout << OSWindows::companyName << " Mottor: M$ Window$." << endl;
}

void printOsInfo(OperatingSystem &osIns)
{
    osIns.dispOsName();
    osIns.dispOsVer();
    osIns.dispOsOpenSource();
    osIns.dispOsMotto();
}

void OSLinux::dispOsName(void) const
{
    cout << "Linux: " << osName << endl;
}

void OSLinux::dispOsMotto(void)
{
    cout << "Liux Mottor: Open and Free." << endl;
}

void testOOP(void)
{
    /*
    面向对象程序设计三个基本概念：
    - 数据抽象： 把现实生活的事物抽象为类，将类的接口与实现分离
    - 继承：定义相似的类型并对其相似关系建模
    - 动态绑定：在一定程度忽略类型区别，以统一的方式使用它们的对象
    面向对象程序设计的核心思想是多态polymorphism，具有继承关系的多个类型称为多态类型

    继承inheritance关系的基础是基类Base class，其他类直接或间接从基类继承，称为派生类derived class

    动态绑定dynamic binding：又名运行时绑定run-time binding。
    使用基类的引用或指针调用虚函数时，动态决定调用哪个类的函数。即把派生类对象当作基类对象使用。
    称为派生类到基类derived-to-base类型转换
    派生类到基类的类型转换必须是派生类public继承基类，否则派生类用户无访问权限做类型转换
    动态绑定只有使用引用或指针调用虚函数时才会发生
    对于非引用或指针的虚函数调用，在编译期就确定

    静态类型static type：编译时已知，是变量声明时的类型或表达式生成的类型
    动态类型dynamic type：变量或表达式表示的内存中对象的类型
    表达式如果不是引用也不是指针，其动态类型和静态类型永远一致

    直接基类direct base，派生类对于基类
    间接基类indirect base，派生类的派生类对于基类

    用基类的默认（合成）拷贝和赋值操作派生类对象，只能操作基类定义的成员，派生类独有的成员被切除sliced down

    */
    OSWindows dervWin = OSWindows(string("Windows"), 10, false, false);
    OSLinux dervLinux = OSLinux(string("Ubuntu"), 17, true);

    cout << "Test virtual and override." << endl;
    cout << endl << "<WINDOWS CLASS>" << endl;
    printOsInfo(dervWin);
    // 可以用作用域限定符强制指定调用哪个虚函数，在编译时完成解析
    cout << endl << "<WINDOWS CLASS BUT CALL OS VIRTUAL" << endl;
    dervWin.OperatingSystem::dispOsName(); // 如果OSWindows继承时访问说明符为private，就不能直接调用基类的public成员
    cout << endl << "<LINUX CLASS>" << endl;
    //printOsInfo(dervLinux); // 私有继承后，类型转换不能访问
    dervLinux.dispOsName();
    dervLinux.dispOsVer();
    dervLinux.dispOsOpenSource();
    dervLinux.dispOsMotto();
    cout << endl;

}
