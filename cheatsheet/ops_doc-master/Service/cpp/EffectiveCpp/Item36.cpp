#include "stdafx.h"
#include "Item36.h"

namespace ITEM36
{
  class BaseClass
  {
  public:
    void NonVirtual() { cout << "BASE NonVirtual" << endl; }
    virtual void Virtual() { cout << "BASE Virtual" << endl; }
  };

  class DerivedClass : public BaseClass
  {
  public:
    void NonVirtual() { cout << "DERIVED NonVirtual" << endl; }
    void Virtual() override { cout << "DERIVED Virtual" << endl; }
  };
}

void Item36::ItemEntry()
{
  using ITEM36::BaseClass;
  using ITEM36::DerivedClass;

  //// Item 36: Never redefine an inherited non-virtual function
  BaseClass& baseRef = DerivedClass();
  DerivedClass& derivedRef = DerivedClass();

  // 以下对指针和引用都适用:
  // 调用非virtual函数时，静态绑定
  // baseRef是对BaseClass对象的引用，调基类的函数
  // derivedRef是对DerivedClass对象的引用，调派生类的函数
  // 由此可以理解为什么基类的析构函数要定义为虚函数。因为派生类无论怎样都会有自己的析构，如果基类的析构不是虚函数，在静态绑定派生类到基类引用时只能调到基类的析构。
  baseRef.NonVirtual();
  derivedRef.NonVirtual();
  // 调用virtual函数时，动态绑定
  // baseRef和derivedRef都是对DerivedClass对象的引用，调派生类的函数
  baseRef.Virtual();
  derivedRef.Virtual();
}
