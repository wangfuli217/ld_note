#include "stdafx.h"
#include "Item33.h"

void Item33::ItemEntry()
{
  //// Item 33: Avoid hiding inherited names
  // 基类和派生类的关系可以想像为，基类为一段大括号内的代码，派生类为其中另一段大括号内的代码。
  // 内部范围的同名成员会隐藏外部范围的成员。注意是同名，编译器并不在乎类型，或者是函数的参数。
  // 可以在派生类里用 using Base::fun;来引入基类的fun，包括重载的fun
}
