#include "stdafx.h"
#include "Item46.h"

void Item46::ItemEntry()
{
  //// Item 46: Define non-member functions inside templates when type conversions are desired
  // non-member的模板函数的情况下，需要先推导typename的实际类型，才能做实参的隐式类型转换。
  // 可以把non-number的函数改为在模板类里的友元non-member函数（包括函数定义），让类先推导typename的实际类型，此时函数也已经推导好类型，实参可以做隐式类型转换。
  // 但此时该友元函数因为直接定义在类声明里，会称为inline，为了减少inline的开销，可以创建helper，在友元函数里调用helper。

}
