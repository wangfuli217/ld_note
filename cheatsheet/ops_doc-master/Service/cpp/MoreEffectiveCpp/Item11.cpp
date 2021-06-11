#include "stdafx.h"
#include "Item11.h"

void Item11::ItemEntry()
{
  // Item11: Prevent exceptions from leaving destructors
  // 调用析构的时机：
  // 1. 正常情况下对象被析构，如离开代码scope后被销毁，或显式调用delete。
  // 2. 发生异常时，对象在异常处理机制进行propagation时被销毁
  // 因此析构被调用时，可能有异常出现也可能没有，而且析构函数无法知道是否有异常。
  // 如果在析构函数内部发生异常，C++会立即调用terminate函数结束程序执行，导致资源无法释放（包括局部变量）。
  // 可能的后果：在构造函数里开启了与数据库的事务，在析构里结束事务，但由于析构内部的异常，导致程序退出但数据库事务未结束。
  // 所以不建议在析构中抛出异常，如会抛出异常，可以在析构中try catch。
}
