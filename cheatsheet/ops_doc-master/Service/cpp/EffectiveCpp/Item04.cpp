#include "stdafx.h"
#include "Item04.h"

void Item04::ItemEntry()
{
  // Item 4: Make sure that objects are initialized before they're used

  // POD (Plain Old Data)
  std::cout << "Is int a POD type: " << std::is_pod<int>() << std::endl;
  std::cout << "Is Item04 a POD type: " << std::is_pod<Item04>() << std::endl;

  // 类的成员可以在类定义时初始化（default member initializer)
  // class OneClass {
  //    NonPodClass m_nonPodMember{"initial value"};
  // };
  //
  // 也可以在类的构造函数member initialization list里初始化
  // OneClass::OneClass() : m_nonPodMember("initial value") { }
  // : m_nonPodMember("initial value") 这部分称为constructor initializer
  // m_nonPodMember("initial value")   这部分是member initializer，有多个的话就是member initializer list
  // 
  // 也可以在类的构造函数里初始化
  // OneClass::OneClass() { m_nonPodMember = NonPodClass("initial value"); }
  //
  // 对于非POD的成员，用default member initializer最好， 因为本质上是由编译器生成member initialization list,
  // 编译器可以作优化。member initialization list比构造函数内部好是因为使用直接初始化，不产生临时的中间变量，
  // 也就没有后续的拷贝或者移动操作。

  // const和引用成员必须在初始化列表里初始化，因为其不能在构造函数内部赋值
  // 父类先于子类初始化，成员按照声明的先后顺序初始化（即使在构造函数的初始化列表里顺序不同）

  // 注意：the relative order of initialization of non-local static objects defined in different translation units is undefined.
  // 意即非局部的static变量在不同的文件级编译单元里出现，其初始化在何时完成是未定义的。
  // 解决方法为使用单例模式
}
