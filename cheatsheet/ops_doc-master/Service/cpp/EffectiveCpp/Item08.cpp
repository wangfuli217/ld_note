#include "stdafx.h"
#include "Item08.h"

void Item08::ItemEntry()
{
  //// Item 8: Prevent exceptions from leaving destructors
  // 析构函数不应该抛出异常，在析构函数中用try catch来捕获异常
  // 可以考虑提供给类用户API来显式完成析构函数需要执行的可能抛出异常的清理工作，
  // 在析构函数里也用try catch调用此函数。如果类用户愿意执行清理并处理异常，则会调用此函数，
  // 否则由类的析构来调用并采取默认的异常捕获和处理。
}
