#include "stdafx.h"
#include "InheritanceTest.h"

using std::cout;
using std::endl;

void inheritanceTest(void)
{
    cout << "Test constructor and destructor call sequence" << endl;
    InheritedClass inhClassIns = InheritedClass("default");
    // 如果没有虚继承，BaseClassVirtual会被实例化两次。
    // 把BaseClassA和BaseClassB改成普通继承查看BaseClassVirtual构造函数和析构函数调用次数差别
}
