#include "stdafx.h"
#include "Item20.h"

class Item20BaseClass
{
public:
  Item20BaseClass() { cout << "Base CTOR" << endl; }
  virtual void display() const { cout << "Base Display" << endl; }
};

class Item20DerivedClass : public Item20BaseClass
{
public:
  Item20DerivedClass() { cout << "Derived CTOR" << endl; }
  void display() const override { cout << "Derived Display" << endl; }
};

namespace
{
  void DisplayByValue(Item20BaseClass baseIns)
  { baseIns.display(); }

  void DisplayByRef(const Item20BaseClass& baseRef)
  { baseRef.display(); }
}

void Item20::ItemEntry()
{
  //// Item 20: Prefer pass-by-reference-to-const to pass-by-value
  // C++默认使用拷贝构造函数进行pass-by-value，
  // 函数参数为实际参数的拷贝，返回值也是返回对象的拷贝

  // 通过pass by reference-to-const，reference避免新对象通过拷贝产生从而减少开销
  // const保证虽然是传递引用，但函数不会改变参数的值。
  // 传引用同时还能避免slicing problem，因为引用实际是由指针实现的。

  // 适合传值的类型：built-in types and STL iterator and function object types
  // 其余传引用

  cout << "---Create instances" << endl;
  Item20DerivedClass derivedIns{};
  cout << "---Display copy-by-value" << endl;
  DisplayByValue(derivedIns); // 参数传值的函数，拷贝构造基类实例，派生类部分被slicing，只能调用到基类的display
  cout << "---Display copy-by-reference" << endl;
  DisplayByRef(derivedIns); // 引用参数的函数，传入指针，能调用到派生类的display



}
