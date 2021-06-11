#include "stdafx.h"
#include "Item13.h"

void Item13::ItemEntry()
{
  //// Item 13: Use objects to manage resources.
  // 在一段代码中先new，后执行代码，最后delete。总会因为中间代码执行出错，而导致没有delete造成泄漏。
  // 这里的use objects to manage resources指Resource Acquisition Is Initialization (RAII)，
  // 因为创建资源和初始化资源总是在一起，同时object析构的时候保证释放资源。
  // auto_ptr是RAII的一种实现
  // shared_ptr是reference-counting smart pointer (RCSP)的一种实现，能记录有多少对象指向同一个资源，
  // 当没有对象指向资源时释放资源，但不能释放成环的引用。
}
