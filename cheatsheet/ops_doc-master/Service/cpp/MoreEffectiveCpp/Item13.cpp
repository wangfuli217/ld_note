#include "stdafx.h"
#include "Item13.h"
#include <iostream>

namespace ITEM13
{

class Item13Base
{
public:
  virtual void whoami() { std::cout << "BaseClass" << std::endl; }
};

class Item13Derived : public Item13Base
{
public:
  virtual void whoami() override { std::cout << "DerivedClass" << std::endl; }
};

}

using ITEM13::Item13Base;
using ITEM13::Item13Derived;

void funParCopy(Item13Base baseIns)
{
  baseIns.whoami();
}

void Item13::ItemEntry()
{
  // Item13: Catch exceptions by reference.
  // catch指针是最高效的方式，但要保证抛出的指针指向的对象在离开try作用域后仍然存在，
  // 如全局对象或静态对象。
  // 注意不能使用在堆上new出来的对象，因为catch语句无法得知指针指向的是堆上的对象还是普通局部对象，
  // 所以无法得知是否要delete改指针指向的对象。
  // 四种标准异常都是对象，只能catch其值或引用：
  // 1. bad_alloc: thrown when operator new can't satisfy a memory request
  // 2. bad_cast: thrown when a dynamic_cast to a reference fails
  // 3. bad_typeid: thrown when typeid is applied to a dereferenced null pointer
  // 4. bad_exception: available for unexpected exceptions

  // catch传值有二次拷贝的效率问题，而且如果catch基类类型的话，子类对象会被slice off
  // 即catch得到的是基类部分的拷贝，调用虚函数时会调用基类的虚函数

  // catch引用（或const引用）没有以上问题。

  // Slice off测试
  Item13Base baseInsVar{};
  Item13Derived derivedInsVar{};
  Item13Base baseInsVarAno = derivedInsVar;

  std::cout << "---- Call object whoami" << std::endl;
  baseInsVar.whoami();
  derivedInsVar.whoami();
  funParCopy(derivedInsVar); // Slice off!
  baseInsVarAno.whoami(); // Slice off!

  std::cout << "---- Call reference whoami" << std::endl;
  Item13Base& baseRefDerivedIns = derivedInsVar;
  Item13Derived& derivedRefDerivedIns = derivedInsVar;
  baseRefDerivedIns.whoami();
  derivedRefDerivedIns.whoami();

  std::cout << "---- Call pointer whoami" << std::endl;
  Item13Base* basePtrDerivedIns = &derivedInsVar;
  Item13Derived* derivedPtrDerivedIns = &derivedInsVar;
  basePtrDerivedIns->whoami();
  derivedPtrDerivedIns->whoami();
}
