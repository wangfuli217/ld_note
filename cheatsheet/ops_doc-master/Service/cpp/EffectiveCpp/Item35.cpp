#include "stdafx.h"
#include "Item35.h"

void Item35::ItemEntry()
{
  //// Item 35: Consider alternatives to virtual functions
  // Non-virtual interface (NVI) idiom: 在public的非virtual函数里调用private的虚函数。设计模式中称为template method
  // Strategy设计模式，用函数指针替代虚函数
  // Strategy设计模式，但使用function对象而非函数指针
  // 传统的Strategy设计模式
}
