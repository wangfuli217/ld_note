#include "stdafx.h"
#include "Item09.h"

void Item09::ItemEntry()
{
  // Item09: Use destructors to prevent resource leaks.
  // 回收资源的操作在函数执行过程中，不管正常退出或者发生异常，都应该执行。
  // 如果把资源回收的操作放在try和catch里，则相同的释放资源代码重复出现。
  // 如果把资源回收的操作放在会泄漏的类的析构函数里，则不论如何退出函数时，都会自动释放资源。
  // 所以自然地把使用的原始指针变为使用作为类的实例的智能指针对象
}
