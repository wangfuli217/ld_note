#include "stdafx.h"
#include "Item02.h"

void Item02::ItemEntry()
{
  // Item02: Prefer C++-style casts.

  // static_cast类似于C的类型转换。不能转换constness。
  // const_cast用于只转换constness和volatileness。
  // dynamic_cast只用于在继承层级中，把指针或引用从基类转换为派生类或兄弟类，并可通过检测转换结果是否为null来判断转换是否成功。
  // reinterpret_cast和底层实现绑定，移植性差

  // 对于shared_ptr用对应的：
  // static_pointer_cast, dynamic_pointer_cast, const_pointer_cast, reinterpret_pointer_cast
}
