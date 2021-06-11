#include "stdafx.h"
#include "Item15.h"

class Item15InnerClass
{
public:
  Item15InnerClass(string name) : m_name(name) { cout << "Item15Inner CTOR" << endl; }
  ~Item15InnerClass() { cout << "Item15Inner DTOR" << endl; }
  string m_name;
};

class Item15OuterClass
{
public:
  Item15OuterClass() { cout << "Item15OuterClass CTOR" << endl; }
  ~Item15OuterClass() { cout << "Item15OuterClass DTOR" << endl; }

  // 提供两种隐式类型转换
  operator Item15InnerClass() const { return m_inner; }
  operator int() const { return m_int; }

private:
  Item15InnerClass m_inner{"InnerName"};
  int m_int{123};
};

void UseInnerInst(Item15InnerClass innerIns)
{
  cout << innerIns.m_name << endl;
}

void UseIntPtr(int pInt)
{
  cout << pInt << endl;
}


void Item15::ItemEntry()
{
  //// Item 15: Provide access to raw resources in resource-managing classes.
  // 用get函数从auto_ptr或shared_ptr里显式转换获取原始指针
  // 直接调用重载的->或*操作符，调用原始指针的成员
  // 或提供隐式转换
  Item15OuterClass outerInst{};
  cout << "---After create outer" << endl;
  UseInnerInst(outerInst);
  cout << "---After Implicit convert to inner" << endl;
  UseIntPtr(outerInst);
  cout << "---After Implicit convert to int" << endl;
}
