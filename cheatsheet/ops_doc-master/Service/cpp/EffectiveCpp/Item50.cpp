#include "stdafx.h"
#include "Item50.h"

void Item50::ItemEntry()
{
  //// Item 50: Understand when it makes sense to replace new and delete
  // 不用new和delete的原因：
  // 1. 忘记delete导致内存泄漏，多次delete导致未定义行为
  // 2. 随编译器的new和delete由于通用，在特定应用场景中效率不够好
  // 3. new和delete不提供统计数据的功能


}
