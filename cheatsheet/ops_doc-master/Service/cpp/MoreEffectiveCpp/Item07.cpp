#include "stdafx.h"
#include "Item07.h"

void Item07::ItemEntry()
{
  // Item07: Never overload &&, ||, or ,.
  // Short-circuit evaluation: boolean expression的第一个不符合的条件出现后，后续的条件都不再执行
  // 如:
  // if ((p != 0) && (strlen(p) > 10)) ...
  // 当p指针为空时，不会执行strlen。

  // 但重载&&或||后，会把short-circuit的语义变为函数调用的语义
  // 如 if (expression1 && expression2)
  // 在类内部以成员函数形式重载时变为 if (expression1.operator&&(expression2))
  // 在全局范围内重载时变为 if (operator&&(expression1, expression2))
  // 函数调用和short-circuit区别在于
  // 1. 函数调用的所有参数都要被执行
  // 2. 函数参数的执行顺序是未定义的
  // 所以重载后无法再提供short-circuit的语义，不建议重载。

  // 逗号表达式先执行逗号左边的部分，再执行右边的部分，最终返回右边部分的结果
  // 如果全局重载逗号操作符，会导致未定义的执行顺序，无法保证先执行左边的部分
  // 类内部的重载虽然形式不同，但也无法保障执行顺序。

  
}
