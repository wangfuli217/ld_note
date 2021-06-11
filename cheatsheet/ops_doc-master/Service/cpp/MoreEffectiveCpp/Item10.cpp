#include "stdafx.h"
#include "Item10.h"

namespace ITEM10
{
class DummyClass
{

};
}

using namespace ITEM10;

void Item10::ItemEntry()
{
  // Item10: Prevent resource leaks in constructors.
  // C++ destorys only fully constructed objects, and an object isn't fully constructed until
  // its constructor has run to completion.
  // 如果类有原始指针的成员，在其初始化时（在构造函数内，或在初始化成员列表中）可能会抛出异常，此时需要设法catch到异常并做资源释放。
  // 比较好的方法是使用智能指针，异常发生时，已经创建的智能指针的析构函数会自动销毁其指向的堆对象。

  // 原文：Because C++ guarantees it's safe to delete null pointers, 
  // BookEntry's destructor need not check to see if the pointers actually point to something before deleting them.
  // 意思是null的指针可以被delete。注意delete操作并不会置被delete的指针为null。delete同一个指针两次是非法操作。
  // 可用以下代码测试。
  DummyClass *pDummyClass = new DummyClass();
  delete pDummyClass;
  pDummyClass = nullptr; // 去掉赋值nullptr语句会导致二次delete而崩溃
  delete pDummyClass;
  pDummyClass = NULL;
  delete pDummyClass;
}
