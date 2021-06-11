#include "stdafx.h"
#include "Item14.h"

void Item14::ItemEntry()
{
  //// Item 14: Think carefully about copying behavior in resource-managing classes.
  // 实现RAII类的时候要注意处理拷贝操作：
  // 1. 把拷贝操作置为private，不允许拷贝
  // 2. 拷贝时怎加计数，用shared_ptr实现，自定义shared_ptr的deleter
  // 3. 实现深拷贝，RAII持有的资源也拷贝一份
  // 4. 拷贝时转移RAII持有的资源

}
