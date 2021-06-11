#include "stdafx.h"
#include "Item14.h"

void Item14::ItemEntry()
{
  // Item14: Use exception specifications judiciously
  // 指定无异常的函数不会抛出异常，如：
  // void function() throw();
  // 不指定异常的函数可能抛出任何异常，如：
  // void function1();
  // 指定int类型异常的函数只会抛出int类型的异常，如：
  // void function2() throw(int);
  // 但在function2里可以调用function1，抛出的非int异常会导致unexpected被调用。

  // 为了避免这类冲突，注意：
  // 1. 不要堆模板指定异常，因为不同类型的模板实例可能导致产生各种未预期的异常
  // 2. 如果某函数调用到的函数有未指定异常的，则该函数不要指定异常
  // 3. 总是处理系统异常，如bad_alloc

}
