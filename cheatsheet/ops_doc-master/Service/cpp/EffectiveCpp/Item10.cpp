#include "stdafx.h"
#include "Item10.h"

void Item10::ItemEntry()
{
  //// Item 10: Have assignment operators return a reference to *this
  // 可以连续赋值操作：x=y=z=5;
  // 是因为赋值操作符的实现总是返回左操作数的引用（实现时返回*this）
}

