#include "stdafx.h"
#include "Item12.h"

void Item12::ItemEntry()
{
  //// Item 12: Copy all parts of an object
  // Copy all parts有两部分含义，1.确保拷贝自身的所有成员 2.确保拷贝基类的所有成员，详细如下：
  // 1. copy function（包括拷贝构造函数和拷贝操作符）实现之后，如果添加类成员，需要手动更新这些成员的拷贝操作到copy function
  // 2. 派生类的copy function必须调用基类对应的copy function，否则可能会因为调用非拷贝的版本导致基类的成员没有被拷贝
  // DerivedClass::DerivedClass(const DerivedClass& rhs) : BaseClass(rhs)
  // DerivedClass::operator=(const DerivedClass& rhs) { BaseClass::operator=(rhs); }

  // 注意不要在拷贝赋值操作符实现中调用拷贝构造函数，也不要反过来调用。
  // 创建private的init函数来执行相同的拷贝操作，在拷贝赋值操作符和拷贝构造函数里调用。
}
