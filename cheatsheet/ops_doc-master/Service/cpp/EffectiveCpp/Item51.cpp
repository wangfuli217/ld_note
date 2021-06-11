#include "stdafx.h"
#include "Item51.h"

void Item51::ItemEntry()
{
  //// Item 51: Adhere to convention when writing new and delete
  // 自定义new的时候注意正确的返回值，内存不足时调用new-handler函数，要正确处理不申请内存的请求。
  // 自定义delete的时候注意C++允许delete空指针
  // 为了处理派生类的new和delete，可以调用标准new和delete实现
}
